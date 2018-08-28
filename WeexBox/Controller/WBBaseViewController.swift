//
//  WBBaseViewController.swift
//  WeexBox
//
//  Created by Mario on 2018/8/13.
//  Copyright © 2018年 Ayg. All rights reserved.
//

import Foundation

/// vc基类
@objcMembers open class WBBaseViewController: UIViewController {
    
    public var router: Router?
    
    // 获取最顶层VC, 根视图必须是nav或者tab
    public static func topViewController(_ controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
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
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        if let hidden = router?.navBarHidden {
            navigationController?.isNavigationBarHidden = hidden;
        }
    }
}
