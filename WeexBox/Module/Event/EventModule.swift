//
//  EventModule.swift
//  WeexBox
//
//  Created by Mario on 2018/8/18.
//  Copyright © 2018年 Ayg. All rights reserved.
//

import Foundation

extension EventModule {
    
    // 注册事件
    func register(_ name: String, callback: @escaping WXModuleKeepAliveCallback) {
        Event.register(target: getVC(), name: name) { notification in
            callback(notification?.userInfo, true)
        }
    }
    
    // 发送事件
    func emit(_ params: Dictionary<String, Any>) {
        let options = JsOptions.deserialize(from: params)!
        Event.emit(name: options.name!, info: options.params)
    }
    
    // 注销事件
    func unregister(_ name: String) {
        Event.unregister(target: self, name: name)
    }
    
    // 注销所有事件
    func unregisterAll() {
        Event.unregisterAll(target: self)
    }
  
}
