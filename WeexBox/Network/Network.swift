//
//  Network.swift
//  WeexBox
//
//  Created by Mario on 2018/8/18.
//  Copyright © 2018年 Ayg. All rights reserved.
//

import Foundation
import Alamofire

open class Network {
    
    open static var sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 15
        return SessionManager(configuration: configuration)
    }()
    
    /// 请求接口
    ///
    /// - Parameters:
    ///   - url: 接口地址
    ///   - method: HTTP方法. 默认`.get`
    ///   - parameters: HTTP参数. 默认`nil`.
    ///   - headers: HTTP头. 默认`nil`.
    ///   - callback: 请求回调
    open static func request(url: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, headers: HTTPHeaders? = nil, callback: @escaping (Result) -> Void) {
        var encoding: ParameterEncoding = URLEncoding.default
        if let contentType = headers?["Content-Type"], contentType.contains("application/json") {
            encoding = JSONEncoding.default
        }
        sessionManager.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).validate().responseString() { response in
            var result = Result()
            result.status = response.response?.statusCode ?? Result.error
            if let value = response.result.value {
                result.data["data"] = value
            }
            result.error = response.error?.localizedDescription
            callback(result)
        }
    }
    
    //    static func download(url: String, to: URL, method: HTTPMethod = .get, parameters: Parameters? = nil, headers: HTTPHeaders? = nil, callback: @escaping (DownloadResponse<Data>) -> Void) {
    //        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
    //            return (to, [.removePreviousFile, .createIntermediateDirectories])
    //        }
    //        sessionManager.download(url, method: method, parameters: parameters, headers: headers, to: destination).validate().responseData(completionHandler: callback)
    //    }
    
    /// 上传
    ///
    /// - Parameters:
    ///   - files: 文件数组
    ///   - to: 地址
    ///   - completionCallback: 上传完成回调
    ///   - progressCallback: 进度回调
    open static func upload(files: Array<UploadFile>, to: URLConvertible, completionCallback: @escaping (Result) -> Void, progressCallback: @escaping (Result) -> Void) {
        sessionManager.upload(multipartFormData: { (multipartFormData) in
            for file in files {
                multipartFormData.append(file.url, withName: file.name)
            }
        }, to: to) { encodingResult in
            var result = Result()
            switch encodingResult {
            case .success(let upload, _, _):
                result.progress = Int(upload.uploadProgress.fractionCompleted * 100)
                progressCallback(result)
                upload.responseJSON { response in
                    result.status = response.response?.statusCode ?? Result.error
                    result.data = response.value as! [String : Any]
                    result.error = response.error?.localizedDescription
                    completionCallback(result)
                }
            case .failure(let encodingError):
                result.status = Result.error
                result.error = encodingError.localizedDescription
                completionCallback(result)
            }
        }
    }
    
}
