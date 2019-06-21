//
//  HotReload.swift
//  WeexBox
//
//  Created by Mario on 2019/4/15.
//  Copyright © 2019 Ayg. All rights reserved.
//

import Foundation
import SwiftyJSON
import Async

class HotReload: NSObject, SRWebSocketDelegate {
    
    private static var hotReloadSocket: SRWebSocket?
    private static var isReconnect = false
    private static let hotReload = HotReload()
    
    static func open(url: String) {
        hotReloadSocket = SRWebSocket(url: URL(string: url))
        hotReloadSocket?.delegate = hotReload
        hotReloadSocket?.open()
    }
    
    static func reconnect() {
        if isReconnect {
            return
        }
        isReconnect = true
        Async.main(after: 2) {
            isReconnect = false
            hotReloadSocket?.open()
        }
    }
    
    // MARK: SRWebSocketDelegate
    func webSocket(_ webSocket: SRWebSocket!, didReceiveMessage message: Any!) {
        if let messageString = message as? String {
            let messageJson = JSON(parseJSON: messageString)
            let method = messageJson["method"].stringValue
            if method == "WXReloadBundle" {
                Event.emit(name: method, info: messageJson.dictionaryObject)
            }
        }
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didCloseWithCode code: Int, reason: String!, wasClean: Bool) {
        HotReload.reconnect()
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didFailWithError error: Error!) {
        HotReload.reconnect()
    }
    
    func webSocketDidOpen(_ webSocket: SRWebSocket!) {
        HUD.showToast(view: nil, message: "成功开启热重载")
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didReceivePong pongPayload: Data!) {
        
    }
}
