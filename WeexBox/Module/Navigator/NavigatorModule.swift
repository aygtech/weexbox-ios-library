//
//  NavigationModule.swift
//  WeexBox
//
//  Created by Mario on 2018/8/22.
//  Copyright © 2018年 Ayg. All rights reserved.
//

import Foundation
import Hue
import SDWebImage
import Async

class NavigatorModule: NavigatorModuleOC {
    
    enum ItemPosition {
        case Right
        case Left
        case Center
    }
    
    // 右边按钮点击回调
    var rightItemsCallback: WXModuleKeepAliveCallback?
    // 左边按钮点击回调
    var leftItemsCallback: WXModuleKeepAliveCallback?
    // 中间按钮点击回调
    var centerItemCallback: WXModuleKeepAliveCallback?
    
    // 设置导航栏右边按钮
    @objc func setRightItems(_ items: Array<Dictionary<String, String>>, callback: WXModuleKeepAliveCallback?) {
        Async.main {
            self.rightItemsCallback = callback
            let barButtonItems = self.createBarButtons(items, position: .Right)
            self.getVC().navigationItem.rightBarButtonItems = barButtonItems
        }
    }
    
    // 兼容Android物理返回按钮
    @objc func onBackPressed(_ callback: WXModuleKeepAliveCallback?) {
        
    }
    
    // 设置导航栏左边按钮
    @objc func setLeftItems(_ items: Array<Dictionary<String, String>>, callback: WXModuleKeepAliveCallback?) {
        Async.main {
            self.leftItemsCallback = callback
            let barButtonItems = self.createBarButtons(items, position: .Left)
            self.getVC().navigationItem.leftBarButtonItems = barButtonItems
        }
    }
    
    // 设置导航栏中间按钮
    @objc  func setCenterItem(_ item: Dictionary<String, String>, callback: WXModuleKeepAliveCallback?) {
        Async.main {
            self.centerItemCallback = callback
            let barButtonItem = self.createBarButton(item, position: .Center)
            self.getVC().navigationItem.titleView = barButtonItem.customView
        }
    }
    
    func createBarButtons(_ items: Array<Dictionary<String, String>>, position: ItemPosition) -> Array<UIBarButtonItem> {
        var barButtonItems = Array<UIBarButtonItem>()
        for (i, item) in items.enumerated() {
            barButtonItems.append(createBarButton(item, position: position, tag: i))
        }
        return barButtonItems
    }
    
    func createBarButton(_ item: Dictionary<String, String>, position: ItemPosition, tag: Int = 0) -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.tag = tag
        var selector: Selector
        switch position {
        case .Center:
            selector = #selector(onClickCenterBarButtion(_:))
        case .Right:
            selector = #selector(onClickRightBarButton(_:))
        case .Left:
            selector = #selector(onClickLeftBarButton(_:))
        }
        button.addTarget(self, action: selector, for: .touchUpInside)
        if let text = item["text"] {
            button.setTitle(text, for: .normal)
            button.setTitle(text, for: .highlighted)
            if let hexColor = item["color"] {
                let color = UIColor(hex: hexColor)
                button.setTitleColor(color, for: .normal)
                button.setTitleColor(color, for: .highlighted)
            }
        } else if let imageUrl = item["image"] {
            let imageHandler = ImageHander()
            imageHandler.downloadImage(withURL: imageUrl, imageFrame: CGRect(), userInfo: nil) { (image, error, finished) in
                if image != nil {
                    let i = image!.changeSize(CGSize(width: image!.size.width / 2, height: image!.size.height / 2))
                    button.setImage(i, for: .normal)
                    button.setImage(i, for: .highlighted)
                }
            }
            //            button.sd_setBackgroundImage(with: URL(string: image), for: .normal, completed: nil)
            //            button.sd_setBackgroundImage(with: URL(string: image), for: .highlighted, completed: nil)
        }
        return UIBarButtonItem(customView: button)
    }
    
    // 右侧itme响应事件
    @objc func onClickRightBarButton(_ button: UIButton) {
        var result = Result()
        result.data = ["index": button.tag]
        rightItemsCallback?(result, true)
    }
    
    // 左侧item响应事件
    @objc func onClickLeftBarButton(_ button: UIButton) {
        var result = Result()
        result.data = ["index": button.tag]
        leftItemsCallback?(result, true)
    }
    
    // 中间item响应事件
    @objc func onClickCenterBarButtion(_ button: UIButton) {
        let result = Result()
        centerItemCallback?(result, true)
    }
    
    // 获取导航栏高度
    @objc func getHeight() -> Float {
        return Float(getVC().navHeight / weexInstance.pixelScaleFactor)
    }
    
    // 设置导航栏颜色
    @objc func setNavColor(_ color: String) {
        getVC().navigationController?.navigationBar.barTintColor = UIColor(hex: color)
    }
}
