//
//  UIViewController+Router.swift
//  Alamofire
//
//  Created by Baird-weng on 2019/7/9.
//

import UIKit
public var wbParamsKey: String = "wbParams_key"
public extension UIViewController{
    @objc var wbParams: NSDictionary? {
        get {
            return objc_getAssociatedObject(self, &wbParamsKey) as? NSDictionary
        }
        set(newValue) {
            objc_setAssociatedObject(self, &wbParamsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
