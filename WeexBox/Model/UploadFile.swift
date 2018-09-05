//
//  UploadFile.swift
//  WeexBox
//
//  Created by Mario on 2018/8/20.
//  Copyright © 2018年 Ayg. All rights reserved.
//

import Foundation
import HandyJSON

/// 上传文件信息
public struct UploadFile: HandyJSON {
    
    public init(){}
    
    var url: URL!
    var name: String!
    
}
