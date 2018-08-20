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
    
    
    
    var code: Int = Result.success
    var data: Any?
    var error: String?
    var uploadProgress: Int?
    var downloadProgress: Int?
    
    typealias JsResult = Dictionary<String, Any>?
    
    
    init() {}
    
    func toJsResult() -> JsResult {
        return toJSON()
    }
}
