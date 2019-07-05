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
    /// hud gif动图。
    public static var hudGifName: String?
    /// 使用LOT动画
    public static var hudAnimationJsonFileName: String?
    /// hud LOT动画Size
    public static var hudLotContentSize:CGSize = CGSize(width: 50, height: 50)
    
    /// hud 背景颜色
    public static var hudBackGroundColor: UIColor?
    /// hud 内容颜色
    public static var hudContentColor: UIColor?

    public static var isDebug: Bool! {
        didSet {
            if isDebug {
                WXDebugTool.setDebug(true)
                WXLog.setLogLevel(.WXLogLevelLog)
                Async.main(after: 3) {
                    let touch = AssistiveTouch.sing
                    touch.show()
                    touch.callBack = { (index) -> () in
                        AssistiveTouch.sing.dissShow()
                        if index == 0 {
                            DebugWeex.openScan()
                        }
                        else if index == 1 {
                            DebugWeex.refresh()
                        }
                        else {
                            self.showInPutAlert()
                        }
                    }
                }
            } else {
                WXDebugTool.setDebug(false)
                WXLog.setLogLevel(.WXLogLevelOff)
            }
        }
    }

    private static func showInPutAlert() {
        let alertController = UIAlertController(title: "请输入weex路径", message: "", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "page/home.js"
        }
        let okAction = UIAlertAction(title: "确定", style: .default) { action in
            if alertController.textFields?.count ?? 0 > 0 && UIApplication.topViewController() != nil {
                let textField = alertController.textFields?[0] as? UITextField;
                DebugWeex.openDebugWeex(url: textField?.text)
            }
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel) { action in
        }
        alertController.addAction(okAction)
        alertController.addAction(cancel)
        let topViewController = UIApplication.topViewController()
        topViewController?.present(alertController, animated: true, completion: nil)
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
