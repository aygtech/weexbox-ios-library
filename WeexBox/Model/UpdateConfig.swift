//
//  UpdateConfig.swift
//  Cornerstone
//
//  Created by Mario on 2018/6/7.
//  Copyright © 2018年 Mario. All rights reserved.
//

import Foundation
import HandyJSON

/// 热更新配置
struct UpdateConfig: HandyJSON {
    
    var name: String!
    var ios_min_version: String!
    var android_min_version: String!
    var release: String!
}

