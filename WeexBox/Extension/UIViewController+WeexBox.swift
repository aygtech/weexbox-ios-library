//
//  UIViewController+WeexBox.swift
//  WeexBox
//
//  Created by Baird-weng on 2019/7/9.
//

import UIKit
public var routerStringKey: String = "routerString_key"

public extension UIViewController {
    /// 路由参数
    @objc var routerString: String? {
        get {
            return objc_getAssociatedObject(self, &routerStringKey) as? String
        }
        set(newValue) {
            objc_setAssociatedObject(self, &routerStringKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
