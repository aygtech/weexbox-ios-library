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
    
    // 路由
    public var router = Router()
    // 导航栏原始高度
    let navHeight = UIApplication.shared.statusBarFrame.size.height
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        rt_disableInteractivePop = false
        navigationController?.isNavigationBarHidden = router.navBarHidden
    }
    
    deinit {
        Event.unregisterAll(target: self)
    }
    
}
