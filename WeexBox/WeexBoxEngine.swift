//
//  WeexBoxEngine.swift
//  WeexBox
//
//  Created by Mario on 2018/8/1.
//  Copyright © 2018年 Ayg. All rights reserved.
//

import Foundation
import WeexSDK

/// 初始化SDK
public class WeexBoxEngine {
    
    public static func initialize() {
        initWeex()
        //        Test.test()
    }
    
    private static func initWeex() {
        WXSDKEngine.registerModule("wb-router", with: RouterModule.self)
        WXSDKEngine.registerModule("wb-modal", with: ModalModule.self)
    }
    
    
    
}
