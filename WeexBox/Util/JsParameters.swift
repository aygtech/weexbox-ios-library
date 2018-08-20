//
//  JsParameters.swift
//  WeexBox
//
//  Created by Mario on 2018/8/20.
//  Copyright © 2018年 Ayg. All rights reserved.
//

import Foundation
import HandyJSON

struct JsParameters: HandyJSON {
    
    var url: String?
    var method: String?
    var headers: Dictionary<String, String>?
    var params: Dictionary<String, Any>?
    var files: Array<UploadFile>?
    
}
