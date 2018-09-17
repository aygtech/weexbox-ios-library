//
//  Result.swift
//  WeexBox
//
//  Created by Mario on 2018/8/18.
//  Copyright © 2018年 Ayg. All rights reserved.
//

import Foundation
import HandyJSON

/// 结果
public struct Result: HandyJSON {
    
    
    static let success = 0
    static let error = -1
    
    
    
    public var status: Int = Result.success
    public var data = Dictionary<String, Any>()
    public var error: String?
    public var progress: Int?
    
    typealias JsResult = Dictionary<String, Any>?
    typealias Callback = (Result) -> Void
    
    public init() {}
    
    func toJsResult() -> JsResult {
        return toJSON()
    }
}
