//
//  LottieComponent.swift
//  WeexBox
//
//  Created by Mario on 2019/1/15.
//  Copyright © 2019 Ayg. All rights reserved.
//

import Foundation
import Lottie

class LottieComponent: LottieComponentOC {

    var animationView: LOTAnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSource(attributes)
        applyProperties(attributes)
    }
    
    override func updateAttributes(_ attributes: [AnyHashable : Any] = [:]) {
        super.updateAttributes(attributes)
        
        if loadSource(attributes) {
            applyProperties(self.attributes)
        } else {
            applyProperties(attributes)
        }
    }
    
    func loadSource(_ attributes: [AnyHashable : Any]) -> Bool {
        if let sourceJson = attributes["sourceJson"] as? [AnyHashable : Any] {
            replaceAnimationView(next: LOTAnimationView(json: sourceJson))
            return true
        } else if let sourceUrl = attributes["sourceUrl"] {
            replaceAnimationView(next: LOTAnimationView(contentsOf: URL(string: WXConvert.nsString(sourceUrl))!))
            return true
        }
        return false
    }
    
    func replaceAnimationView(next: LOTAnimationView) {
        animationView?.removeFromSuperview()
        animationView = next
        view.addSubview(next)
        animationView?.frame = view.frame
    }
    
    func applyProperties(_ attributes: [AnyHashable : Any]) {
        if let speed = attributes["speed"] {
            animationView?.animationSpeed = WXConvert.cgFloat(speed)
        }
        if let loop = attributes["loop"] {
            animationView?.loopAnimation = WXConvert.bool(loop)
        }
        var contentMode: UIView.ContentMode?
        switch WXConvert.nsString(attributes["resizeMode"]) {
        case "cover":
            contentMode = .scaleAspectFill
        case "contain":
            contentMode = .scaleAspectFit
        case "center":
            contentMode = .center
        default:
            break
        }
        if contentMode != nil {
            animationView?.contentMode = contentMode!
        }

    }
    
    func complete(_ complete: Bool, _ callback: WXKeepAliveCallback?) {
        var result = Result()
        result.data["complete"] = complete
        callback?(result, false)
    }
    
    @objc func isAnimationPlaying() -> Bool {
        return animationView?.isAnimationPlaying ?? false
    }
    
    @objc func play(fromProgress: Any, toProgress: Any, callback: WXKeepAliveCallback?) {
        stop()
        animationView?.play(fromProgress: WXConvert.cgFloat(fromProgress), toProgress: WXConvert.cgFloat(toProgress), withCompletion: { [weak self] (complete) in
            self?.complete(complete, callback)
        })
    }
    
    @objc func play(fromFrame: Any, toFrame: Any, callback: WXKeepAliveCallback?) {
        stop()
        animationView?.play(fromFrame: NSNumber(value: WXConvert.nsInteger(fromFrame)), toFrame: NSNumber(value: WXConvert.nsInteger(toFrame)), withCompletion: { [weak self] (complete) in
            self?.complete(complete, callback)
        })
    }
    
    @objc func play(_ callback: WXKeepAliveCallback?) {
        animationView?.play(completion: { [weak self] (complete) in
            self?.complete(complete, callback)
        })
    }
    
    @objc func pause() {
        animationView?.pause()
    }
    
    @objc func stop() {
        animationView?.stop()
    }
    
}
