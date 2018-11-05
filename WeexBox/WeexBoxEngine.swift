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
@objc public class WeexBoxEngine: NSObject {
    
    @objc public static func setup() {
        // 初始化WeexSDK
        initWeexSDK()
        //        Test.test()
    }
    
    private static func initWeexSDK() {
        WXSDKEngine.initSDKEnvironment()
        registerHandler()
        registerComponent()
        registerModule()
        registerRouter()
        #if DEBUG
        WXDebugTool.setDebug(true)
        WXLog.setLogLevel(.log)
//        ATSDK.atAddPlugin()
        #else
        WXDebugTool.setDebug(false)
        WXLog.setLogLevel(.off)
        #endif
    }
    
    private static func registerHandler() {
        WXSDKEngine.registerHandler(ImageHander(), with: WXImgLoaderProtocol.self)
    }
    
    private static func registerComponent() {
        
    }
    
    private static func registerModule() {
        WXSDKEngine.registerModule("wb-external", with: ExternalModule.self)
        WXSDKEngine.registerModule("wb-modal", with: ModalModule.self)
        WXSDKEngine.registerModule("wb-navigator", with: NavigatorModule.self)
        WXSDKEngine.registerModule("wb-network", with: NetworkModule.self)
        WXSDKEngine.registerModule("wb-router", with: RouterModule.self)
        WXSDKEngine.registerModule("wb-event", with: EventModule.self)
        WXSDKEngine.registerModule("wb-location", with: LocationModule.self)
    }
    
    private static func registerRouter() {
        Router.register(name: Router.weex, controller: WBWeexViewController.self)
        Router.register(name: Router.web, controller: WBWebViewController.self)
    }
    
}
