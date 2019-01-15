//
//  LottieComponentOC.m
//  WeexBox
//
//  Created by Mario on 2019/1/15.
//  Copyright © 2019 Ayg. All rights reserved.
//

#import "LottieComponent.h"

@implementation LottieComponentOC

WX_EXPORT_METHOD_SYNC(@selector(isAnimationPlaying))
WX_EXPORT_METHOD(@selector(playFromProgress:toProgress:completion:))
WX_EXPORT_METHOD(@selector(playFromFrame:toFrame:completion:))
WX_EXPORT_METHOD(@selector(play:))
WX_EXPORT_METHOD(@selector(pause))
WX_EXPORT_METHOD(@selector(stop))

@end
