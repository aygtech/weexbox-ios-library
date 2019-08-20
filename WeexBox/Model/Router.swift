//
//  Router.swift
//  WeexBox
//
//  Created by Mario on 2018/8/13.
//  Copyright © 2018年 Ayg. All rights reserved.
//

import Foundation
import HandyJSON
import RTRootNavigationController_WeexBox

/// 路由
public struct Router: HandyJSON {

    static var routes = Dictionary<String, UIViewController.Type>()

    // 注册路由
    public static func register(name: String, controller: UIViewController.Type) {
        routes[name] = controller
    }

    public static let typePush = "push"
    public static let typePresent = "present"
    public static let typeModalMask = "modalMask"
    public static let nameWeex = "weex"
    public static let nameWeb = "web"
    public static let nameFlutter = "flutter"

    public init() { }

    // 页面名称
    public var name: String?
    // 下一个weex/web的路径
    public var url: String?
    // 页面出现方式：push, present
    public var type = Router.typePush
    // 是否隐藏导航栏
    public var navBarHidden = false
    // 导航栏标题
    public var title: String?
    // 禁用返回手势
    public var disableGestureBack = false
    // 需要传到下一个页面的数据
    public var params: Dictionary<String, Any>?
    // 打开页面的同时关闭页面
    public var closeFrom: Int?
    // 关闭页面的方向，默认和堆栈方向一致
    public var closeFromBottomToTop = true
    // 关闭页面的个数
    public var closeCount = 1
    
    // 打开页面
    public func open(from: UIViewController) {
        if let pageName = name, let toType = Router.routes[pageName] {
            if toType is WBBaseViewController.Type {
                /// 继承 WBWeexViewController
                let to = toType.init() as! WBBaseViewController
                to.router = self
                push(to: to, from: from)
            }
            else {
                /// 继承 UIViewController
                let to = toType.init()
                // 原生页面只对routerParams有效，无需设置其它参数。
                to.routerJson = toJSONString()
                push(to: to, from: from)
            }
        } else {
            print("路由未注册")
        }
    }

    func push(to: UIViewController, from: UIViewController) {
        to.hidesBottomBarWhenPushed = true
        if type == Router.typePresent {
            from.present(RTRootNavigationController(rootViewController: to), animated: true) {
                self.removeViewControllers(from)
            }
        }
        // 遮罩。
            else if type == Router.typeModalMask {
                from.modalPresentationStyle = .currentContext
                to.modalPresentationStyle = .custom
                to.view.backgroundColor = UIColor.clear;
                from.present(to, animated: false) {
                    self.removeViewControllers(from)
                }
        }
        else {
            // 如果from是透明模态，需要关闭后再打开。
            if from.modalPresentationStyle == .custom {
                let lastCustomModalVc = self.getlastCustomModalVc(vc: from)
                lastCustomModalVc.dismiss(animated: false) {
                    self.push(to: to, from: self.getFromNavigation(vc: lastCustomModalVc))
                }
            }
            else {
                if let rt = from.rt_navigationController {
                    rt.pushViewController(to, animated: true) { (finished) in
                        self.removeViewControllers(from)
                    }
                }
            }
        }
    }
    func getlastCustomModalVc(vc: UIViewController) -> UIViewController {
        let lastPresent = vc.presentingViewController
        //上面已经没有模态。
        if lastPresent == nil {
            return vc
        }
        //上面的模态不是自定义
            else if (lastPresent?.modalPresentationStyle != .custom &&
                    lastPresent?.modalPresentationStyle != .currentContext) {
                return lastPresent!
        }
        else {
            return self.getlastCustomModalVc(vc: vc.presentingViewController!)
        }
    }
    // 确保from有导航控制器
    func getFromNavigation(vc: UIViewController) -> UIViewController {
        if let r_vc = vc.rt_navigationController {
            return r_vc
        }
        else if(vc as? UITabBarController != nil) {
            let tabbar = vc as! UITabBarController
            return tabbar.selectedViewController ?? vc
        }
        return vc;
    }


    func removeViewControllers(_ vc: UIViewController) {
        if closeFrom == nil {
            return
        }
        if let from = closeFrom {
            let count = vc.rt_navigationController.rt_viewControllers.count
            var left: Int!
            var right: Int!
            if closeFromBottomToTop {
                left = from + 1
                right = left + (closeCount - 1)
            } else {
                right = (count - 1) - from - 1
                left = (right - closeCount + 1) < 1 ? 1 : (right - closeCount + 1);
            }
            // 确保根视图和最后一个视图不被删除。
            if left != 0 && left <= right && right < count - 1 {
                let controllers = Array(vc.rt_navigationController.rt_viewControllers[left...right])
                vc.rt_navigationController.removeViewControllers(controllers, animated: false)
            }
            else {
                HUD.showToast(view: nil, message: "路由参数不正常请检查closeCount,closeFromBottomToTop,closeFrom")
            }
        }
    }

    // 关闭页面
    public func close(from: UIViewController, count: Int = 1) {
        if type == Router.typePresent {
            from.dismiss(animated: true, completion: nil)
        }
        else if type == Router.typeModalMask {
            from.dismiss(animated: false, completion: nil)
        }
        else {
            let nav = from.navigationController!
            if count > 1 {
                let index = nav.viewControllers.count - 1 - count
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
