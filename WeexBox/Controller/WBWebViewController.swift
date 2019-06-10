//
//  WBWebViewController.swift
//  WeexBox
//
//  Created by Mario on 2018/8/13.
//  Copyright © 2018年 Ayg. All rights reserved.
//

import Foundation
import SnapKit
import VasSonic

/// web基类
open class WBWebViewController: WBBaseViewController, SonicSessionDelegate {

    public let webView = UIWebView()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        SonicEngine.shared().createSession(withUrl: router.url, withWebDelegate: self)
        let request = URLRequest(url: URL(string: router.url!)!)
        let session = SonicEngine.shared().session(withWebDelegate: self)
        if session != nil {
            webView.loadRequest(SonicUtil.sonicWebRequest(with: session, withOrigin: request))
        }
        else {
            webView.loadRequest(request)
        }
    }
    func bottomNavBar() {
        
    }
    
    deinit {
        SonicEngine.shared().removeSession(withWebDelegate: self)
    }
    
    // MARK: - SonicSessionDelegate
    /*
     * Call back when Sonic require WebView to reload, e.g template changed or error occurred.
     */
    public func session(_ session: SonicSession!, requireWebViewReload request: URLRequest!) {
        webView.loadRequest(request)
    }
}
