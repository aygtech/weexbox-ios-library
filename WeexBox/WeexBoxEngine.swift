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
        let hotReload = HotReload()
        hotReload.open(url: "")
    }
    
    public static var isDebug: Bool! {
        didSet {
            if isDebug {
                _ = HotReload()
                WXDebugTool.setDebug(true)
                WXLog.setLogLevel(.WXLogLevelLog)
                Async.main(after: 3) {
                    let touch = AssistiveTouch.sing
                    touch.show()
                    touch.callBack = {(index)->() in
                        AssistiveTouch.sing.dissShow()
                        if index == 0 {
                            DebugWeex.openScan()
                        }
                        else {
                            DebugWeex.refresh()
                        }
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
        registerHandler()
        registerComponent()
        registerModule()
        registerRouter()
    }
    
    private static func registerHandler() {
        WXSDKEngine.registerHandler(ImageHander(), with: WXImgLoaderProtocol.self)
        WXSDKEngine.registerHandler(WebSocketHander(), with: WXWebSocketHandler.self)
    }
    
    private static func registerComponent() {
        WXSDKEngine.registerComponent("wb-lottie", with: LottieComponent.self)
    }
    
    private static func registerModule() {
        WXSDKEngine.registerModule("wb-external", with: ExternalModule.self)
        WXSDKEngine.registerModule("wb-modal", with: ModalModule.self)
        WXSDKEngine.registerModule("wb-navigator", with: NavigatorModule.self)
        WXSDKEngine.registerModule("wb-network", with: NetworkModule.self)
        WXSDKEngine.registerModule("wb-router", with: RouterModule.self)
        WXSDKEngine.registerModule("wb-event", with: EventModule.self)
        WXSDKEngine.registerModule("wb-location", with: LocationModule.self)
        WXSDKEngine.registerModule("wb-util", with: UtilModule.self)
    }
    
    private static func registerRouter() {
        Router.register(name: Router.nameWeex, controller: WBWeexViewController.self)
        Router.register(name: Router.nameWeb, controller: WBWebViewController.self)
    }
    
}
