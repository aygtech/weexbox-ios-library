//
//  RouterModule.swift
//  WeexBox
//
//  Created by Mario on 2018/8/13.
//  Copyright © 2018年 Ayg. All rights reserved.
//

import Foundation
import HandyJSON

extension RouterModule {
    
    // 打开weex
    func openWeex(_ info: Dictionary<String, Any>) {
        getRouter(info: info).openWeex(from: getVC())
    }
    
    // 打开web
    func openWeb(_ info: Dictionary<String, Any>) {
        getRouter(info: info).openWeb(from: getVC())
    }
    
    // 打开原生
    func openNative(_ info: Dictionary<String, Any>) {
        getRouter(info: info).openNative(from: getVC())
    }
    
    // 打开浏览器
    func openBrowser(_ info: Dictionary<String, Any>) {
        getRouter(info: info).openBrowser()
    }
    
    // 打电话
    func openPhone(_ info: Dictionary<String, Any>) {
        getRouter(info: info).openPhone()
    }
    
    // 获取router的params参数
    func getParams() -> Result.JsResult {
        var result = Result()
        result.data = getVC().router!.params
        return result.toJsResult()
    }
    
    // 关闭
    func close(_ levels: Int?) {
        getVC().router!.close(from: getVC(), levels: levels)
    }
    
    // 刷新
    func refresh() {
        getVC().refreshWeex()
    }
    
    func getRouter(info: Dictionary<String, Any>) -> Router {
        return Router.deserialize(from: info)!
    }
    
    func getVC() -> WBWeexViewController {
        return weexInstance.viewController as! WBWeexViewController
    }
}
