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

/// 路由
public struct Router: HandyJSON {
    
    static var routes = Dictionary<String, WBBaseViewController.Type>()
    static func register(url: String, controller: WBBaseViewController.Type) {
        routes[url] = controller
    }
    
    static let typePush = "push"
    static let typePresent = "present"
    
    public init() {}
    
    // 下一个weex/web/Browser/Phone的路径；Native注册的路径
    var url: String?
    // 页面出现方式：push, present
    var type: String = Router.typePush
    // 是否隐藏导航栏
    var navBarHidden: Bool = false
    // 需要传到下一个页面的数据
    var params: Dictionary<String, Any>?
    
    // 打开weex页面
    func openWeex(from: WBBaseViewController) {
        open(from: from, to: WBWeexViewController())
    }
    
    // 打开内部web页面
    func openWeb(from: WBBaseViewController) {
        open(from: from, to: WBWebViewController())
    }
    
    // 打开原生页面
    func openNative(from: WBBaseViewController) {
        if let to = Router.routes[url!] {
            open(from: from, to: to.init())
        } else {
            Log.e("该路由名未注册")
        }
    }
    
    // 打开外部浏览器
    func openBrowser() {
        UIApplication.shared.open(URL(string: url!)!, options: [:], completionHandler: nil)
    }
    
    // 打电话
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
    
    // 关闭页面
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
