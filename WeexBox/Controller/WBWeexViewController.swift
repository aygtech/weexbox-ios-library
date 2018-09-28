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
    public var isDebug = false
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        Event.register(target: self, name: "RefreshInstance") { [weak self] _ in
            if let weakSelf = self {
                if weakSelf.isDebug {
                    weakSelf.refreshWeex()
                }
            }
        }
        
        view.backgroundColor = .white
        view.clipsToBounds = true
        edgesForExtendedLayout = .init(rawValue: 0)
        UIApplication.shared.isStatusBarHidden = false
        let navBarHeight: CGFloat = navigationController?.navigationBar.frame.maxY ?? 0
        let tabBarHeight: CGFloat = self.hidesBottomBarWhenPushed ? 0 : (tabBarController?.tabBar.frame.size.height ?? 0)
        let isNavigat = self.navigationController?.isNavigationBarHidden
        weexHeight = view.frame.size.height - navBarHeight - UIApplication.shared.statusBarFrame.size.height - tabBarHeight + (isNavigat! ? 20 : 0)

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
        NotificationCenter.default.removeObserver(self)
    }
    
}
