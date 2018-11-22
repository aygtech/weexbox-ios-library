//
//  NavigatorModule.m
//  WeexBox
//
//  Created by Mario on 2018/8/9.
//  Copyright © 2018年 Ayg. All rights reserved.
//

#import "NavigatorModule.h"

#pragma clang diagnostic ignored "-Wundeclared-selector"
@implementation NavigatorModuleOC

WX_EXPORT_METHOD(@selector(disableGestureBack:))
WX_EXPORT_METHOD(@selector(setRightItems:callback:))
WX_EXPORT_METHOD(@selector(setLeftItems:callback:))
WX_EXPORT_METHOD(@selector(setCenterItem:callback:))
WX_EXPORT_METHOD(@selector(onBackPressed:))
WX_EXPORT_METHOD_SYNC(@selector(getHeight:))

@end
#pragma clang diagnostic pop

