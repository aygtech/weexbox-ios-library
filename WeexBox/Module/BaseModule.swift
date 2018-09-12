//
//  BaseModule.swift
//  WeexBox
//
//  Created by Mario on 2018/8/21.
//  Copyright © 2018年 Ayg. All rights reserved.
//

import Foundation

extension BaseModule {
    
   @objc func getVC() -> WBWeexViewController {
        return weexInstance.viewController as! WBWeexViewController
    }
    
}
