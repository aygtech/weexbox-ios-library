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
    func openWeex(_ options: Dictionary<String, Any>) {
        getRouter(options: options).openWeex(from: getVC())
    }
    
    // 打开web
    func openWeb(_ options: Dictionary<String, Any>) {
        getRouter(options: options).openWeb(from: getVC())
    }
    
    // 打开原生
    func openNative(_ options: Dictionary<String, Any>) {
        getRouter(options: options).openNative(from: getVC())
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
    
    func getRouter(options: Dictionary<String, Any>) -> Router {
        return Router.deserialize(from: options)!
    }
    
}
