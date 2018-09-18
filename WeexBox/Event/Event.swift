//
//  Event.swift
//  WeexBox
//
//  Created by Mario on 2018/8/24.
//  Copyright © 2018年 Ayg. All rights reserved.
//

import Foundation
import SwiftEventBus

public struct Event {
    
   public static func register(target: AnyObject, name: String, handler: @escaping ((Notification?) -> Void)) {
        SwiftEventBus.onMainThread(target, name: name, handler: handler)
    }
    
   public static func emit(name: String, info: Dictionary<String, Any>?) {
        SwiftEventBus.post(name, userInfo: info)
    }
    
   public static func unregister(target: AnyObject, name: String) {
        SwiftEventBus.unregister(target, name: name)
    }
    
   public static func unregisterAll(target: AnyObject) {
        SwiftEventBus.unregister(target)
    }
}

