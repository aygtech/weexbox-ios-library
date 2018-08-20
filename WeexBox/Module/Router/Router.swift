//
//  Router.swift
//  WeexBox
//
//  Created by Mario on 2018/8/13.
//  Copyright © 2018年 Ayg. All rights reserved.
//

import Foundation
import HandyJSON
import RTRootNavigationController

public struct Router: HandyJSON {
    
    static var routes = Dictionary<String, WBBaseViewController.Type>()
    static func register(url: String, controller: WBBaseViewController.Type) {
        routes[url] = controller
    }
    
    static let typePush = "push"
    static let typePresent = "present"
    
    public init() {}
    
    // 下一个weex页面路径
    var url: String?
    // 页面出现方式：push, present
    var type: String = Router.typePush
    // 是否隐藏导航栏
    var navBarHidden: Bool = false
    // 需要传到下一个页面的数据
    var params: Dictionary<String, Any>?
    
    func openWeex(from: WBBaseViewController) {
        open(from: from, to: WBWeexViewController())
    }
    
    func openWeb(from: WBBaseViewController) {
        open(from: from, to: WBWebViewController())
    }
    
    func openNative(from: WBBaseViewController) {
        if let to = Router.routes[url!] {
            open(from: from, to: to.init())
        } else {
            Log.e("该路由名未注册")
        }
    }
    
    func openBrowser() {
        UIApplication.shared.open(URL(string: url!)!, options: [:], completionHandler: nil)
    }
    
    func openPhone() {
        UIApplication.shared.open(URL(string: "tel://" + url!)!, options: [:], completionHandler: nil)
    }
    
    func open(from: WBBaseViewController, to: WBBaseViewController) {
        to.router = self
        to.hidesBottomBarWhenPushed = true
        if type == Router.typePresent {
            from.present(RTRootNavigationController.init(rootViewController: to), animated: true, completion: nil)
        } else {
            from.navigationController!.pushViewController(to, animated: true)
        }
    }
    
    func close(from: WBBaseViewController, levels: Int? = nil) {
        if type == Router.typePresent {
            from.dismiss(animated: true, completion: nil)
        } else {
            let nav = from.navigationController!
            if let l = levels, l > 1 {
                let index = nav.viewControllers.count - 1 - l
                if index <= 0 {
                    nav.popToRootViewController(animated: true)
                } else {
                    let vc = nav.viewControllers[index]
                    nav.popToViewController(vc, animated: true)
                }
            } else {
                nav.popViewController(animated: true)
            }
        }
    }
}
