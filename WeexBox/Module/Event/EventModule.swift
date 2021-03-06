//
//  EventModule.swift
//  WeexBox
//
//  Created by Mario on 2018/8/18.
//  Copyright © 2018年 Ayg. All rights reserved.
//

import Foundation

class EventModule: EventModuleOC {
    
    @objc func register(_ name: Any, callback: WXModuleKeepAliveCallback?) {
        Event.register(target: getVC(), name: WXConvert.nsString(name)) { notification in
            callback?(notification?.userInfo, true)
        }
    }
    
    @objc func emit(_ params: Dictionary<String, Any>) {
        let options = JsOptions.deserialize(from: params)!
        Event.emit(name: options.name!, info: options.params)
    }
    
    @objc func unregister(_ name: Any) {
        Event.unregister(target: self, name: WXConvert.nsString(name))
    }
    
    @objc func unregisterAll() {
        Event.unregisterAll(target: self)
    }
    
}
