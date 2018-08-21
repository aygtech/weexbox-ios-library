//
//  WBWebViewController.swift
//  WeexBox
//
//  Created by Mario on 2018/8/13.
//  Copyright © 2018年 Ayg. All rights reserved.
//

import Foundation
import SnapKit

/// web基类
open class WBWebViewController: WBBaseViewController {
    
    var url: URL!
    let webView = UIWebView()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
//        webView.delegate = self
        webView.loadRequest(URLRequest(url: url))
    }
}
