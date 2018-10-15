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
    
    private var weexHeight: CGFloat!
    private var instance: WXSDKInstance?
    private var weexView: UIView?
    public var url: URL!
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        Event.register(target: self, name: "RefreshInstance") { [weak self] _ in
            self?.refreshWeex()
        }
        
        view.backgroundColor = .white
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
        instance?.fireGlobalEvent("viewDidAppear", params: nil)
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        instance?.fireGlobalEvent("viewDidDisappear", params: nil)
    }
    
    func render() {
        instance?.destroy()
        instance = WXSDKInstance()
        instance?.viewController = self
        instance?.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: weexHeight)
        
        instance?.onCreate = { [weak self] (view) in
            self?.weexView?.removeFromSuperview()
            self?.weexView = view
            self?.view.addSubview((self?.weexView)!)
        }
        
        instance?.onFailed = { [weak self] (error) in
            #if DEBUG
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
            #endif
        }
        
        instance?.renderFinish = { [weak self] (view) in
            Log.d("Render Finish...")
            self?.instance?.fireGlobalEvent("viewDidAppear", params: nil)
        }
        
        instance?.render(with: url, options: ["bundleUrl": url!.absoluteString], data: nil)
    }
    
    public func refreshWeex() {
        render()
    }
    
    deinit {
        instance?.destroy()
    }
    
}
