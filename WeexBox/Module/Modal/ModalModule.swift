//
//  ModalModule.swift
//  WeexBox
//
//  Created by Mario on 2018/8/18.
//  Copyright © 2018年 Ayg. All rights reserved.
//

import Foundation
import MBProgressHUD

extension ModalModule {
    
    // 显示菊花
    func showLoading(_ text: String?) {
        getVC().showLoading(text: text)
    }
    
    // 设置菊花
    func setLoading(_ options: Dictionary<String, Any>) {
        let info = JsOptions.deserialize(from: options)!
        getVC().setLoading(text: info.text, progress: info.progress)
    }
    
    // 关闭菊花
    func hideLoading() {
        getVC().hideLoading()
    }
    
    // 吐司
    func showToast(_ text: String) {
        getVC().showToast(text: text)
    }
    
    // 提示框
    func alert(_ options: Dictionary<String, String>, callback: WXModuleKeepAliveCallback?) {
        let info = JsOptions.deserialize(from: options)!
        let alertController = getAlertController(info, okCallback: callback)
        getVC().present(alertController, animated: true, completion: nil)
    }
    
    // 确认框
    func confirm(_ options: Dictionary<String, String>, callback: @escaping WXModuleKeepAliveCallback) {
        let info = JsOptions.deserialize(from: options)!
        let alertController = getAlertController(info, okCallback: callback, cancelCallback: callback)
        getVC().present(alertController, animated: true, completion: nil)
    }
    
    // 输入框
    func prompt(_ options: Dictionary<String, Any>, callback: @escaping WXModuleKeepAliveCallback) {
        let info = JsOptions.deserialize(from: options)!
        let alertController = getAlertController(info, okCallback: callback)
        alertController.addTextField { textField in
            textField.placeholder = info.placeholder
            textField.isSecureTextEntry = info.isSecure ?? false
        }
        getVC().present(alertController, animated: true, completion: nil)
    }
    
    // 操作表
    func actionSheet(_ options: Dictionary<String, Any>, callback: @escaping WXModuleKeepAliveCallback) {
        let info = JsOptions.deserialize(from: options)!
        let alertController = UIAlertController(title: info.title, message: info.message, preferredStyle: .actionSheet)
        for action in info.actions! {
            var type: UIAlertActionStyle
            switch action.type {
            case "danger":
                type = .destructive
            case "cancel":
                type = .cancel
            default:
                type = .default
            }
            let alertAction = UIAlertAction(title: info.title, style: type) { alert in
                var result = Result()
                result.data = alert.title
                callback(result, false)
            }
            alertController.addAction(alertAction)
        }
        getVC().present(alertController, animated: true, completion: nil)
    }
        
        func getAlertController(_ info: JsOptions, okCallback: WXModuleKeepAliveCallback?) -> UIAlertController {
            let alertController = UIAlertController(title: info.title, message: info.message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: info.okTitle, style: .default) { action in
                if okCallback != nil {
                    var result = Result()
                    result.data = alertController.textFields?.first?.text
                    okCallback!(result.toJsResult(), false)
                }
            }
            alertController.addAction(okAction)
            return alertController
        }
        
        func getAlertController(_ info: JsOptions, okCallback: WXModuleKeepAliveCallback?, cancelCallback: WXModuleKeepAliveCallback?) -> UIAlertController {
            let alertController = getAlertController(info, okCallback: okCallback)
            let cancelAction = UIAlertAction(title: info.cancelTitle, style: .default) { action in
                if cancelCallback != nil {
                    var result = Result()
                    result.code = Result.error
                    cancelCallback!(result, false)
                }
            }
            alertController.addAction(cancelAction)
            return alertController
        }
        
}
