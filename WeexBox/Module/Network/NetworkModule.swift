//
//  NetworkModule.swift
//  WeexBox
//
//  Created by Mario on 2018/8/18.
//  Copyright © 2018年 Ayg. All rights reserved.
//

import Foundation
import Alamofire

class NetworkModule: NetworkModuleOC {
    /*
     {
     // `url` 是用于请求的服务器 URL
     url: 'https://some-domain.com/api/user',
     
     // `method` 是创建请求时使用的方法
     method: 'get', // 默认是 get
     
     // `headers` 是即将被发送的自定义请求头
     headers: {'X-Requested-With': 'XMLHttpRequest'},
     
     // `params` 是即将与请求一起发送的 URL/Body 参数
     params: {
     ID: 12345
     },
     
     // responseType 响应类型, json 或 text，默认 json
     }
     */
    @objc func request(_ options: Dictionary<String, Any>, callback: @escaping WXModuleKeepAliveCallback) {
        let info = JsOptions.deserialize(from: options)!
        let dataRequest = Network.request(info.url!, method: HTTPMethod(rawValue: info.method!.uppercased())!, parameters: info.params, headers: info.headers)
        
        if info.responseType?.uppercased() == "TEXT" {
            dataRequest.validate().responseString() { response in
                var result = Result()
                result.status = response.response?.statusCode ?? Result.error
                if let value = response.result.value {
                    result.data["data"] = value
                }
                result.error = response.error?.localizedDescription
                callback(result.toJsResult(), false)
            }
        } else {
            dataRequest.validate().responseJSON() { response in
                var result = Result()
                result.status = response.response?.statusCode ?? Result.error
                if let value = response.result.value as? Dictionary<String, Any> {
                    result.data = value
                }
                result.error = response.error?.localizedDescription
                callback(result.toJsResult(), false)
            }
        }
    }
    
    /*
     {
     // `files` 是本地文件路径数组
     files: [[file: 'file://image.png', name: 'icon']]
     
     // `url` 是上传地址
     url: 'https://some-domain.com/api/user',
     }
     */
    @objc func upload(_ options: Dictionary<String, Any>, completionCallback: @escaping WXModuleKeepAliveCallback, progressCallback: @escaping WXModuleKeepAliveCallback) {
        let info = JsOptions.deserialize(from: options)!
        
        Network.sessionManager.upload(multipartFormData: { (multipartFormData) in
            for file in info.files! {
                multipartFormData.append(file.url, withName: file.name)
            }
        }, to: info.url!) { encodingResult in
            var result = Result()
            switch encodingResult {
            case .success(let upload, _, _):
                result.progress = Int(upload.uploadProgress.fractionCompleted * 100)
                progressCallback(result.toJsResult(), true)
                upload.responseJSON { response in
                    result.status = response.response?.statusCode ?? Result.error
                    if let value = response.value as? Dictionary<String, Any> {
                        result.data = value
                    }
                    result.error = response.error?.localizedDescription
                    completionCallback(result.toJsResult(), false)
                }
            case .failure(let encodingError):
                result.status = Result.error
                result.error = encodingError.localizedDescription
                completionCallback(result.toJsResult(), false)
            }
        }
    }
    
}
