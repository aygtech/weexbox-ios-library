//
//  UIViewController+Router.swift
//  Alamofire
//
//  Created by Baird-weng on 2019/7/9.
//

import UIKit
public var routerParamsKey: String = "routerParams_key"
public extension UIViewController{
    /// 路由参数
    @objc var routerParams: NSDictionary? {
        get {
            return objc_getAssociatedObject(self, &routerParamsKey) as? NSDictionary
        }
        set(newValue) {
            objc_setAssociatedObject(self, &routerParamsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
