//
//  WXDevPlugin.swift
//  WeexBox
//
//  Created by Mario on 2018/8/27.
//  Copyright © 2018年 Ayg. All rights reserved.
//

import Foundation
import WXDevtool
import SocketRocket

@objc public extension WXDevPlugin {
    
    func pluginWillOpen(inContainer: UIViewController, withArg: Array<Any>) {
        let topViewController = WBBaseViewController.topViewController()
        let scannerViewController = WBScannerViewController()
        scannerViewController.scanResultBlock = { [weak self] (scanResult, error) in
            if error != nil {
                Log.e(error!)
            } else {
                self?.openUrl(scanResult.strScanned!, top: topViewController)
            }
        }
        topViewController?.navigationController?.pushViewController(scannerViewController, animated: true)
    }
    
    func openUrl(_ urlString: String, top: UIViewController?) {
        let params = urlString.getParameters()
        if let devtoolUrl = params["_wx_devtool"] {
            // 连服务
            WXDevTool.launchDebug(withUrl: devtoolUrl)
        } else if let tplUrl = params["_wx_tpl"] {
            // 连页面
            let vc = WBWeexViewController()
            let url = URL(string: tplUrl)!
            vc.url = url
            let socketURL = URL(string: "ws://\(url.host!):\(url.port!)")!
            vc.setHotReloadURL(socketURL)
            top?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func remoteDebug(url: URL) -> Bool {
        if url.scheme == "ws" {
            WXSDKEngine.connectDebugServer(url.absoluteString)
            WXSDKEngine.initSDKEnvironment()
            return true
        }
        let query = url.query!
        for param in query.components(separatedBy: "&") {
            let elts = param.components(separatedBy: "=")
            if elts.count < 2 {
                continue
            }
            if elts.first == "_wx_debug" {
                WXDebugTool.setDebug(true)
                WXSDKEngine.connectDebugServer(elts.last!.removingPercentEncoding)
                //loadWeex()
                return true
            } else if elts.first! == "_wx_devtool" {
                let devToolURL = elts.last!.removingPercentEncoding
                WXDevTool.launchDebug(withUrl: devToolURL)
                //loadWeex()
                return true
            }
        }
        return false
    }
    
    func loadWeex() {
        
    }
    
    func jsReplace(url: URL) {
        if url.host == "weex-remote-debugger" {
            let path = url.path
            if path == "/dynamic/replace/bundle" {
                for param in url.query!.components(separatedBy: "&") {
                    let elts = param.components(separatedBy: "=")
                    if elts.count < 2 {
                        continue
                    }
                    if elts.first == "bundle" {
                        WXDebugTool.setReplacedBundleJS(URL(string: elts.last!)!)
                    }
                }
            }
            if path == "/dynamic/replace/framework" {
                for param in url.query!.components(separatedBy: "&") {
                    let elts = param.components(separatedBy: "=")
                    if elts.count < 2 {
                        continue
                    }
                    if elts.first == "framework" {
                        WXDebugTool.setReplacedJSFramework(URL(string: elts.last!)!)
                    }
                }
            }
        }
    }

}
