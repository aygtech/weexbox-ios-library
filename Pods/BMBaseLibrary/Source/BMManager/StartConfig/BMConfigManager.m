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
#import "BMAppConfigModule.h"
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
                                @"wb-mask":          NSStringFromClass([BMMaskComponent class]),
                                @"wb-pop":           NSStringFromClass([BMPopupComponent class]),
                                @"wb-text":          NSStringFromClass([BMTextComponent class]),
                                @"wb-richtext":      NSStringFromClass([BMRichTextComponent class]),
                                @"wb-calendar":      NSStringFromClass([BMCalendarComponent class]),
                                @"wb-span":          NSStringFromClass([BMSpanComponent class]),
                                @"wb-chart":         NSStringFromClass([BMChartComponent class])
                                };
    for (NSString *componentName in components) {
        [WXSDKEngine registerComponent:componentName withClass:NSClassFromString([components valueForKey:componentName])];
    }
}

+ (void)registerBmModules
{
    NSDictionary *modules = @{
                              @"wb-Axios":           NSStringFromClass([BMAxiosNetworkModule class]),
                              @"wb-Geolocation":     NSStringFromClass([BMGeolocationModule class]),
                              @"wb-Modal":           NSStringFromClass([BMModalModule class]),
                              @"wb-Camera":          NSStringFromClass([BMCameraModule class]),
                              @"wb-Storage":         NSStringFromClass([BMStorageModule class]),
                              @"wb-Font":            NSStringFromClass([BMAppConfigModule class]),
                              @"wb-Events":          NSStringFromClass([BMEventsModule class]),
                              @"wb-BrowserImg":      NSStringFromClass([BMBrowserImgModule class]),
                              @"wb-Tool":            NSStringFromClass([BMToolsModule class]),
                              @"wb-Auth":            NSStringFromClass([BMAuthorLoginModule class]),
                              @"wb-Navigator":       NSStringFromClass([BMNavigatorModule class]),
                              @"wb-Communication":   NSStringFromClass([BMCommunicationModule class]),
                              @"wb-Image":           NSStringFromClass([BMImageModule class]),
                              @"wb-WebSocket":       NSStringFromClass([BMWebSocketModule class])
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
