//
//  WBScannerViewController.swift
//  WeexBox
//
//  Created by Mario on 2018/8/27.
//  Copyright © 2018年 Ayg. All rights reserved.
//

import Foundation
import SGQRCode

/// 扫描二维码
@objcMembers open class WBScannerViewController: WBBaseViewController {
    
    public var scanResultBlock: SGQRCodeObtainScanResultBlock?
    
    
    open override func viewDidLoad() {
        let configure = SGQRCodeObtainConfigure()
        let obtain = SGQRCodeObtain()
        obtain.establishQRCodeObtainScan(with: self, configure: configure)
        // 二维码扫描回调方法
        obtain.setBlockWithQRCodeObtainScanResult(scanResultBlock)
        // 二维码开启方法: 需手动开启扫描
        obtain.startRunningWith(before: nil, completion: nil)
        
    }
}
