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
        
        loadSource()
    }
    
    override func updateAttributes(_ attributes: [AnyHashable : Any] = [:]) {
        super.updateAttributes(attributes)
        
        applyProperties(attributes)
    }
    
    func loadSource() {
        if let sourceJson = attributes["sourceJson"] as? [AnyHashable : Any] {
            replaceAnimationView(next: LOTAnimationView(json: sourceJson))
        } else if let sourceName = attributes["sourceName"] {
            replaceAnimationView(next: LOTAnimationView(name: WXConvert.nsString(sourceName)))
        } else if let sourceUrl = attributes["sourceUrl"] {
            replaceAnimationView(next: LOTAnimationView(contentsOf: URL(string: WXConvert.nsString(sourceUrl))!))
        }
    }
    
    func replaceAnimationView(next: LOTAnimationView) {
        var contentMode = UIView.ContentMode.scaleAspectFit
        if (animationView != nil) {
            contentMode = animationView!.contentMode
            animationView?.removeFromSuperview()
        }
        animationView = next
        view.addSubview(next)
        animationView?.frame = view.frame
        animationView?.contentMode = contentMode
        applyProperties(attributes)
        if let autoPlay = attributes["autoPlay"], WXConvert.bool(autoPlay) {
            play(nil)
        }
    }
    
    func applyProperties(_ attributes: [AnyHashable : Any]) {
        if let progress = attributes["progress"] {
            animationView?.animationProgress = WXConvert.cgFloat(progress)
        }
        if let speed = attributes["speed"] {
            animationView?.animationSpeed = WXConvert.cgFloat(speed)
        }
        if let loop = attributes["loop"] {
            animationView?.loopAnimation = WXConvert.bool(loop)
        }
        if let resizeMode = attributes["resizeMode"] {
            var contentMode = UIView.ContentMode.scaleAspectFit
            switch WXConvert.nsString(resizeMode) {
            case "cover":
                contentMode = .scaleAspectFill
            case "contain":
                contentMode = .scaleAspectFit
            case "center":
                contentMode = .center
            default:
                break
            }
            animationView?.contentMode = contentMode
        }
    }
    
    @objc func isAnimationPlaying() -> Bool {
        return animationView?.isAnimationPlaying ?? false
    }
    
    @objc func play(fromProgress: Any, _ toProgress: Any, _ completion: WXKeepAliveCallback?) {
        animationView?.play(fromProgress: WXConvert.cgFloat(fromProgress), toProgress: WXConvert.cgFloat(toProgress), withCompletion: { (complete) in
            completion?(complete, false)
        })
    }
    
    @objc func play(fromFrame: Any, _ toFrame: Any, _ completion: WXKeepAliveCallback?) {
        animationView?.play(fromFrame: NSNumber(value: WXConvert.nsInteger(fromFrame)), toFrame: NSNumber(value: WXConvert.nsInteger(toFrame)), withCompletion: { (complete) in
            completion?(complete, false)
        })
    }
    
    @objc func play(_ completion: WXKeepAliveCallback?) {
        animationView?.play(completion: { (complete) in
            completion?(complete, false)
        })
    }
    
    @objc func pause() {
        animationView?.pause()
    }
    
    @objc func stop() {
        animationView?.stop()
    }
    
}
