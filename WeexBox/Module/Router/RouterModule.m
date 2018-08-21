//
//  BMRouterModel.m
//  WeexBox
//
//  Created by Mario on 2018/8/2.
//  Copyright © 2018年 Ayg. All rights reserved.
//

#import "RouterModule.h"

@implementation RouterModule

WX_EXPORT_METHOD(@selector(open:))
WX_EXPORT_METHOD_SYNC(@selector(getParams))
WX_EXPORT_METHOD(@selector(back:))
WX_EXPORT_METHOD(@selector(refresh))
WX_EXPORT_METHOD(@selector(toWebView:))
WX_EXPORT_METHOD(@selector(callPhone:))
WX_EXPORT_METHOD(@selector(openBrowser:))


@end
