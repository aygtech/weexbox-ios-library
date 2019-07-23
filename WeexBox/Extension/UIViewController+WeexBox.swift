//
//  UIViewController+WeexBox.swift
//  WeexBox
//
//  Created by Baird-weng on 2019/7/9.
//

import UIKit
public var routerJsonKey: String = "routerJson_key"

public extension UIViewController {
    /// 路由参数
    @objc var routerJson: String? {
        get {
            return objc_getAssociatedObject(self, &routerJsonKey) as? String
        }
        set(newValue) {
            objc_setAssociatedObject(self, &routerJsonKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
