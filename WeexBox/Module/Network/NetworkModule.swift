//
//  NetworkModule.swift
//  WeexBox
//
//  Created by Mario on 2018/8/18.
//  Copyright © 2018年 Ayg. All rights reserved.
//

import Foundation
import Alamofire

extension NetworkModule {
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
     }
     */
    @objc func request(_ options: Dictionary<String, Any>, callback: @escaping WXModuleKeepAliveCallback) {
        let info = JsOptions.deserialize(from: options)!
        Network.request(url: info.url!, method: HTTPMethod(rawValue: info.method!.uppercased())!, parameters: info.params, headers: info.headers) { result in
            callback(result.toJsResult(), false)
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
        Network.upload(files: info.files!, to: info.url!, completionCallback: { (result) in
            completionCallback(result.toJsResult(), false)
        }, progressCallback: { (result) in
            progressCallback(result.toJsResult(), true)
        })
    }
}
