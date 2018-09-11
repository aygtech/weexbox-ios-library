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
    public static func register(name: String, controller: WBBaseViewController.Type) {
        routes[name] = controller
    }
    
    public static let typePush = "push"
    public static let typePresent = "present"
    public static let weex = "weex"
    public static let web = "web"
    
    public init() {}
    
    // 页面名称
    public var name: String = ""
    // 下一个weex/web的路径
    public var url: String?
    // 页面出现方式：push, present
    public var type: String = Router.typePush
    // 是否隐藏导航栏
    public var navBarHidden: Bool = false
    // 需要传到下一个页面的数据
    public var params: Dictionary<String, Any>?
    
    // 打开原生页面
    public func open(from: WBBaseViewController) {
        if let toType = Router.routes[name] {
            let to = toType.init()
            to.router = self
            to.hidesBottomBarWhenPushed = true
            if type == Router.typePresent {
                from.present(RTRootNavigationController.init(rootViewController: to), animated: true, completion: nil)
            } else {
                from.navigationController!.pushViewController(to, animated: true)
            }
        } else {
            Log.e("该路由名未注册")
        }
    }
    
    // 关闭页面
    public func close(from: WBBaseViewController, levels: Int? = nil) {
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
