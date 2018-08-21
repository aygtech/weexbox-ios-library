//
//  UpdateManager.swift
//  Cornerstone
//
//  Created by Mario on 2018/6/6.
//  Copyright © 2018年 Mario. All rights reserved.
//

import Foundation
import Alamofire
import Alamofire_Synchronous
import Async
import RealmSwift
import HandyJSON
import SwiftyVersion
import Zip

/// 热更新
@objcMembers public class UpdateManager: NSObject {
    
    @objc public enum UpdateState: Int {
        case Unzip // "解压文件"
        case UnzipError // "解压文件出错"
        case UnzipSuccess // "解压文件成功"
        case GetServer // "获取服务器路径"
        case GetServerError // "获取服务器路径出错"
        case DownloadConfig // "下载配置文件"
        case DownloadConfigError // "下载配置文件出错"
        case DownloadConfigSuccess // "下载配置文件成功"
        case DownloadMd5 // "下载md5文件"
        case DownloadMd5Error // "下载Md5出错"
        case DownloadMd5Success // "下载md5文件成功"
        case DownloadFile // "下载文件"
        case DownloadFileError // "下载文件出错"
        case DownloadFileSuccess // "下载文件成功"
        case UpdateSuccess // "更新成功"
        case CanEnterApp // "可以进入App"
    }
    
    public typealias Completion = (UpdateState, Double, Error?, URL?) -> Void
    
    private static let resourceName = "www"
    private static let oneName = "weexbox-update-one"
    private static let twoName = "weexbox-update-two"
    private static let workingNameKey = "weexbox-update-working-key"
    private static let workingName = UserDefaults.standard.string(forKey: workingNameKey) ?? oneName
    private static let cacheName: String = {
        if workingName == oneName {
            return twoName
        }
        return oneName
    }()
    
    private static let zipName = "www.zip"
    private static let md5Name = "weexbox-md5.json"
    private static let configName = "weexbox-config.json"
    
    private static let resourceUrl = Bundle.main.bundleURL.appendingPathComponent(resourceName)
    private static let resourceConfigUrl = resourceUrl.appendingPathComponent(configName)
    private static let resourceMd5Url = resourceUrl.appendingPathComponent(md5Name)
    private static let resourceZipUrl = resourceUrl.appendingPathComponent(zipName)
    
