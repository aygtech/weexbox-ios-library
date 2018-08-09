//
//  BMToolsModule.m
//  BM-JYT
//
//  Created by XHY on 2017/4/17.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "BMToolsModule.h"
#import "WatermarkView.h"
#import <WeexSDK/WXUtility.h>
#import "BMScanQRViewController.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>
#import "NSDictionary+Util.h"

@interface BMToolsModule ()

@property (nonatomic, strong) AFNetworkReachabilityManager *reachability;

@end

@implementation BMToolsModule

@synthesize weexInstance;

WX_EXPORT_METHOD(@selector(scan:));
WX_EXPORT_METHOD(@selector(resignKeyboard:));
WX_EXPORT_METHOD(@selector(copyString:callback:));
WX_EXPORT_METHOD(@selector(addWatermark:));
WX_EXPORT_METHOD(@selector(env:));
WX_EXPORT_METHOD_SYNC(@selector(networkStatus));
WX_EXPORT_METHOD(@selector(watchNetworkStatus:));
WX_EXPORT_METHOD(@selector(clearWatchNetworkStatus));

/** 调用扫一扫 */
- (void)scan:(WXModuleCallback)callback
{
    BMScanQRViewController *scanQrVc = [[BMScanQRViewController alloc] init];
    scanQrVc.hidesBottomBarWhenPushed = YES;
    scanQrVc.callback = callback;
    [weexInstance.viewController.navigationController pushViewController:scanQrVc animated:YES];
}

/** 辞退键盘 */
- (void)resignKeyboard:(WXModuleCallback)callback
{
    NSInteger resCode = [[[UIApplication sharedApplication].delegate window] endEditing:YES] ? BMResCodeSuccess : BMResCodeError;
    if (callback) {
        NSDictionary *resDic = [NSDictionary configCallbackDataWithResCode:resCode msg:nil data:nil];
        callback(resDic);
    }
}

/** 复制到剪切板 */
- (void)copyString:(NSString *)info callback:(WXModuleCallback)callback
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = info ?:@"";
    NSDictionary *resDic = [NSDictionary configCallbackDataWithResCode:BMResCodeSuccess msg:@"已复制到剪切板" data:nil];
    callback(resDic);
}

/** 在当前Window 添加文字水印 */
- (void)addWatermark:(NSString *)info
{
    if ([info isKindOfClass:[NSString class]] && info.length) {
        [WatermarkView addWatermarkWithText:info];
    }
}

/** 获取环境信息 */
- (void)env:(WXModuleCallback)callback
{
    NSDictionary *resDic = [NSDictionary configCallbackDataWithResCode:BMResCodeSuccess msg:@"获取环境信息成功" data:[WXUtility getEnvironment]];
    if (callback) {
        callback(resDic);
    }
}

/** 获取网络状态 */
- (NSString *)networkStatus
{
    AFNetworkReachabilityManager *reachability = [AFNetworkReachabilityManager sharedManager];
    switch (reachability.networkReachabilityStatus) {
        case AFNetworkReachabilityStatusNotReachable:
            return @"NOT_REACHABLE";
        break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            return @"WIFI";
        break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            return @"3G/4G";
        break;
        default:
            return @"UNKNOWN";
        break;
    }
}

/** 监听网络状态 */
- (void)watchNetworkStatus:(WXModuleKeepAliveCallback)callback
{
    self.reachability = [AFNetworkReachabilityManager manager];
    [self.reachability startMonitoring];
    [self.reachability setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        NSString *networkStatus = @"";
        
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                networkStatus = @"NOT_REACHABLE";
            break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                networkStatus = @"WIFI";
            break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                networkStatus = @"3G/4G";
            break;
            default:
                networkStatus = @"UNKNOWN";
            break;
        }
        
        NSDictionary *resData = [NSDictionary configCallbackDataWithResCode:BMResCodeSuccess msg:nil data:networkStatus];
        if (callback)
        {
            callback(resData,YES);
        }
    }];
}

/** 清楚网络监听 */
- (void)clearWatchNetworkStatus
{
    [self.reachability stopMonitoring];
    self.reachability = nil;
}

@end
