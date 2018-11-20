//
//  NetworkModule.m
//  WeexBox
//
//  Created by Mario on 2018/8/18.
//  Copyright © 2018年 Ayg. All rights reserved.
//

#import "NetworkModule.h"

#pragma clang diagnostic ignored "-Wundeclared-selector"
@implementation NetworkModuleOC

WX_EXPORT_METHOD(@selector(request:callback:))
WX_EXPORT_METHOD(@selector(upload:completionCallback:progressCallback:))

@end
#pragma clang diagnostic pop
