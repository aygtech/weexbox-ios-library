//
//  Log.m
//  WeexBox
//
//  Created by Mario on 2018/8/2.
//  Copyright © 2018年 Ayg. All rights reserved.
//

#import "Log.h"
@import WeexSDK;

@implementation Log

+ (void)d:(NSString *)message {
    WXLogDebug(@"%@", message);
}

+ (void)e:(NSString *)message {
    WXLogError(@"%@", message);
}

@end
