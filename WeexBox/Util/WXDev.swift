//
//  WXDev.swift
//  WeexBox
//
//  Created by Mario on 2018/8/27.
//  Copyright © 2018年 Ayg. All rights reserved.
//

import Foundation

@objc class WXDev: NSObject {

    static func dev() {
//    UIViewController *topViewController = [WBBaseViewController topViewController];
//    WBScannerViewController *scannerViewController = [[WBScannerViewController alloc] init];
//    scannerViewController.scanResultBlock = ^(SGQRCodeObtain *obtain, NSString *result) {
//
//    };
//
//    [topViewController.navigationController pushViewController:scannerViewController animated:true];
//    if ([topViewController isKindOfClass: WBWeexViewController.class]) {
//    //
//    } else {
//
//    }
        let topViewController = WBBaseViewController.topViewController()
        let scannerViewController = WBScannerViewController()
        scannerViewController.scanResultBlock = { (obtain, result) in
            
        }
        topViewController?.navigationController?.pushViewController(scannerViewController, animated: true)
    }
}
