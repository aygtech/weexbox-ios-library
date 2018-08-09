//
//  RouterModel.h
//  WeexBox
//
//  Created by Mario on 2018/8/2.
//  Copyright © 2018年 Ayg. All rights reserved.
//

#import "RouterModel.h"

@implementation RouterModel

- (instancetype)init
{
    if (self = [super init]) {
        _canBack = YES;
        _navShow = YES;
        _gesBack = YES;
    }
    return self;
}

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"vLength" : @"length"};
}



@end
