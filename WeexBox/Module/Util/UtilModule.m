//
//  UtilModule.m
//  WeexBox
//
//  Created by Mario on 2018/8/18.
//  Copyright © 2018年 Ayg. All rights reserved.
//

#import "UtilModule.h"

#pragma clang diagnostic ignored "-Wundeclared-selector"
@implementation UtilModuleOC

WX_EXPORT_METHOD_SYNC(@selector(getStatusBarHeight))
WX_EXPORT_METHOD_SYNC(@selector(getScreenWidth))
WX_EXPORT_METHOD_SYNC(@selector(getScreenHeight))
WX_EXPORT_METHOD_SYNC(@selector(getWeexWidth))
WX_EXPORT_METHOD_SYNC(@selector(getWeexHeight))

@end
#pragma clang diagnostic pop
