//
//  WXDevPlugin.m
//  WeexBox
//
//  Created by Mario on 2018/8/27.
//  Copyright © 2018年 Ayg. All rights reserved.
//

#import "WXDevPlugin.h"
#import <ATSDK/ATPluginProtocol.h>

@interface WXDevPlugin()<ATPluginProtocol>

@end

@implementation WXDevPlugin

- (void)pluginDidLoadWithArgs:(NSArray *)args {
    
}

- (void)pluginDidUnload {
    
}

- (void)pluginWillClose {
    
}

- (void)pluginWillOpenInContainer:(UIViewController *)container withArg:(NSArray *)args {

}

- (CGRect)wantReactArea {
    return CGRectZero;
}

@end