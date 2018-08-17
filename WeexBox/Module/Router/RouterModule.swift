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
    
    func openWeex(_ info: Dictionary<String, Any>) {
        getRouter(info: info).openWeex(from: getVC())
    }
    
    func openWeb(_ info: Dictionary<String, Any>) {
        getRouter(info: info).openWeb(from: getVC())
    }
    
    func openNative(_ info: Dictionary<String, Any>) {
        getRouter(info: info).openNative(from: getVC())
    }
    
    func openBrowser(_ info: Dictionary<String, Any>) {
        getRouter(info: info).openBrowser()
    }
    
    func openPhone(_ info: Dictionary<String, Any>) {
        getRouter(info: info).openPhone()
    }
    
    func getParams() -> Dictionary<String, Any>? {
        return getVC().router!.params
    }
    
    func close(_ levels: Int?) {
        getVC().router!.close(from: getVC(), levels: levels)
    }
    
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
