//
//  BMNative.m
//  BMBaseLibrary
//
//  Created by XHY on 2018/7/2.
//

#import "BMNative.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "BMNotifactionCenter.h"
#import <WeexSDK/WXLog.h>

@protocol BMJSExport <JSExport>

- (void)closePage;
- (void)fireEvent:(NSString *)event :(id)info;

@end

@interface BMNative () <BMJSExport>

@property(nonatomic, weak) UIViewController *vc;

@end

@implementation BMNative

- (instancetype)initWith:(UIViewController *)vc
{
    self = [super init];
    if (self) {
        self.vc = vc;
    }
    return self;
}

- (void)dealloc
{
    WXLogInfo(@"BMNative dealloc");
}

- (void)closePage {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.vc.navigationController popViewControllerAnimated:YES];
        [self.vc dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void)fireEvent:(NSString *)event :(id)info {
    [[BMNotifactionCenter defaultCenter] emit:event info:info];
}

@end
