//
//  WXDevPlugin.swift
//  WeexBox
//
//  Created by Mario on 2018/8/27.
//  Copyright © 2018年 Ayg. All rights reserved.
//

import Foundation

@objc public extension WXDevPlugin {
    
    func pluginWillOpen(inContainer: UIViewController, withArg: Array<Any>) {
        let scannerViewController = WBScannerViewController()
        scannerViewController.scanResultBlock = { (obtain, result) in
            
        }
        let topViewController = WBBaseViewController.topViewController()
        topViewController?.navigationController?.pushViewController(scannerViewController, animated: true)
    }
}
