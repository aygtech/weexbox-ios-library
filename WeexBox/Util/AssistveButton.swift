//
//  AssistveButton.swift
//  WeexBox
//
//  Created by 吴玉国 on 2018/11/5.
//  Copyright © 2018 WeexBox. All rights reserved.
//

import UIKit
import SDWebImage

enum YGTouchType {
    case YGAssistiveTypeNone
    case YGAssistiveTypeNearLeft
    case YGAssistiveTypeNearRight
}

typealias eventCallBack = ()->Void


class AssistveButton: UIButton {
    
    var assistveButtonClick:eventCallBack?
    init(frame: CGRect, assistiveType:YGTouchType,eventCallBack:@escaping eventCallBack) {
        super.init(frame: frame)
        self.assistveButtonClick = eventCallBack
        self.type = assistiveType
        let url = URL(string: "https://raw.githubusercontent.com/aygtech/weexbox-document/master/docs/.vuepress/public/logo.png")!
        self.sd_setBackgroundImage(with: url, for: .normal)
        self.sd_setBackgroundImage(with: url, for: .highlighted)
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = frame.size.height / 2.0
        self.layer.masksToBounds = true
        let tap =  UITapGestureRecognizer(target: self, action: #selector(actionAssistveClick))
        self.addGestureRecognizer(tap)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //        super.touchesBegan(touches, with: event)
        let touch = ((touches as NSSet).anyObject() as AnyObject)
        touchPoint = touch.location(in:self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = ((touches as NSSet).anyObject() as AnyObject)
        let currentPosition = touch.location(in:self)
        
        let offsetX = currentPosition.x - touchPoint!.x
        let offsetY = currentPosition.y - touchPoint!.y
        
        let centerX = self.center.x + offsetX
        var centerY = self.center.y + offsetY
        self.center = CGPoint(x: centerX, y: centerY)
        
        let superViewWidth = CGFloat((self.superview?.frame.size.width)!)
        let superViewHeight = CGFloat((self.superview?.frame.size.height)!)
        let btnX = CGFloat(self.frame.origin.x)
        let btnY = CGFloat(self.frame.origin.y)
        let btnW = CGFloat(self.frame.size.width)
        let btnH = CGFloat(self.frame.size.height)
        
        if (btnX > superViewWidth) {
            let centerX = superViewWidth - btnW / 2.0
            self.center = CGPoint(x: centerX, y: centerY)
        } else if (btnX < 0.0) {
            let centerX = CGFloat(btnW * 0.5)
            self.center = CGPoint(x: centerX, y: centerY)
        }
        let defaultNaviHeight = UIApplication.shared.statusBarFrame.size.height + 44.0
        let judgeSuperViewHeight = superViewHeight - defaultNaviHeight
        
        if (btnY <= 0.0) {
            centerY = btnH * 0.7
            self.center = CGPoint(x: centerX, y: centerY)
        } else if (btnY > judgeSuperViewHeight) {
            let y = superViewHeight - btnH * 0.5
            self.center = CGPoint(x: btnX, y: y)
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //        super.touchesEnded(touches, with: event)
        let btnWidth = CGFloat(self.frame.size.width)
        let btnHeight = CGFloat(self.frame.size.height)
        let btnY = CGFloat(self.frame.origin.y)
        
        switch type {
        case .YGAssistiveTypeNone?:
            if (self.center.x >= (self.superview?.frame.size.width)! / 2.0) {
                UIView.animate(withDuration: 0.5) {
                    let btnX = (self.superview?.frame.size.width)! - btnWidth
                    self.frame = CGRect(x: btnX, y: btnY, width: btnWidth, height: btnHeight)
                }
            } else {
                UIView.animate(withDuration: 0.5) {
                    let btnX = 0.0
                    self.frame = CGRect(x: CGFloat(btnX), y: btnY, width: btnWidth, height: btnHeight)
                }
            }
            break
        case .YGAssistiveTypeNearLeft?:
            UIView.animate(withDuration: 0.5) {
                let btnX = 0.0
                self.frame = CGRect(x: CGFloat(btnX), y: btnY, width: btnWidth, height: btnHeight)
            }
            break
        case .YGAssistiveTypeNearRight?:
            UIView.animate(withDuration: 0.5) {
                let btnX = (self.superview?.frame.size.width)! - btnWidth
                self.frame = CGRect(x: btnX, y: btnY, width: btnWidth, height: btnHeight)
            }
            break
        default:
            break
        }
    }
    
    private var type:YGTouchType?
    private var touchPoint:CGPoint?
}

extension AssistveButton {
    @objc func actionAssistveClick() {
        if (self.assistveButtonClick != nil) {
            self.assistveButtonClick!()
        }
    }
}
