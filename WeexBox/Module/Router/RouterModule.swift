//
//  RouterModule.swift
//  WeexBox
//
//  Created by Mario on 2018/8/13.
//  Copyright © 2018年 Ayg. All rights reserved.
//

import Foundation
import HandyJSON
import Async

class RouterModule: RouterModuleOC {
    
    // 打开页面
    @objc func open(_ options: Dictionary<String, Any>) {
        Async.main {
            self.getRouter(options: options).open(from: self.getVC())
        }
    }
    
    // 获取router的params参数
    @objc func getParams() -> Result.JsResult {
        return getVC().router.params
    }
    
    // 关闭
    @objc func close(_ levels: Int) {
        Async.main {
            self.getVC().router.close(from: self.getVC(), levels: levels)
        }
    }
    
    // 刷新
    @objc func refresh() {
        Async.main {
            self.getVC().refreshWeex()
        }
    }
    
    func getRouter(options: Dictionary<String, Any>) -> Router {
        return Router.deserialize(from: options)!
    }
    
}
