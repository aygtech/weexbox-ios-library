//
//  ExternalModule.swift
//  WeexBox
//
//  Created by Mario on 2018/8/18.
//  Copyright © 2018年 Ayg. All rights reserved.
//

import Foundation
import Async

extension ExternalModule {
    
    // 打开浏览器
   @objc func openBrowser(_ url: String) {
        Async.main {
            External.openBrowser(url)
        }
    }
    
    // 打电话
   @objc func callPhone(_ phone: String) {
        Async.main {
            External.callPhone(phone)
        }
    }
    
    // 拍照
    @objc func openCamera(_ callback: @escaping WXModuleKeepAliveCallback) {
        Async.main {
            External().openCamera(from: self.getVC(),callback: { (result) in
                callback(result.toJsResult(), false)
            })
        }
    }
    
    // 打开相册
   @objc func openPhoto(_ options: Dictionary<String, Any>, callback: @escaping WXModuleKeepAliveCallback) {
        Async.main {
            let info = JsOptions.deserialize(from: options)!
            External().openPhoto(from: self.getVC(), maxImagesCount: info.count!, callback: { (result) in
                callback(result.toJsResult(), false)
            })
        }
    }
    
}
