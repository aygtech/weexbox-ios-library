//
//  LottieComponent.swift
//  WeexBox
//
//  Created by Mario on 2019/1/15.
//  Copyright © 2019 Ayg. All rights reserved.
//

import Foundation
import Lottie
import HandyJSON
import SwiftyJSON

struct AnimationObject: HandyJSON {
    
    var v: String?
    var fr: Double?
    var ip: Double?
    var op: Double?
    var w: Double?
    var h: Double?
    var nm: String?
    var ddd: Double?
    var assets: Array<Any>?
    var layers: Array<Any>?
}

struct AnimatedLottieViewProps: HandyJSON {
    
    var source: Any!
    var progress: Double?
    var speed: Double?
    var duration: Double?
    var loop: Bool?
    var style: [AnyHashable : Any]?
    var imageAssetsFolder: String?
    var hardwareAccelerationAndroid: Bool?
    var resizeMode: String?  // "cover" | "contain" | "center"
    var cacheStrategy: String?  // 'strong' | 'weak' | 'none'
    var autoPlay: Bool?
    var autoSize: Bool?
    var enableMergePathsAndroidForKitKatAndAbove: Bool?
//    var onAnimationFinish: (isCancelled: boolean) => void
}


class LottieComponent: LottieComponentOC {

    var animationView: LOTAnimationView?
    
    var loop: Bool! {
        didSet {
            animationView?.loopAnimation = loop
        }
    }
    var speed: CGFloat! {
        didSet {
            animationView?.animationSpeed = speed
        }
    }
    var progress: CGFloat! {
        didSet {
            animationView?.animationProgress = progress
        }
    }
    var sourceJson: String! {
        didSet {
            let json = JSON(parseJSON: sourceJson).dictionaryObject!
            replaceAnimationView(next: LOTAnimationView(json: json))
        }
    }
    var sourceName: String! {
        didSet {
            replaceAnimationView(next: LOTAnimationView(name: sourceName))
        }
    }
    var resizeMode: String! {
        didSet {
            var contentMode = UIView.ContentMode.scaleAspectFit
            switch resizeMode {
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
    
//    var  onAnimationFinish: RCTBubblingEventBlock
    
    override init(ref: String, type: String, styles: [AnyHashable : Any]?, attributes: [AnyHashable : Any]? = nil, events: [Any]?, weexInstance: WXSDKInstance) {
        super.init(ref: ref, type: type, styles: styles, attributes: attributes, events: events, weexInstance: weexInstance)
        
    }
    
    override func loadView() -> UIView {
        return UIView()
    }
    
    override func viewDidLoad() {
        
    }
    
//    override func addEvent(_ eventName: String) {
//        switch eventName {
//        case "play":
//
//        default:
//            <#code#>
//        }
//    }
    
    func play() {
        animationView?.play()
    }
    
    func play(completion: LOTAnimationCompletionBlock?) {
        animationView?.play(completion: completion)
    }
    
    func play(startFrame: NSNumber, endFrame: NSNumber, completion: LOTAnimationCompletionBlock?) {
        animationView?.play(fromFrame: startFrame, toFrame: endFrame, withCompletion: completion)
    }
    
    func reset() {
        animationView?.animationProgress = 0
        animationView?.pause()
    }
    
    @objc func play(_ startFrame: Int, _ endFrame: Int) {
        
    }
    
    func replaceAnimationView(next: LOTAnimationView) {
        var contentMode = UIView.ContentMode.scaleAspectFit
        if (animationView != nil) {
            contentMode = animationView!.contentMode
            animationView!.removeFromSuperview()
        }
        animationView = next
        view.addSubview(next)
        animationView!.frame = view.frame
        animationView!.contentMode = contentMode
        applyProperties()
    }
    
    func applyProperties() {
//        animationView!.animationProgress = progress
//        animationView!.animationSpeed = speed
//        animationView!.loopAnimation = loop
    }
    
}
