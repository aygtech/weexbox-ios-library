//
//  WBBaseViewController.swift
//  WeexBox
//
//  Created by Mario on 2018/8/13.
//  Copyright © 2018年 Ayg. All rights reserved.
//

import Foundation
import MBProgressHUD

/// vc基类
open class WBBaseViewController: UIViewController {
    
    public var router: Router?
    private var hud: MBProgressHUD?
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        if let hidden = router?.navBarHidden {
            navigationController?.isNavigationBarHidden = hidden;
        }
    }
    
   
    
    func showLoading(text: String?) {
        initHUD()
        setLoading(text: text, progress: nil)
    }
    
    func setLoading(text: String?, progress: Float?) {
        hud!.label.text = text
        if progress == nil {
            hud!.mode = .indeterminate
        } else {
            hud!.mode = .annularDeterminate
            hud!.progress = progress!
        }
    }
    
    func showToast(text: String) {
        initHUD()
        hud!.mode = .text
        hud!.label.text = text
        hud!.hide(animated: true, afterDelay: 3)
    }
    
    func initHUD() {
        hud?.hide(animated: false)
        hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud!.label.numberOfLines = 0
    }
    
    func hideLoading() {
        hud?.hide(animated: true)
    }
    
    
}
