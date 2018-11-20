//
//  BMRouterModel.m
//  WeexBox
//
//  Created by Mario on 2018/8/2.
//  Copyright © 2018年 Ayg. All rights reserved.
//

#import "RouterModule.h"

#pragma clang diagnostic ignored "-Wundeclared-selector"
@implementation RouterModuleOC

WX_EXPORT_METHOD(@selector(open:))
WX_EXPORT_METHOD_SYNC(@selector(getParams))
WX_EXPORT_METHOD(@selector(close:))
WX_EXPORT_METHOD(@selector(refresh))

@end
#pragma clang diagnostic pop
