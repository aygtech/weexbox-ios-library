//
//  UIApplication+WeexBox.swift
//  WeexBox
//
//  Created by Mario on 2018/8/28.
//  Copyright © 2018年 Ayg. All rights reserved.
//

import Foundation
import RTRootNavigationController_WeexBox

public extension UIApplication {
    
    // 获取最顶层VC, 根视图必须是nav或者tab
    public static func topViewController(_ controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let rtController = controller as? RTRootNavigationController {
            return topViewController(rtController.rt_visibleViewController)
        }
        if let navigationController = controller as? UINavigationController {
            return topViewController(navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(presented)
        }
        return controller
    }
}
