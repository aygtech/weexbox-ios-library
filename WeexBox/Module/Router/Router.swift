//
//  Router.swift
//  WeexBox
//
//  Created by Mario on 2018/8/13.
//  Copyright © 2018年 Ayg. All rights reserved.
//

import Foundation
import HandyJSON

let K_ANIMATE_PRESENT = "present"
let K_ANIMATE_PUSH = "push"

public struct Router: HandyJSON {
    
    public init() {}
    
    // 下一个weex页面路径
    var url: String?
    // 页面出现方式：push, present
    var type: String?
    // 需要传到下一个页面的数据
    var params: Dictionary<String, Any>?
}
