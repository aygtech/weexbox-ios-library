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
        let url = config["url"] as! String
        let method = config["method"] as! String
        let headers = config["headers"] as? HTTPHeaders
        let params = config["params"] as? Parameters
        Axios.request(url: url, method: HTTPMethod(rawValue: method.uppercased())!, parameters: params, headers: headers) { result in
            callback(result.toJsResult(), false)
        }
    }
}
