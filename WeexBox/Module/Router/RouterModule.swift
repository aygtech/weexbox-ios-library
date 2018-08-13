//
//  RouterModule.swift
//  WeexBox
//
//  Created by Mario on 2018/8/13.
//  Copyright © 2018年 Ayg. All rights reserved.
//

import Foundation
import HandyJSON
import RTRootNavigationController
import Async

extension RouterModule {
    
    func open(_ info: Dictionary<String, Any>) {
        let router = Router.deserialize(from: info)
        var vc: WBBaseViewController
        if router?.url != nil {
            vc = WBWeexViewController()
        } else {
            Log.error("Error：url和nativePage不能都为空")
            return
        }
        openVC(vc, router: router)
    }
    
    func getParams() -> Dictionary<String, Any>? {
        return (weexInstance.viewController as? WBBaseViewController)?.router?.params
    }
    
    func back(_ levels: Int?) {
        let type = getParams()?["type"] as? String
        if type == K_ANIMATE_PRESENT {
            weexInstance?.viewController?.dismiss(animated: true, completion: nil)
        } else {
            if let l = levels, l > 1 {
                if let nav = weexInstance?.viewController?.navigationController {
                    let index = nav.viewControllers.count - 1 - l
                    if index <= 0 {
                        nav.popViewController(animated: true)
                    } else {
                        let vc = nav.viewControllers[index]
                        nav.popToViewController(vc, animated: true)
                    }
                }
            } else {
                weexInstance?.viewController?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func refreshWeex() {
        if let vc = weexInstance?.viewController as? WBWeexViewController {
            vc.refreshWeex()
        } else {
            Log.error("Error：当前页面不是WBWeexViewController")
        }
    }
    
    func toWebView(_ info: Dictionary<String, Any>) {
        let vc = WBWebViewController()
        let router = Router.deserialize(from: info)
        openVC(vc, router: router)
    }
    
    func openBrowser(_ url: String) {
        let u = URL(string: url)
        if u != nil {
            UIApplication.shared.open(u!, options: [:], completionHandler: nil)
        } else {
            Log.error("无效的url")
        }
    }
    
    func callPhone(_ info: Dictionary<String, Any>) {
        if let phone = info["phone"] as? String {
            let tel = URL(string: "tel://" + phone)!
            UIApplication.shared.open(tel, options: [:], completionHandler: nil)
        } else {
            Log.error("电话号码错误")
        }
    }
    
    func openVC(_ vc: WBBaseViewController, router: Router?) {
        vc.router = router
        vc.hidesBottomBarWhenPushed = true
        if router?.type == K_ANIMATE_PRESENT {
            weexInstance?.viewController?.present(RTRootNavigationController.init(rootViewController: vc), animated: true, completion: nil)
        } else {
            weexInstance?.viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
