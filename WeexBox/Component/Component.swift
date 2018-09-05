//
//  Component.swift
//  WeexBox
//
//  Created by Mario on 2018/9/5.
//  Copyright © 2018年 Ayg. All rights reserved.
//

import Foundation
import WeexSDK

class Component: WXComponent {
    
    override func loadView() -> UIView {
        // 提供自定义view
        return UIView()
    }
    
    override func viewDidLoad() {
        
    }
    
    override func addEvent(_ eventName: String) {
        // 添加事件
    }
    
    override func removeEvent(_ eventName: String) {
        // 移除事件
    }
    
    override init(ref: String, type: String, styles: [AnyHashable : Any]?, attributes: [AnyHashable : Any]? = nil, events: [Any]?, weexInstance: WXSDKInstance) {
        super.init(ref: ref, type: type, styles: styles, attributes: attributes, events: events, weexInstance: weexInstance)
        if let showsTraffic = attributes?["showsTraffic"] as? Bool {
            // 拿到了自定义属性
        }
    }
}
