//
//  WBWeexViewController.swift
//  WeexBox
//
//  Created by Mario on 2018/8/1.
//  Copyright © 2018年 Ayg. All rights reserved.
//

import Foundation
import Async
import WeexSDK
import SwiftyJSON

/// Weex基类
@objcMembers open class WBWeexViewController: WBBaseViewController {
    
    private var weexHeight: CGFloat!
    public var instance: WXSDKInstance?
    private var weexView: UIView?
    private var isFirstSendDidAppear = true
    private var url: URL?
    private var refreshTime = Date().timeIntervalSince1970
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        view.clipsToBounds = true
        edgesForExtendedLayout = .init(rawValue: 0)
        // 临时解决状态栏的问题，后面考虑用路由控制
        UIApplication.shared.isStatusBarHidden = false
        let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let navBarHidden = navigationController?.isNavigationBarHidden ?? true
        let navBarHeight: CGFloat = navBarHidden ? 0 : statusBarHeight + navigationController!.navigationBar.frame.size.height
        let tabBarHeight: CGFloat = self.hidesBottomBarWhenPushed ? 0 : (tabBarController?.tabBar.frame.size.height ?? 0)
        weexHeight = view.frame.size.height - navBarHeight - tabBarHeight
        
        if let urlString = router.url {
            if let host = HotReload.url, urlString.hasPrefix("http") == false {
                url = URL(string: host.replacingOccurrences(of: "ws", with: "http") + "/www/" + urlString)
            }
            if urlString.hasPrefix("http") {
                url = URL(string: urlString)
            } else {
                url = UpdateManager.getFullUrl(file: urlString)
            }
        }
        createWeexInstance()
        render()
        registerWXReloadBundle()
    }
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isFirstSendDidAppear == false {
            sendViewDidAppear()
        }
        registerRefreshInstance()
    }
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        sendViewDidDisappear()
        unregisterRefreshInstance()
    }
    
    func render() {
        if url != nil {
            let vueUrl = URL(string: url!.absoluteString + "?bundleType=Vue")
            instance?.render(with: vueUrl, options: nil, data: nil)
        } else {
            HUD.showToast(view: view, message: "url不能为空")
        }
    }
    
    public func refreshWeex() {
        let currentTime = Date().timeIntervalSince1970
        if WeexBoxEngine.isDebug, currentTime - refreshTime < 1 {
            return
        }
        refreshTime = currentTime
        createWeexInstance()
        render()
    }
    
    func createWeexInstance() {
        destoryWeexInstance()
        instance = WXSDKInstance()
        instance?.viewController = self
        instance?.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: weexHeight)
        
        instance?.onCreate = { [weak self] (view) in
            self?.weexView?.removeFromSuperview()
            self?.weexView = view
            self?.view.addSubview((self?.weexView)!)
        }
        
        instance?.renderFinish = { [weak self] (view) in
            self?.sendViewDidAppear()
        }
        
        if WeexBoxEngine.isDebug {
            instance?.onFailed = { [weak self] (error) in
                Async.main {
                    let ocError = error! as NSError
                    let errMsg = """
                    ErrorType:\(ocError.domain)
                    ErrorCode:\(ocError.code)
                    ErrorInfo:\(ocError.userInfo)
                    """
                    let alertController = UIAlertController(title: "render failed", message: errMsg, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default)
                    alertController.addAction(okAction)
                    self?.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    func destoryWeexInstance() {
        instance?.destroy()
        instance = nil
    }
    
    func registerRefreshInstance() {
        if WeexBoxEngine.isDebug {
            Event.register(target: self, name: "RefreshInstance") { [weak self] _ in
                self?.refreshWeex()
            }
        }
    }
    
    func registerWXReloadBundle() {
        if WeexBoxEngine.isDebug {
            Event.register(target: self, name: "WXReloadBundle") { [weak self] (notification) in
                if let url = self?.url {
                    let paths = url.pathComponents
                    let name = paths[paths.count - 2] + "/" + paths[paths.count - 1]
                    
                    if let params = notification?.userInfo?["params"] as? String, params.hasSuffix(name) {
                        self?.url = URL(string: params)
                        self?.refreshWeex()
                    }
                }
            }
        }
    }
    
    func unregisterRefreshInstance() {
        Event.unregister(target: self, name: "RefreshInstance")
    }
    
    func unregisterWXReloadBundle() {
        Event.unregister(target: self, name: "WXReloadBundle")
    }
    
    func sendViewDidAppear() {
        instance?.fireGlobalEvent("viewDidAppear", params: nil)
    }
    
    func sendViewDidDisappear() {
        isFirstSendDidAppear = false
        instance?.fireGlobalEvent("viewDidDisappear", params: nil)
    }
    
    deinit {
        unregisterWXReloadBundle()
        destoryWeexInstance()
    }
}
