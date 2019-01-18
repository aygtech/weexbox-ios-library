//
//  LottieComponentOC.m
//  WeexBox
//
//  Created by Mario on 2019/1/15.
//  Copyright © 2019 Ayg. All rights reserved.
//

#import "LottieComponent.h"

#pragma clang diagnostic ignored "-Wundeclared-selector"
@implementation LottieComponentOC

WX_EXPORT_METHOD_SYNC(@selector(isAnimationPlaying))
WX_EXPORT_METHOD(@selector(playFromProgress:toProgress:callback:))
WX_EXPORT_METHOD(@selector(playFromFrame:toFrame:callback:))
WX_EXPORT_METHOD(@selector(play:))
WX_EXPORT_METHOD(@selector(pause))
WX_EXPORT_METHOD(@selector(stop))

@end
#pragma clang diagnostic pop
