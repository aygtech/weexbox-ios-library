//
//  WBScannerViewController.swift
//  WeexBox
//
//  Created by Mario on 2018/8/27.
//  Copyright © 2018年 Ayg. All rights reserved.
//

import Foundation
import swiftScan

/// 扫描二维码
@objcMembers open class WBScannerViewController: LBXScanViewController, LBXScanViewControllerDelegate {
    
    
    public var scanResultBlock: ((LBXScanResult, String?) -> Void)!
    
    
    open override func viewDidLoad() {
//        let configure = SGQRCodeObtainConfigure()
//        let obtain = SGQRCodeObtain()
//        obtain.establishQRCodeObtainScan(with: self, configure: configure)
//        // 二维码扫描回调方法
//        obtain.setBlockWithQRCodeObtainScanResult(scanResultBlock)
//        // 二维码开启方法: 需手动开启扫描
//        obtain.startRunningWith(before: nil, completion: nil)
        
        weixinStyle()
    }
    
   
    
    func createImageWithColor(color:UIColor)->UIImage
    {
        let rect=CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0);
        UIGraphicsBeginImageContext(rect.size);
        let context = UIGraphicsGetCurrentContext();
        context!.setFillColor(color.cgColor);
        context!.fill(rect);
        let theImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return theImage!;
    }
    
    //MARK: -------条形码扫码界面 ---------
    func notSquare()
    {
        //设置扫码区域参数
        //设置扫码区域参数
        var style = LBXScanViewStyle()
        
        style.centerUpOffset = 44;
        style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle.Inner;
        style.photoframeLineW = 4;
        style.photoframeAngleW = 28;
        style.photoframeAngleH = 16;
        style.isNeedShowRetangle = false;
        
        style.anmiationStyle = LBXScanViewAnimationStyle.LineStill;
        
        
        style.animationImage = createImageWithColor(color: UIColor.red)
        //非正方形
        //设置矩形宽高比
        style.whRatio = 4.3/2.18;
        
        //离左边和右边距离
        style.xScanRetangleOffset = 30;
        
        let vc = LBXScanViewController();
        
        vc.scanStyle = style
        self.rt_navigationController?.pushViewController(vc, animated: true)
        
    }
    

    
    //MARK: ---无边框，内嵌4个角------
    func weixinStyle()
    {
        //设置扫码区域参数
        var style = LBXScanViewStyle()
        style.centerUpOffset = 44;
        style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle.Inner;
        style.photoframeLineW = 2;
        style.photoframeAngleW = 18;
        style.photoframeAngleH = 18;
        style.isNeedShowRetangle = false;
        
        style.anmiationStyle = LBXScanViewAnimationStyle.LineMove;
        
        style.colorAngle = UIColor(red: 0.0/255, green: 200.0/255.0, blue: 20.0/255.0, alpha: 1.0)
        
        
        style.animationImage = UIImage(named: "CodeScan.bundle/qrcode_Scan_weixin_Line")
        
        scanStyle = style
        scanResultDelegate = self
    }
    
    public func scanFinished(scanResult: LBXScanResult, error: String?) {
        scanResultBlock(scanResult, error)
    }
    
}
