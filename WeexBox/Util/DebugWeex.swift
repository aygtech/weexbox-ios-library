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
                openWeex(scanResult.strScanned!, from: topViewController!)
            }
        }
        if(topViewController!.isMember(of: WBScannerViewController.classForCoder()) == false) {
            topViewController?.navigationController?.pushViewController(scannerViewController, animated: true)
        }
    }
    
    static func openWeex(_ urlString: String, from: UIViewController) {
        // 处理windows上的dev路径带有"\\"
        let params = urlString.replacingOccurrences(of: "\\", with: "/").getParameters()
        if let devtoolUrl = params["_wx_devtool"] {
            // 连服务
            WXDevTool.launchDebug(withUrl: devtoolUrl)
        } else if let tplUrl = params["_wx_tpl"] {
            // 连页面
            var router = Router()
            router.name = Router.nameWeex
            router.url = tplUrl
            router.open(from: from)
        }
    }
    
    static func refresh() {
        let topViewController = UIApplication.topViewController()
        if let weexViewController = topViewController as? WBWeexViewController {
            weexViewController.refreshWeex()
        }
    }
}
