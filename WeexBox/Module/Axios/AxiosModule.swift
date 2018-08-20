//
//  AxiosModule.swift
//  WeexBox
//
//  Created by Mario on 2018/8/18.
//  Copyright © 2018年 Ayg. All rights reserved.
//

import Foundation
import Alamofire

extension AxiosModule {
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
    func request(_ config: Dictionary<String, Any>, callback: @escaping WXModuleKeepAliveCallback) {
        let info = JsParameters.deserialize(from: config)!
        Axios.request(url: info.url!, method: HTTPMethod(rawValue: info.method!.uppercased())!, parameters: info.params, headers: info.headers) { result in
            callback(result.toJsResult(), false)
        }
    }
    
    /*
     {
     // `files` 是本地文件路径数组
     files: [[file: 'file://image.png', name: 'icon']]
     
     // `to` 是上传地址
     to: 'https://some-domain.com/api/user',
     }
     */
    func upload(_ config: Dictionary<String, Any>, callback: @escaping WXModuleKeepAliveCallback) {
        let info = JsParameters.deserialize(from: config)!
        Axios.upload(files: info.files!, to: info.url!) { (result) in
            callback(result.toJsResult(), true)
        }
    }
}
