//
//  ModalModule.swift
//  WeexBox
//
//  Created by Mario on 2018/8/18.
//  Copyright © 2018年 Ayg. All rights reserved.
//

import Foundation
import Async

class ModalModule: ModalModuleOC {
    
    // 显示菊花
   @objc func showLoading(_ message: Any?) {
        Async.main {
            HUD.showLoading(view: self.getVC().view, message: WXConvert.nsString(message))
        }
    }
    
    // 显示进度
   @objc func showProgress(_ options: Dictionary<String, Any>) {
        Async.main {
            let info = JsOptions.deserialize(from: options)!
            HUD.showProgress(view: self.getVC().view, progress: Float(info.progress!) / 100, message: info.text)
        }
    }
    
    // 关闭菊花
   @objc func dismiss() {
        Async.main {
            HUD.dismiss(view: self.getVC().view)
        }
    }
    
    // 吐司
   @objc func showToast(_ options: Dictionary<String, Any>) {
        Async.main {
            let info = JsOptions.deserialize(from: options)!
            if info.text?.isEmpty == false {
                HUD.showToast(view: self.getVC().view, message: info.text!, duration: info.duration)
            }
        }
    }
    
    // 提示框
   @objc func alert(_ options: Dictionary<String, String>, callback: WXModuleKeepAliveCallback?) {
        Async.main {
            let info = JsOptions.deserialize(from: options)!
            let alertController = self.getAlertController(info, okCallback: callback)
            self.getVC().present(alertController, animated: true, completion: nil)
        }
    }
    
    // 确认框
   @objc func confirm(_ options: Dictionary<String, String>, callback: WXModuleKeepAliveCallback?) {
        Async.main {
            let info = JsOptions.deserialize(from: options)!
            let alertController = self.getAlertController(info, okCallback: callback, cancelCallback: callback)
            self.getVC().present(alertController, animated: true, completion: nil)
        }
    }
    
    // 输入框
   @objc func prompt(_ options: Dictionary<String, Any>, callback: WXModuleKeepAliveCallback?) {
        Async.main {
            let info = JsOptions.deserialize(from: options)!
            let alertController = self.getAlertController(info, okCallback: callback, cancelCallback: callback)
            alertController.addTextField { textField in
                textField.placeholder = info.placeholder
                textField.isSecureTextEntry = info.isSecure ?? false
            }
            self.getVC().present(alertController, animated: true, completion: nil)
        }
    }
    // 操作表
    @objc func actionSheet(_ options: Dictionary<String, Any>, callback: WXModuleKeepAliveCallback?) {
        Async.main {
            let info = JsOptions.deserialize(from: options)!
            let alertController = UIAlertController(title: info.title, message: info.message, preferredStyle: .actionSheet)
            for (_, action) in info.actions!.enumerated() {
                var type: UIAlertAction.Style
                switch action.type {
                case "danger":
                    type = .destructive
                case "cancel":
                    type = .cancel
                default:
                    type = .default
                }
                let alertAction = UIAlertAction(title: action.title, style: type) { alert in
                    let index = alertController.actions.index(of: alert);
                    var result = Result()
                    result.data = ["index": index ?? 0]
                    callback?(result.toJsResult(), false)
                }
                alertController.addAction(alertAction)
            }
            self.getVC().present(alertController, animated: true, completion: nil)
        }
    }
    
    func getAlertController(_ info: JsOptions, okCallback: WXModuleKeepAliveCallback?) -> UIAlertController {
        let alertController = UIAlertController(title: info.title, message: info.message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: info.okTitle, style: .default) { action in
            var result = Result()
            result.data = ["text": alertController.textFields?.first?.text ?? ""]
            okCallback?(result.toJsResult(), false)
        }
        alertController.addAction(okAction)
        return alertController
    }
    
    func getAlertController(_ info: JsOptions, okCallback: WXModuleKeepAliveCallback?, cancelCallback: WXModuleKeepAliveCallback?) -> UIAlertController {
        let alertController = getAlertController(info, okCallback: okCallback)
        let cancelAction = UIAlertAction(title: info.cancelTitle, style: .default) { action in
            var result = Result()
            result.status = Result.error
            cancelCallback?(result, false)
        }
        alertController.addAction(cancelAction)
        return alertController
    }
    
}
