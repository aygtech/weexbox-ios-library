//
//  ExternalModule.swift
//  WeexBox
//
//  Created by Mario on 2018/8/18.
//  Copyright © 2018年 Ayg. All rights reserved.
//

import Foundation
import Async
import AudioToolbox
class ExternalModule: ExternalModuleOC {
    
    // 打开浏览器
    @objc func openBrowser(_ url: Any) {
        Async.main {
            External.openBrowser(WXConvert.nsString(url))
        }
    }
    
    // 打电话
    @objc func callPhone(_ phone: Any) {
        Async.main {
            External.callPhone(WXConvert.nsString(phone))
        }
    }
    
    // 拍照
    @objc func openCamera(_ options: Dictionary<String, Any>, callback: WXModuleKeepAliveCallback?) {
        Async.main {
            External().openCamera(from: self.getVC(),options:options,callback: { (result) in
                callback?(result.toJsResult(), false)
            })
        }
    }
    
    // 打开相册
    @objc func openPhoto(_ options: Dictionary<String, Any>, callback: WXModuleKeepAliveCallback?) {
        Async.main {
            External().openPhoto(from: self.getVC(), options:options, callback: { (result) in
                callback?(result.toJsResult(), false)
            })
        }
    }
    //震动
    @objc func vibration(_ options: Dictionary<String, Any>){
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
}
