//
//  JsOptions.swift
//  WeexBox
//
//  Created by Mario on 2018/8/20.
//  Copyright © 2018年 Ayg. All rights reserved.
//

import Foundation
import HandyJSON

/// js传来的参数
struct JsOptions: HandyJSON {

    // network
    var url: String?
    var method: String?
    var headers: Dictionary<String, String>?
    var params: Dictionary<String, Any>?
    var responseType: String?
    var files: Array<UploadFile>?
    
    // modal
    var text: String?
    var progress: Int?
    var title: String?
    var message: String?
    var okTitle: String?
    var cancelTitle: String?
    var placeholder: String?
    var isSecure: Bool?
    var actions: Array<ActionSheet>?
    var duration: Double?
    
    struct ActionSheet: HandyJSON {
        
        var title: String?
        var type: String? // destructive;cancel;normal
    }
    
    var name: String?
    var count: Int?
}
