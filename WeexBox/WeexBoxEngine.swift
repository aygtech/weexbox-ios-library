//
//  WeexBoxEngine.swift
//  WeexBox
//
//  Created by Mario on 2018/8/1.
//  Copyright © 2018年 Ayg. All rights reserved.
//

import Foundation
import WeexSDK
import Alamofire

/// 初始化SDK
public class WeexBoxEngine {
    
    public static func initialize() {
        
        
        // 初始化WeexSDK
        initWeexSDK()
        //        Test.test()
    }
    
    private static func initWeexSDK() {
        WXSDKEngine.initSDKEnvironment()
        registerHandler()
        registerComponent()
        registerModule()
        #if DEBUG
        WXDebugTool.setDebug(true)
        WXLog.setLogLevel(.all)
        ATSDK.atAddPlugin()
        #else
        WXDebugTool.setDebug(false)
        WXLog.setLogLevel(.error)
        #endif
    }
    
    private static func registerHandler() {
        WXSDKEngine.registerHandler(WXImgLoaderDefaultImpl(), with: WXImgLoaderProtocol.self)
    }
    
    private static func registerComponent() {
        
    }
    
    private static func registerModule() {
        WXSDKEngine.registerModule("wb-external", with: External.self)
        WXSDKEngine.registerModule("wb-modal", with: ModalModule.self)
        WXSDKEngine.registerModule("wb-navigator", with: NavigatorModule.self)
        WXSDKEngine.registerModule("wb-network", with: NetworkModule.self)
        WXSDKEngine.registerModule("wb-router", with: RouterModule.self)
 
    }
    
    
}
