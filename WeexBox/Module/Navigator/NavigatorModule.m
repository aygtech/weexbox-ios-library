//
//  NavigatorModule.m
//  WeexBox
//
//  Created by Mario on 2018/8/9.
//  Copyright © 2018年 Ayg. All rights reserved.
//

#import "NavigatorModule.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <RTRootNavigationController/RTRootNavigationController.h>
#import <WeexSDK/WeexSDK.h>

typedef NS_ENUM(NSUInteger, NavigationItemPosition) {
    NavigationItemPositionRight = 1,      /* 右边位置 */
    NavigationItemPositionLeft,           /* 左边位置 */
    NavigationItemPositionCenter          /* 中间位置 */
};

@implementation NavigatorModuleOC

@synthesize weexInstance;

WX_EXPORT_METHOD(@selector(disableGestureBack:))
//WX_EXPORT_METHOD(@selector(barHidden:))
WX_EXPORT_METHOD(@selector(setRightItems:callback:))
WX_EXPORT_METHOD(@selector(setLeftItems:callback:))
WX_EXPORT_METHOD(@selector(setCenterItem:callback:))

@end

