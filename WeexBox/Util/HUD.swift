//
//  HUD.swift
//  WeexBox
//
//  Created by Mario on 2018/10/30.
//  Copyright © 2018 Ayg. All rights reserved.
//

import Foundation
import MBProgressHUD

open class HUD {
    
    // view为nil时会加在window上
    public static func showLoading(view: UIView?, message: String?) {
        let hud = getHUD(view: view)
        hud.label.text = message
    }
    
    public static func showProgress(view: UIView?, progress: Float, message: String?) {
        let hud = getHUD(view: view)
        hud.mode = .annularDeterminate
        hud.progress = progress
        hud.label.text = message
    }
    
    public static func showToast(view: UIView?, message: String, duration: Double?) {
        let hud = getHUD(view: view)
        hud.mode = .text
        hud.label.text = message
        hud.offset = CGPoint(x: 0, y: MBProgressMaxOffset)
        hud.hide(animated: true, afterDelay: duration ?? 3)
    }
    
    public static func dismiss(view: UIView?) {
        let hud = MBProgressHUD(for: view ?? getWindow())
        if hud != nil {
            if hud!.mode == .text {
                return
            }
            hud!.hide(animated: true)
        }
    }
    
    static func getHUD(view: UIView?) -> MBProgressHUD {
        let hud = MBProgressHUD(for: view ?? getWindow())
        return hud ?? MBProgressHUD.showAdded(to: view ?? getWindow(), animated: true)
    }
    
    static func getWindow() -> UIView {
        var window = UIApplication.shared.keyWindow!
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
