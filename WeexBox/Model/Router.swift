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
    // 指定关闭堆栈的哪些页面
    public var closeFrom: Int?
    // 关闭页面的方向，默认和堆栈方向一致
    public var closeFromLeftToRight = true
    public var closeCount: Int?
    
    // 打开原生页面
    public func open(from: WBBaseViewController) {
        if let toType = Router.routes[name] {
            let to = toType.init()
            to.router = self
            to.hidesBottomBarWhenPushed = true
            if type == Router.typePresent {
                from.present(RTRootNavigationController.init(rootViewController: to), animated: true) {
                    self.removeViewControllers(from)
                }
            } else {
                from.rt_navigationController.pushViewController(to, animated: true) { (finished) in
                    self.removeViewControllers(from)
                }
            }
        } else {
            Log.e("该路由名未注册")
        }
    }
    
    func removeViewControllers(_ vc: WBBaseViewController) {
        if let from = closeFrom {
            let count = vc.rt_navigationController.rt_viewControllers.count
            var left: Int!
            var right: Int!
            if closeFromLeftToRight {
                left = from
                right = (closeCount != nil) ? (closeCount! + left - 1) : (count - 2)
            } else {
                right = count - 2 - from
                left = (closeCount != nil) ? (right - closeCount! + 1) : 1
                
            }
            let controllers = Array(vc.rt_navigationController.rt_viewControllers[left...right])
            vc.rt_navigationController.removeViewControllers(controllers, animated: false)
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
