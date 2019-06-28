//
//  HUD.swift
//  WeexBox
//
//  Created by Mario on 2018/10/30.
//  Copyright © 2018 Ayg. All rights reserved.
//

import Foundation
import MBProgressHUD
import Lottie

class WBLOTAnimationView: LOTAnimationView {
    override var intrinsicContentSize: CGSize{
        return WeexBoxEngine.hudLotContentSize
    }
}
@objc open class HUD: NSObject {
    
    // view为nil时会加在window上
    @objc public static func showLoading(view: UIView?, message: String?) {
        let hud = getHUD(view: view)
        hud.mode = (WeexBoxEngine.hudGifName != nil || WeexBoxEngine.hudAnimationJsonFileName != nil) ? .customView : .indeterminate
        if WeexBoxEngine.hudGifName != nil || WeexBoxEngine.hudAnimationJsonFileName != nil {
            hud.customView = self.getCustomView()
        }
        self.setCustomConfig(hud: hud)
        hud.label.text = message;
    }
    @objc public static func showProgress(view: UIView?, progress: Float, message: String?) {
        let hud = getHUD(view: view)
        hud.mode = .annularDeterminate
        hud.progress = progress
        self.setCustomConfig(hud: hud)
        hud.label.text = message
    }
    
    public static func showToast(view: UIView?, message: String, duration: Double?) {
        let hud = getHUD(view: view)
        hud.isUserInteractionEnabled = false
        hud.mode = .text
        hud.label.text = message
        hud.label.numberOfLines = 0
        self.setCustomConfig(hud: hud)
        hud.hide(animated: true, afterDelay: duration ?? 2)
    }
    
    // 以后要删除
    @objc public static func showToast(view: UIView?, message: String) {
        let hud = getHUD(view: view)
        hud.isUserInteractionEnabled = false
        hud.mode = .text
        hud.label.text = message
        hud.label.numberOfLines = 0
        self.setCustomConfig(hud: hud)
        hud.hide(animated: true, afterDelay: 2)
    }
    
    @objc public static func dismiss(view: UIView?) {
        let hud = MBProgressHUD(for: view ?? getWindow())
        if hud != nil {
            if hud!.mode == .text {
                return
            }
            hud!.hide(animated: true)
        }
    }
    
    static func getHUD(view: UIView?) -> MBProgressHUD {
        let hud = MBProgressHUD(for: view ?? getWindow()) ?? MBProgressHUD.showAdded(to: view ?? getWindow(), animated: true)
        hud.isUserInteractionEnabled = true
        return hud
    }
    
    //设置配置。
    static func setCustomConfig(hud: MBProgressHUD) {
        if WeexBoxEngine.hudBackGroundColor != nil {
            hud.bezelView.style = .solidColor
            hud.bezelView.backgroundColor = WeexBoxEngine.hudBackGroundColor
        }
        if WeexBoxEngine.hudContentColor != nil {
            hud.contentColor = WeexBoxEngine.hudContentColor
            hud.activityIndicatorColor = UIColor.white;
        }
    }
    /// 获取自定义视图
    static func getCustomView() -> UIView {
        if WeexBoxEngine.hudGifName != nil {
            let imageData = NSData.init(contentsOfFile: Bundle.main.path(forResource: WeexBoxEngine.hudGifName!, ofType: "gif") ?? "")
            if imageData != nil {
                let gifImage = UIImage.sd_image(withGIFData: imageData as Data?)
                let gifImageView = UIImageView.init(image: gifImage)
                return gifImageView
            }
            else {
                return UIView()
            }
        }
        else if WeexBoxEngine.hudAnimationJsonFileName != nil{
            let animationView = WBLOTAnimationView.init(name: WeexBoxEngine.hudAnimationJsonFileName!)
            animationView.loopAnimation = true
            animationView.play()
            return animationView
        }
        return UIView()
    }
    static func getWindow() -> UIView {
        var window = UIApplication.shared.delegate!.window!!
        if window.windowLevel != UIWindow.Level.normal {
            let windowArray = UIApplication.shared.windows
            for tempWin in windowArray {
                if tempWin.windowLevel == UIWindow.Level.normal {
                    window = tempWin
                    break
                }
            }
        }
        return window
    }
}
