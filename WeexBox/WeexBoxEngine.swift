//
//  WeexBoxEngine.swift
//  WeexBox
//
//  Created by Mario on 2018/8/1.
//  Copyright © 2018年 Ayg. All rights reserved.
//

import Foundation
import WeexSDK
import Async
import VasSonic

/// 初始化SDK
@objcMembers public class WeexBoxEngine: NSObject {
    
    @objc public static func setup() {
        // 初始化WeexSDK
        initWeexSDK()
        isDebug = false
        
        URLProtocol.registerClass(SonicURLProtocol.self)
    }
    
    public static var isDebug: Bool! {
        didSet {
            if isDebug {
                WXDebugTool.setDebug(true)
                WXLog.setLogLevel(.WXLogLevelLog)
                Async.main(after: 3) {
                    let assistveButton = AssistveButton(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height/2, width: 50, height: 50), assistiveType: .YGAssistiveTypeNone) {
                        DebugWeex.openScan()
                    }
                    let window = UIApplication.shared.delegate?.window
                    
                    if window != nil, window!?.rootViewController != nil {
                        window!!.addSubview(assistveButton)
                    } else {
                        print("请在初始化rootViewController之后再开启debug")
                    }
                }
            } else {
                WXDebugTool.setDebug(false)
                WXLog.setLogLevel(.WXLogLevelOff)
            }
        }
    }
    
    private static func initWeexSDK() {
        WXSDKEngine.initSDKEnvironment()
        WXTracingManager.switchTracing(false)
        registerHandler()
        registerComponent()
        registerModule()
        registerRouter()
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
