//
//  Log.h
//  WeexBox
//
//  Created by Mario on 2018/8/2.
//  Copyright © 2018年 Ayg. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 日志
 */
@interface Log : NSObject

+ (void)d:(NSString *)message;
+ (void)e:(NSString *)message;

@end
