//
//  BMRouterModel.m
//  WeexBox
//
//  Created by Mario on 2018/8/2.
//  Copyright © 2018年 Ayg. All rights reserved.
//

#import "RouterModule.h"

@implementation RouterModule

WX_EXPORT_METHOD(@selector(openWeex:))
WX_EXPORT_METHOD(@selector(openWeb:))
WX_EXPORT_METHOD(@selector(openNative:))
WX_EXPORT_METHOD_SYNC(@selector(getParams))
WX_EXPORT_METHOD(@selector(close:))
WX_EXPORT_METHOD(@selector(refresh))

@end
