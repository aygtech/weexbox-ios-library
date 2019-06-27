//
//  ScanWeex.swift
//  WeexBox
//
//  Created by Mario on 2018/11/5.
//  Copyright © 2018 Ayg. All rights reserved.
//

import Foundation
import WXDevtool

struct DebugWeex {

    static func openScan() {
        let topViewController = UIApplication.topViewController()
        let scannerViewController = WBScannerViewController()
        scannerViewController.view.backgroundColor = .white
        scannerViewController.scanResultBlock = { (scanResult, error) in
            scannerViewController.navigationController?.popViewController(animated: false)
            if error != nil {
                print(error!)
            } else {
                openWeex(scanResult.strScanned!)
            }
        }
        if(topViewController!.isMember(of: WBScannerViewController.classForCoder()) == false) {
            topViewController?.navigationController?.pushViewController(scannerViewController, animated: true)
        }
    }
    
    static func openWeex(_ url: String) {
        let params = url.getParameters()
        if let devtoolUrl = params["_wx_devtool"] {
            // 连服务
            let debugger = WXDebugger()
            debugger.enableRemoteLogging()
            WXSDKEngine.connectDevToolServer(devtoolUrl)
        } else if url.starts(with: "ws:") {
            // 连热重载
            HotReload.open(url: url)
        }
        else {
            // 连页面
            openDebugWeex(url: url)
        }
    }

    static func openDebugWeex(url: String?) {
        var router = Router()
        router.name = Router.nameWeex
        router.url = url
        router.open(from: UIApplication.topViewController()!)
    }

    static func refresh() {
        let topViewController = UIApplication.topViewController()
        if let weexViewController = topViewController as? WBWeexViewController {
            weexViewController.refreshWeex()
        }
    }
}