    private static let workingUrl = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first!).appendingPathComponent(workingName)
    private static let workingConfigUrl = workingUrl.appendingPathComponent(configName)
    
    private static let cacheUrl = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first!).appendingPathComponent(cacheName)
    private static let cacheConfigUrl = cacheUrl.appendingPathComponent(configName)
    
    private static var serverConfigUrl: URL!
    private static var serverMd5Url: URL!
    private static var serverUrl: URL! {
        didSet {
            serverConfigUrl = serverUrl.appendingPathComponent(configName)
            serverMd5Url = serverUrl.appendingPathComponent(md5Name)
        }
    }
    private static var serverWwwUrl: URL!
    
    private static var completion: Completion!
    
    private static let realmDefaultConfig = Realm.Configuration()
    private static let workingRealm: Realm = {
        var realmConfig = realmDefaultConfig
        realmConfig.fileURL = realmConfig.fileURL!.deletingLastPathComponent().appendingPathComponent(workingName + ".realm")
        return try! Realm(configuration: realmConfig)
    }()
    private static let cacheRealmConfig: Realm.Configuration = {
        var realmConfig = realmDefaultConfig
        realmConfig.fileURL = realmConfig.fileURL!.deletingLastPathComponent().appendingPathComponent(cacheName + ".realm")
        return realmConfig
    }()
    private static let cacheRealm: Realm = {
        return try! Realm(configuration: cacheRealmConfig)
    }()
    
    private static var resourceConfig: UpdateConfig!
    private static var resourceMd5: [UpdateMd5?]!
    private static var workingConfig: UpdateConfig?
    private static var cacheConfig: UpdateConfig?
    private static var serverConfigData: Data!
    
    // 设置更新服务器
    public static func setServer(url: URL) {
        serverWwwUrl = url
    }
    
    // 检查更新
    public static func update(completion: @escaping Completion) {
        self.completion = completion
        loadLocalConfig()
        loadLocalMd5()
        if isWwwFolderNeedsToBeInstalled(config: workingConfig) {
            // 将APP预置包解压到工作目录
            unzipWwwToWorking()
        } else {
            enterApp()
        }
    }
    
    // 获取完整路径
    public static func getFullUrl(file: String) -> URL {
        return workingUrl.appendingPathComponent(file)
    }
    
    
    
    // 将APP预置包解压到工作目录
    private static func unzipWwwToWorking() {
        unzipWww(to: workingUrl, md5: resourceMd5, db: workingRealm)
    }
    
    private static func unzipWwwToCache() {
        unzipWww(to: cacheUrl, md5: resourceMd5, db: cacheRealm)
    }
    
    // 静默更新
    private static func update() {
        if isWwwFolderNeedsToBeInstalled(config: cacheConfig) {
            // 将APP预置包解压到缓存目录
            unzipWwwToCache()
        } else {
            getServer()
        }
    }
    
    private static func getServer() {
        complete(.GetServer)
        Alamofire.request(serverWwwUrl).validate().responseString { response in
            switch response.result {
            case .success(let value):
                serverUrl = serverWwwUrl.deletingLastPathComponent().appendingPathComponent(value)
                // 获取服务端config文件
                downloadConfig()
            case .failure(let error):
                complete(.GetServerError, 0, error)
            }
        }
    }
    
    private static func enterApp() {
        // 返回工作目录地址
        complete(.CanEnterApp, 100, nil, workingUrl)
        // 开始静默更新
        update()
    }
    
    /// 加载本地的config
    private static func loadLocalConfig() {
        resourceConfig = loadConfig(resourceConfigUrl)!
        workingConfig = loadConfig(workingConfigUrl)
        cacheConfig = loadConfig(cacheConfigUrl)
    }
    
    private static func loadConfig(_ url: URL) -> UpdateConfig? {
        var config: UpdateConfig?
        do {
            let data = try Data(contentsOf: url)
            let s = String(data: data, encoding: .utf8)
            config = UpdateConfig.deserialize(from: s)
        } catch {
            config = nil
        }
        return config
    }
    
    /// 加载本地的Md5
    private static func loadLocalMd5() {
        let data = try! Data(contentsOf: resourceMd5Url)
        let s = String(data: data, encoding: .utf8)
        resourceMd5 = [UpdateMd5].deserialize(from: s)!
    }
    
    // 获取服务端config文件
    private static func downloadConfig() {
        complete(.DownloadConfig)
        Alamofire.request(serverConfigUrl).validate().responseData { response in
            switch response.result {
            case .success(let value):
                complete(.DownloadConfigSuccess)
                serverConfigData = value
                let serverConfig = UpdateConfig.deserialize(from: String(data: serverConfigData, encoding: .utf8))!
                // 是否需要更新
                if shouldDownloadWww(serverConfig: serverConfig) {
                    downloadMd5()
                } else {
                    complete(.UpdateSuccess, 100, nil, workingUrl)
                }
            case .failure(let error):
                complete(.DownloadConfigError, 0, error)
            }
        }
    }
    
    private static func shouldDownloadWww(serverConfig: UpdateConfig) -> Bool {
        let appBuild = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        if Version(appBuild) >= Version(serverConfig.ios_min_version), Version(serverConfig.release) > Version(cacheConfig!.release) {
            return true
        }
        return false
    }
    
    private static func isWwwFolderNeedsToBeInstalled(config: UpdateConfig?) -> Bool {
        if config == nil || Version(resourceConfig.release) > Version(config!.release) {
            return true
        }
        return false
    }
    
    private static func unzipWww(to: URL, md5: [UpdateMd5?], db: Realm) {
        try! db.write {
            db.deleteAll()
        }
        Async.background {
            try? FileManager.default.removeItem(at: to)
            do {
                try Zip.unzipFile(resourceZipUrl, destination: to, overwrite: true, password: nil, progress: { (unzipProgress) in
                    Async.main {
                        if to == workingUrl {
                            complete(.Unzip, unzipProgress)
                        }
                    }
                })
                Async.main {
                    unzipSuccess(to: to, md5: md5, db: db)
                }
            } catch {
                Async.main {
                    complete(.UnzipError, 0, error)
                }
            }
        }
    }
    
    // 解压www成功
    private static func unzipSuccess(to: URL, md5: [UpdateMd5?], db: Realm) {
        complete(.UnzipSuccess, 100)
        // 保存Md5到数据库中
        saveMd5(md5, db: db)
        // 保存config
        try! FileManager.default.copyItem(at: resourceConfigUrl, to: to.appendingPathComponent(configName))
        loadLocalConfig()
        if to == cacheUrl {
            getServer()
        } else {
            // 解压到了工作目录，可以进入App
            UserDefaults.standard.set(workingName, forKey: workingNameKey)
            enterApp()
        }
    }
    
    private static func downloadMd5() {
        complete(.DownloadMd5)
        Alamofire.request(serverMd5Url).validate().responseString { response in
            switch response.result {
            case .success(let value):
                complete(.DownloadMd5Success)
                let serverMd5 = [UpdateMd5].deserialize(from: value)!
                
                var downloads: [UpdateMd5?]!
                Async.background {
                    downloads = getDownloadFiles(serverMd5: serverMd5)
                    }.main {
                        if downloads.count > 0 {
                            download(files: downloads)
                        } else {
                            saveConfig()
                            complete(.UpdateSuccess, 0, nil, cacheUrl)
                        }
                }
            case .failure(let error):
                complete(.DownloadMd5Error, 0, error)
            }
        }
    }
    
    private static func getDownloadFiles(serverMd5: [UpdateMd5?]) -> [UpdateMd5?] {
        let cacheBackgroundRealm = try! Realm(configuration: cacheRealmConfig)
        let cacheMd5 = cacheBackgroundRealm.objects(Md5Realm.self)
        var downloadFiles = [UpdateMd5?]()
        for file in serverMd5 {
            if shouldDownload(serverFile: file!, cacheMd5: cacheMd5) {
                downloadFiles.append(file)
            }
        }
        return downloadFiles
    }
    
    private static func shouldDownload(serverFile: UpdateMd5, cacheMd5: Results<Md5Realm>) -> Bool {
        for cacheFile in cacheMd5 {
            if cacheFile.path == serverFile.path && cacheFile.md5 == serverFile.md5 {
                return false
            }
        }
        return true
    }
    
    private static func download(files: [UpdateMd5?], index: Int = 0, retry: Int = 5) {
        let progress = Double(index) / Double(files.count)
        complete(.DownloadFile, progress)
        if index == files.count {
            downloadSuccess(files: files)
        } else {
            let file = files[index]!
            let path = file.path!
            let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                let fileURL = cacheUrl.appendingPathComponent(path)
                return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
            }
            let url = serverUrl.appendingPathComponent(path)
            Alamofire.download(url, to: destination).validate().responseData { response in
                switch response.result {
                case .success(_):
                    downloadSuccess(file: file)
                    download(files: files, index: index + 1)
                case .failure(let error):
                    if retry == 0 {
                        complete(.DownloadFileError, 0, error)
                    } else {
                        download(files: files, index: index, retry: retry - 1)
                    }
                }
            }
        }
    }
    
    private static func downloadSuccess(file: UpdateMd5) {
        try! cacheRealm.write {
            cacheRealm.add(file.toRealm(), update: true)
        }
    }
    
    // 所有下载成功
    private static func downloadSuccess(files: [UpdateMd5?]) {
        complete(.DownloadFileSuccess, 1)
        saveMd5(files, db: cacheRealm)
        saveConfig()
        UserDefaults.standard.set(cacheName, forKey: workingNameKey)
        complete(.UpdateSuccess, 0, nil, cacheUrl)
    }
    
    private static func complete(_ state: UpdateState, _ progress: Double = 0, _ error: Error? = nil, _ url: URL? = nil) {
        completion(state, progress, error, url)
    }
    
    private static func saveConfig() {
        try! serverConfigData.write(to: cacheConfigUrl, options: .atomic)
    }
    
    private static func saveMd5(_ files: [UpdateMd5?], db: Realm) {
        try! db.write {
            db.deleteAll()
            for file in files {
                db.add(file!.toRealm())
            }
        }
    }
}

