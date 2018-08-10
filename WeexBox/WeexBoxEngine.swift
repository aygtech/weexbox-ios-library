//
//  WeexBoxEngine.swift
//  WeexBox
//
//  Created by Mario on 2018/8/1.
//  Copyright © 2018年 Ayg. All rights reserved.
//

import Foundation
import WeexSDK
import BMBaseLibrary

public class WeexBoxEngine {
    
    public static func initialize() {
        initWeex()
        //        Test.test()
    }
    
    private static func initWeex() {
        BMConfigManager.configDefaultData()
        WXSDKEngine.registerModule("wb-router", with: RouterModule.self)
    }
    
    
    
}
