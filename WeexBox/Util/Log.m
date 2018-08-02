//
//  Log.m
//  WeexBox
//
//  Created by Mario on 2018/8/2.
//  Copyright © 2018年 Ayg. All rights reserved.
//

#import "Log.h"
#import <WeexSDK/WeexSDK.h>

@implementation Log

+ (void)debug:(NSString *)message {
    WXLogDebug(@"%@", message);
}

+ (void)error:(NSString *)message {
    WXLogError(@"%@", message);
}

@end
