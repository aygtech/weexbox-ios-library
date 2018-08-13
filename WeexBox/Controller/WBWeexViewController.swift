//
//  WBWeexViewController.swift
//  WeexBox
//
//  Created by Mario on 2018/8/1.
//  Copyright © 2018年 Ayg. All rights reserved.
//

import Foundation
import SocketRocket
import Async
import WeexSDK

@objcMembers open class WBWeexViewController: WBBaseViewController, SRWebSocketDelegate {
    
    private var weexHeight: CGFloat!
    private var hotReloadSocket: SRWebSocket?
    private var instance: WXSDKInstance?
    private var weexView: UIView?
    public var url: URL?
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.clipsToBounds = true
        edgesForExtendedLayout = .init(rawValue: 0)
        
        let navBarHeight: CGFloat = navigationController?.navigationBar.frame.maxY ?? 0
        weexHeight = view.frame.size.height - navBarHeight - UIApplication.shared.statusBarFrame.size.height
        if let u = router?.url {
            url = URL(string: u)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationRefreshInstance(_:)), name: NSNotification.Name("RefreshInstance"), object: nil)
        
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
                    self?.show(UIAlertController(title: "render failed", message: errMsg, preferredStyle: .alert), sender: nil)
                }
            }
            #endif
        }
        
        instance?.renderFinish = { (view) in
            Log.debug("Render Finish...")
        }
        
        instance?.updateFinish = { (view) in
            Log.debug("Update Finish...")
        }
        
        if (url == nil) {
            Log.error("error: render url is nil")
        } else {
            instance?.render(with: url, options: ["bundleUrl": url!.absoluteString], data: nil)
        }
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
        hotReloadSocket?.close()
        instance?.destroy()
        NotificationCenter.default.removeObserver(self)
        hotReloadSocket = nil
    }
    
    // MARK: - 调试
    func setHotReloadURL(_ url: URL) {
        hotReloadSocket = SRWebSocket(url: url)
        hotReloadSocket?.delegate = self
        hotReloadSocket?.open()
    }
    
    @objc func notificationRefreshInstance(_ notification: Notification) {
        refreshWeex()
    }
    
    // MARK: - SRWebSocketDelegate
    public func webSocket(_ webSocket: SRWebSocket!, didReceiveMessage message: Any!) {
        if let message = message as? String {
            if message == "refresh" {
                refreshWeex()
            }
            let jsonObj = WXUtility.object(fromJSON: message)
            if let messageDic = jsonObj as? Dictionary<String, String> {
                let method = messageDic["method"]
                if method?.hasPrefix("WXReload") == true {
                    if method == "WXReloadBundle", messageDic["params"] != nil {
                        url = URL(string: messageDic["params"]!)
                    }
                    refreshWeex()
                }
            }
        }
    }
}
