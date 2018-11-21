//
//  ExternalModule.m
//  WeexBox
//
//  Created by Mario on 2018/8/18.
//  Copyright © 2018年 Ayg. All rights reserved.
//

#import "ExternalModule.h"

#pragma clang diagnostic ignored "-Wundeclared-selector"
@implementation ExternalModuleOC

WX_EXPORT_METHOD(@selector(openBrowser:))
WX_EXPORT_METHOD(@selector(callPhone:))
WX_EXPORT_METHOD(@selector(openCamera:callback:))
WX_EXPORT_METHOD(@selector(openPhoto:callback:))

@end
#pragma clang diagnostic pop
