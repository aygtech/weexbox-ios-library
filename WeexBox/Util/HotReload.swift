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
    
    private static var isConnect = false
    private static let hotReload = HotReload()
    private static var url: String?
    
    static func open(url: String) {
        HotReload.url = url
        connect()
    }
    
    static func connect() {
        if isConnect {
            return
        }
        isConnect = true
        Async.main(after: 2) {
            isConnect = false
            let ws = SRWebSocket(url: URL(string: url!))
            ws?.delegate = hotReload
            ws?.open()
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
        HotReload.connect()
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didFailWithError error: Error!) {
        HotReload.connect()
    }
    
    func webSocketDidOpen(_ webSocket: SRWebSocket!) {
        HUD.showToast(view: nil, message: "热重载开启")
    }

}
