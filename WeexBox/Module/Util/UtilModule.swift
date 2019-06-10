//
//  UtilModule.swift
//  WeexBox
//
//  Created by Mario on 2018/8/18.
//  Copyright © 2018年 Ayg. All rights reserved.
//

import Foundation

class UtilModule: EventModuleOC {
    
    // 获取状态栏高度
    @objc func getStatusBarHeight() -> Int {
        return Int(getVC().statusBarHeight / weexInstance.pixelScaleFactor)
    }
    
    // 获取屏幕宽度
    @objc func getScreenWidth() -> Int {
        return Int(UIScreen.main.bounds.size.width / weexInstance.pixelScaleFactor)
    }
    
    // 获取屏幕高度
    @objc func getScreenHeight() -> Int {
        return Int(UIScreen.main.bounds.size.height / weexInstance.pixelScaleFactor)
    }
    
    // 获取weex宽度
    @objc func getWeexWidth() -> Int {
        return Int(weexInstance.frame.size.width / weexInstance.pixelScaleFactor)
    }
    
    // 获取weex高度
    @objc func getWeexHeight() -> Int {
        return Int(weexInstance.frame.size.height / weexInstance.pixelScaleFactor)
    }
    
}
