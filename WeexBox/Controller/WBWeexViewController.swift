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
        
        let navBarHeight: CGFloat = navigationController?.navigationBar.frame.maxY ?? 0
        weexHeight = view.frame.size.height - navBarHeight - UIApplication.shared.statusBarFrame.size.height
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
        updateInstanceState(state: .WeexInstanceAppear)
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        updateInstanceState(state: .WeexInstanceDisappear)
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
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, self?.weexView)
        }
        
        instance?.onFailed = { [weak self] (error) in
            #if DEBUG
            let ocError = error! as NSError
            if ocError.domain == "1" {
                Async.main {
                    let errMsg = """
                    ErrorType:\(ocError.domain)
                    ErrorCode:\(ocError.code)
                    ErrorInfo:\(ocError.userInfo)
                    """
                    self?.present(UIAlertController(title: "render failed", message: errMsg, preferredStyle: .alert), animated: true, completion: nil)
                }
            }
            #endif
        }
        
        instance?.renderFinish = { (view) in
            Log.d("Render Finish...")
        }
        
        instance?.updateFinish = { (view) in
            Log.d("Update Finish...")
        }
        
        instance?.render(with: url, options: ["bundleUrl": url!.absoluteString], data: nil)
    }
    
    public func refreshWeex() {
        render()
    }
    
    func updateInstanceState(state: WXState) {
        if instance != nil, instance!.state != state {
            instance!.state = state
            if state == .WeexInstanceAppear {
                WXSDKManager.bridgeMgr().fireEvent(instance!.instanceId, ref: WX_SDK_ROOT_REF, type: "viewappear", params: nil, domChanges: nil)
            } else if state == .WeexInstanceDisappear {
                WXSDKManager.bridgeMgr().fireEvent(instance!.instanceId, ref: WX_SDK_ROOT_REF, type: "viewdisappear", params: nil, domChanges: nil)
            }
        }
    }
    
    deinit {
        instance?.destroy()
        NotificationCenter.default.removeObserver(self)
    }
    
}
