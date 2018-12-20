//
//  WBAssistiveTouch.swift
//  WeexBox
//
//  Created by Baird-weng on 2018/12/19.
//

import UIKit
import XFAssistiveTouch_WeexBox

typealias touchCallback = (_ index:Int)->Void

class AssistiveTouch: NSObject,XFXFAssistiveTouchDelegate {
    var callBack:touchCallback?
    static let sing = AssistiveTouch()
    let icons = [
        "https://raw.githubusercontent.com/aygtech/aygtech.github.io/master/docs/.vuepress/public/refesh.png",
        "https://raw.githubusercontent.com/aygtech/aygtech.github.io/master/docs/.vuepress/public/camera.png"
    ]
    override init() {
        super.init()
        let touch = XFAssistiveTouch.sharedInstance()
        touch.delegate = self;
    }
    func show(){
        XFAssistiveTouch.sharedInstance().show()
    }
    func dissShow(){
        XFAssistiveTouch.sharedInstance().navigationController.shrink()
    }
    func numberOfItems(in viewController: XFATViewController) -> Int {
        return icons.count
    }
    func viewController(_ viewController: XFATViewController, itemViewAtPosition position: XFATPosition) -> XFATItemView {
        let itemView = XFATItemView();
        let itemView_width = 70;
        itemView.bounds = CGRect(x: 0, y: 0, width: itemView_width, height: itemView_width)
        
        let iconView = UIView(frame: itemView.bounds)
        iconView.backgroundColor = .white
        iconView.layer.cornerRadius = CGFloat(itemView_width/2)
        iconView.layer.masksToBounds = true
        itemView.addSubview(iconView)
        
        
        let icon =  UIImageView()
        icon.sd_setImage(with: URL(string: icons[position.index]), completed: nil);
        iconView.addSubview(icon)
        icon.contentMode = .scaleAspectFill
        icon.layer.masksToBounds = true
        icon.snp.makeConstraints { (make) in
            make.width.height.equalTo(35)
            make.center.equalTo(iconView)
        }
        
        return itemView
    }
    func viewController(_ viewController: XFATViewController, didSelectedAtPosition position: XFATPosition) {
        if(callBack != nil){
            callBack!(position.index)
        }
    }
}
