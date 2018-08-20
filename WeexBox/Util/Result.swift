//
//  Result.swift
//  WeexBox
//
//  Created by Mario on 2018/8/18.
//  Copyright © 2018年 Ayg. All rights reserved.
//

import Foundation
import HandyJSON

struct Result: HandyJSON {
    
    
    static let success = 0
    static let error = -1
    
    
    
    var code: Int!
    var data: Any?
    var error: String?
    
    typealias JsResult = Dictionary<String, Any>?
    
    
    init() {}
    init(code: Int = Result.success, data: Any? = nil, error: String? = nil) {
        self.code = code
        self.data = data
        self.error = error
    }
    
    
    func toJsResult() -> JsResult {
        return toJSON()
    }
}
