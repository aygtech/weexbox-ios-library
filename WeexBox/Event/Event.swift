//
//  Event.swift
//  WeexBox
//
//  Created by Mario on 2018/8/24.
//  Copyright © 2018年 Ayg. All rights reserved.
//

import Foundation
import SwiftEventBus

struct Event {
    
    static func register(target: AnyObject, name: String, handler: @escaping ((Notification?) -> Void)) {
        SwiftEventBus.onMainThread(target, name: name, handler: handler)
    }
    
    static func emit(name: String, info: Dictionary<String, Any>?) {
        SwiftEventBus.post(name, userInfo: info)
    }
    
    static func unregister(target: AnyObject, name: String) {
        SwiftEventBus.unregister(target, name: name)
    }
    
    static func unregisterAll(target: AnyObject) {
        SwiftEventBus.unregister(target)
    }
}

