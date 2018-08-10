//
//  BMConfigManager.m
//  WeexDemo
//
//  Created by XHY on 2017/1/10.
//  Copyright © 2017年 taobao. All rights reserved.
//

#import "BMConfigManager.h"
#import "CommonMacro.h"
#import "BMDefine.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <SDWebImage/SDImageCache.h>
#import <SDWebImage/SDWebImageDownloader.h>

#import "BMDB.h"

#import "WXImgLoaderDefaultImpl.h"
#import "WXConfigCenterDefaultImpl.h"

#import "BMMaskComponent.h"
#import "BMTextComponent.h"
#import "BMPopupComponent.h"
#import "BMCalendarComponent.h"
#import "BMSpanComponent.h"
#import "BMChartComponent.h"

#import "BMAxiosNetworkModule.h"
#import "BMGeolocationModule.h"
#import "BMModalModule.h"
#import "BMCameraModule.h"
#import "BMStorageModule.h"
#import "BMToolsModule.h"
#import "BMNavigatorModule.h"
#import "BMAuthorLoginModule.h"
#import "BMCommunicationModule.h"
#import "BMImageModule.h"
#import "BMWebSocketModule.h"

#import <WeexSDK/WeexSDK.h>
#import <WeexSDK/WXUtility.h>

#import "BMEventsModule.h"
#import "BMBrowserImgModule.h"
#import "BMRichTextComponent.h"

#import <AFNetworking/AFNetworkReachabilityManager.h>
#import <ATSDK/ATManager.h>

@implementation BMConfigManager

- (NSDictionary *)envInfo
{
    if (!_envInfo) {
        _envInfo = [WXUtility getEnvironment];
    }
    return _envInfo;
}

#pragma mark - Public Func

+ (instancetype)shareInstance
{
    static BMConfigManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[BMConfigManager alloc] init];
    });
    return _instance;
}
+ (void)configDefaultData
{
    /* 启动网络变化监控 */
    AFNetworkReachabilityManager *reachability = [AFNetworkReachabilityManager sharedManager];
    [reachability startMonitoring];
    
    /** 初始化Weex */
    [BMConfigManager initWeexSDK];
    
    /** 设置sdimage减小内存占用 */
    [[SDWebImageDownloader sharedDownloader] setShouldDecompressImages:NO];
    
    /** 初始化数据库 */
    [[BMDB DB] configDB];
    
    /** 设置 HUD */
    [BMConfigManager configProgressHUD];

    /* 监听截屏事件 */
//    [[BMScreenshotEventManager shareInstance] monitorScreenshotEvent];
    
}

+ (void)configProgressHUD
{
    [SVProgressHUD setBackgroundColor:[K_BLACK_COLOR colorWithAlphaComponent:0.70f]];
    [SVProgressHUD setForegroundColor:K_WHITE_COLOR];
    [SVProgressHUD setCornerRadius:4.0];
    [SVProgressHUD setMinimumDismissTimeInterval:1.5];
}

+ (void)registerBmHandlers
{
    [WXSDKEngine registerHandler:[WXImgLoaderDefaultImpl new] withProtocol:@protocol(WXImgLoaderProtocol)];
    [WXSDKEngine registerHandler:[WXConfigCenterDefaultImpl new] withProtocol:@protocol(WXConfigCenterProtocol)];
}

+ (void)registerBmComponents
{
    
    NSDictionary *components = @{
                                @"wbc-mask":          NSStringFromClass([BMMaskComponent class]),
                                @"wbc-pop":           NSStringFromClass([BMPopupComponent class]),
                                @"wbc-text":          NSStringFromClass([BMTextComponent class]),
                                @"wbc-richtext":      NSStringFromClass([BMRichTextComponent class]),
                                @"wbc-calendar":      NSStringFromClass([BMCalendarComponent class]),
                                @"wbc-span":          NSStringFromClass([BMSpanComponent class]),
                                @"wbc-chart":         NSStringFromClass([BMChartComponent class])
                                };
    for (NSString *componentName in components) {
        [WXSDKEngine registerComponent:componentName withClass:NSClassFromString([components valueForKey:componentName])];
    }
}

+ (void)registerBmModules
{
    NSDictionary *modules = @{
                              @"wbm-axios":           NSStringFromClass([BMAxiosNetworkModule class]),
                              @"wbm-geolocation":     NSStringFromClass([BMGeolocationModule class]),
                              @"wbm-modal":           NSStringFromClass([BMModalModule class]),
                              @"wbm-camera":          NSStringFromClass([BMCameraModule class]),
                              @"wbm-storage":         NSStringFromClass([BMStorageModule class]),
                              @"wbm-events":          NSStringFromClass([BMEventsModule class]),
                              @"wbm-browserImg":      NSStringFromClass([BMBrowserImgModule class]),
                              @"wbm-tool":            NSStringFromClass([BMToolsModule class]),
                              @"wbm-auth":            NSStringFromClass([BMAuthorLoginModule class]),
                              @"wbm-navigator":       NSStringFromClass([BMNavigatorModule class]),
                              @"wbm-communication":   NSStringFromClass([BMCommunicationModule class]),
                              @"wbm-image":           NSStringFromClass([BMImageModule class]),
                              @"wbm-webSocket":       NSStringFromClass([BMWebSocketModule class])
                              };
    
    for (NSString *moduleName in modules.allKeys) {
        [WXSDKEngine registerModule:moduleName withClass:NSClassFromString([modules valueForKey:moduleName])];
    }
}

+ (void)initWeexSDK
{
    [WXSDKEngine initSDKEnvironment];
    
    [BMConfigManager registerBmHandlers];
    [BMConfigManager registerBmComponents];
    [BMConfigManager registerBmModules];
    
#ifdef DEBUG
    [WXDebugTool setDebug:YES];
    [WXLog setLogLevel:WXLogLevelAll];
    [BMConfigManager atAddPlugin];
#else
    [WXDebugTool setDebug:NO];
    [WXLog setLogLevel:WXLogLevelError];
#endif
}

+ (void)atAddPlugin {
    [[ATManager shareInstance] addPluginWithId:@"weex" andName:@"weex" andIconName:@"../weex" andEntry:@"" andArgs:@[@""]];
    [[ATManager shareInstance] addSubPluginWithParentId:@"weex" andSubId:@"logger" andName:@"logger" andIconName:@"log" andEntry:@"WXATLoggerPlugin" andArgs:@[@""]];
    //    [[ATManager shareInstance] addSubPluginWithParentId:@"weex" andSubId:@"viewHierarchy" andName:@"hierarchy" andIconName:@"log" andEntry:@"WXATViewHierarchyPlugin" andArgs:@[@""]];
    [[ATManager shareInstance] addSubPluginWithParentId:@"weex" andSubId:@"test2" andName:@"test" andIconName:@"at_arr_refresh" andEntry:@"" andArgs:@[]];
    [[ATManager shareInstance] addSubPluginWithParentId:@"weex" andSubId:@"test3" andName:@"test" andIconName:@"at_arr_refresh" andEntry:@"" andArgs:@[]];
    [[ATManager shareInstance] show];
}

- (BOOL)applicationOpenURL:(NSURL *)url
{
    return YES;
}

@end
