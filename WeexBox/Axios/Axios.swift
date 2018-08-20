//
//  Axios.swift
//  WeexBox
//
//  Created by Mario on 2018/8/18.
//  Copyright © 2018年 Ayg. All rights reserved.
//

import Foundation
import Alamofire

struct Axios {
    
    static let sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 15
        return SessionManager(configuration: configuration)
    }()
    
    static func request(url: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, headers: HTTPHeaders? = nil, callback: @escaping (Result) -> Void) {
        sessionManager.request(url, method: method, parameters: parameters, headers: headers).validate().responseJSON() { response in
            switch response.result {
            case .success:
                callback(Result(code: response.response!.statusCode, data: response.result.value))
            case .failure(let error):
                callback(Result(code: response.response!.statusCode, data: response.result.value, error: error.localizedDescription))
            }
        }
    }
    
//    static func download(url: String, to: URL, method: HTTPMethod = .get, parameters: Parameters? = nil, headers: HTTPHeaders? = nil, callback: @escaping (DownloadResponse<Data>) -> Void) {
//        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
//            return (to, [.removePreviousFile, .createIntermediateDirectories])
//        }
//        sessionManager.download(url, method: method, parameters: parameters, headers: headers, to: destination).validate().responseData(completionHandler: callback)
//    }
    
    static func upload(files: Array<UploadFile>, to: URLConvertible) {
        sessionManager.upload(multipartFormData: { (multipartFormData) in
            for file in files {
                multipartFormData.append(file.url, withName: file.name)
            }
        }, to: to) { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    debugPrint(response)
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        }
    }
   
}
