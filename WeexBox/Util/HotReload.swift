//
//  HotReload.swift
//  WeexBox
//
//  Created by Mario on 2019/4/15.
//  Copyright © 2019 Ayg. All rights reserved.
//

import Foundation
import SwiftyJSON

class HotReload: NSObject, SRWebSocketDelegate {
    
    private var hotReloadSocket: SRWebSocket?
    
    override init() {
        super.init()
        
        if let hotReloadURL = Bundle.main.object(forInfoDictionaryKey: "WXSocketConnectionURL") as? String {
            hotReloadSocket = SRWebSocket(url: URL(string: hotReloadURL))
            hotReloadSocket?.delegate = self
            hotReloadSocket?.open()
        }
    }
    
    // MARK: SRWebSocketDelegate
    public func webSocket(_ webSocket: SRWebSocket!, didReceiveMessage message: Any!) {
        if let messageString = message as? String {
            let messageJson = JSON(parseJSON: messageString)
            let method = messageJson["method"].stringValue
            if method == "WXReloadBundle" {
                Event.emit(name: method, info: messageJson.dictionaryObject)
            }
        }
    }
}
