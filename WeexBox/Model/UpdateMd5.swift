//
//  UpdateMd5.swift
//  Cornerstone
//
//  Created by Mario on 2018/6/7.
//  Copyright © 2018年 Mario. All rights reserved.
//

import Foundation
import RealmSwift
import HandyJSON

/// 热更新md5
class Md5Realm: Object {
    
    @objc dynamic var path = ""
    @objc dynamic var md5 = ""
    
    override static func primaryKey() -> String? {
        return "path"
    }
}

struct UpdateMd5: HandyJSON {
    var path: String!
    var md5: String!
    
    func toRealm() -> Md5Realm {
        let md5Realm = Md5Realm()
        md5Realm.path = self.path
        md5Realm.md5 = self.md5
        return md5Realm
    }
}
