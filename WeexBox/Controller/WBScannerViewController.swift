//
//  WBScannerViewController.swift
//  WeexBox
//
//  Created by Mario on 2018/8/27.
//  Copyright © 2018年 Ayg. All rights reserved.
//

import Foundation
import LBXScan
@objcMembers open class WBScannerViewController: LBXScanViewController,LBXScanViewControllerDelegate {
    public var scanResultBlock: ((LBXScanResult, String?) -> Void)!
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "扫码调试"
        self.cameraInvokeMsg = "相机启动中"
        self.isNeedScanImage = true
        let style = LBXScanViewStyle()
        style.colorRetangleLine = UIColor.blue
        self.style = style
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(clickOntheBack))
    }
    @objc func clickOntheBack(){
       self.navigationController?.popViewController(animated: true)
    }
    public func scanResult(with array: [LBXScanResult]!) {
        if(array.count>0&&scanResultBlock != nil){
            scanResultBlock(array[0] , nil)
        }
    }
}
