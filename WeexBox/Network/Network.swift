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
    
    public static var sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 5
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        return SessionManager(configuration: configuration)
    }()
    
    // 网络请求域名
    public static var server: URL?
    
    @discardableResult
    public static func request(
        _ url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil)
        -> DataRequest {
            var urlFinal: URL?
            if let urlString = url as? String {
                if urlString.hasPrefix("http://") == false, urlString.hasPrefix("https://") == false {
                    urlFinal = server?.appendingPathComponent(urlString)
                }
            }
            return sessionManager.request(urlFinal ?? url, method: method, parameters: parameters, encoding: (method == .post) ? JSONEncoding.default : encoding, headers: headers)
    }
}
