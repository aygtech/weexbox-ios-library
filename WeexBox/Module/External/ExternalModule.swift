//
//  ExternalModule.swift
//  WeexBox
//
//  Created by Mario on 2018/8/18.
//  Copyright © 2018年 Ayg. All rights reserved.
//

import Foundation

extension ExternalModule {
    
    // 打开浏览器
    func openBrowser(_ url: String) {
        External.openBrowser(url)
    }
    
    // 打电话
    func callPhone(_ phone: String) {
        External.callPhone(phone)
    }
}
