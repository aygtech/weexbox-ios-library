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

/// Weex基类
@objcMembers open class WBWeexViewController: WBBaseViewController {
    
    public var weexHeight: CGFloat!
    public var instance: WXSDKInstance?
    public var weexView: UIView?
    public var url: URL!
    private var isFristEnter = true
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        if WeexBoxEngine.isDebug {
            Event.register(target: self, name: "RefreshInstance") { [weak self] _ in
                self?.refreshWeex()
            }
        }
        
        view.clipsToBounds = true
        edgesForExtendedLayout = .init(rawValue: 0)
        // 临时解决状态栏的问题，后面考虑用路由控制
        UIApplication.shared.isStatusBarHidden = false
        let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let navBarHidden = navigationController?.isNavigationBarHidden ?? true
        let navBarHeight: CGFloat = navBarHidden ? 0 : statusBarHeight + navigationController!.navigationBar.frame.size.height
        let tabBarHeight: CGFloat = self.hidesBottomBarWhenPushed ? 0 : (tabBarController?.tabBar.frame.size.height ?? 0)
        weexHeight = view.frame.size.height - navBarHeight - tabBarHeight
        if let u = router?.url {
            if u.hasPrefix("http") {
                url = URL(string: u)
            } else {
                url = UpdateManager.getFullUrl(file: u)
            }
        }
        render()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        sendViewDidAppear()
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        sendViewDidDisappear()
    }
    
    private func render() {
        instance?.destroy()
        instance = WXSDKInstance()
        instance?.viewController = self
        instance?.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: weexHeight)
        
        instance?.onCreate = { [weak self] (view) in
            self?.weexView?.removeFromSuperview()
            self?.weexView = view
            self?.view.addSubview((self?.weexView)!)
        }
        
        instance?.renderFinish = { [weak self] (view) in
            self?.isFristEnter = false
            self?.sendViewDidAppear()
        }
        
        if WeexBoxEngine.isDebug {
            instance?.onFailed = { [weak self] (error) in
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
        
        instance?.render(with: url, options: ["bundleUrl": url!.absoluteString], data: nil)
    }
    
    public func refreshWeex() {
        render()
    }
    
    private func sendViewDidAppear() {
        if isFristEnter == false {
            instance?.fireGlobalEvent("viewDidAppear", params: nil)
        }
    }
    
    private func sendViewDidDisappear() {
        instance?.fireGlobalEvent("viewDidDisappear", params: nil)
    }
    
    deinit {
        instance?.destroy()
    }
    
}
