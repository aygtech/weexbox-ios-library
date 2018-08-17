//
//  WBBaseViewController.swift
//  WeexBox
//
//  Created by Mario on 2018/8/13.
//  Copyright © 2018年 Ayg. All rights reserved.
//

import Foundation

open class WBBaseViewController: UIViewController {
    
    public var router: Router?
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        if let hidden = router?.navBarHidden {
            navigationController?.isNavigationBarHidden = hidden;
        }
    }
}
