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
    
    private var hotReloadSocket: SRWebSocket?
    private var isReconnect = false
    
    override init() {
        super.init()
        
        if let hotReloadURL = Bundle.main.object(forInfoDictionaryKey: "WXSocketConnectionURL") as? String {
            hotReloadSocket = SRWebSocket(url: URL(string: hotReloadURL))
            hotReloadSocket?.delegate = self
            hotReloadSocket?.open()
        }
    }
    
    func reconnect() {
        if isReconnect {
            return
        }
        isReconnect = true
        Async.main(after: 2) { [weak self] in
            self?.isReconnect = false
            self?.hotReloadSocket?.open()
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
        reconnect()
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didFailWithError error: Error!) {
        reconnect()
    }
}
