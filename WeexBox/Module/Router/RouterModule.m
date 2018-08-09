//
//  BMRouterModel.m
//  WeexBox
//
//  Created by Mario on 2018/8/2.
//  Copyright © 2018年 Ayg. All rights reserved.
//

#import "RouterModule.h"
#import "RouterModel.h"
#import <WeexSDK/WXLog.h>
#import <BMBaseLibrary/HYAlertView.h>
#import <BMBaseLibrary/CommonMacro.h>
#import <WeexBox/WeexBox-Swift.h>

#import <BMBaseLibrary/BMDB.h>
#import <YYModel/YYModel.h>

#import <BMBaseLibrary/BMWebViewRouterModel.h>
#import <BMBaseLibrary/BMWebViewController.h>

@implementation RouterModule

@synthesize weexInstance;

WX_EXPORT_METHOD(@selector(open:callback:))
WX_EXPORT_METHOD(@selector(getParams:))
WX_EXPORT_METHOD(@selector(back:callback:))
WX_EXPORT_METHOD(@selector(refreshWeex))
WX_EXPORT_METHOD(@selector(toWebView:))
WX_EXPORT_METHOD(@selector(callPhone:))
WX_EXPORT_METHOD(@selector(openBrowser:))

- (void)open:(NSDictionary *)info callback:(WXModuleKeepAliveCallback)callback
{
    /* 解析info */
    RouterModel *routerModel = [RouterModel yy_modelWithJSON:info];
    
    if (callback)  routerModel.backCallback = callback;
    
    [self openViewControllerWithRouterModel:routerModel weexInstance:weexInstance];
    
}

- (void)getParams:(WXModuleKeepAliveCallback)callback
{
    if (callback) {
        WBWeexViewController *currentVc = (WBWeexViewController *)weexInstance.viewController;
        id params = currentVc.routerModel.params ?: @"";
        callback(params, NO);
    }
}

- (void)back:(NSDictionary *)info callback:(WXModuleKeepAliveCallback)callback
{
    /* 解析info */
    RouterModel *routerModel = [RouterModel yy_modelWithJSON:info];
    [self backVcWithRouterModel:routerModel weexInstance:weexInstance];
}

/** 刷新当前weexInstance */
- (void)refreshWeex
{
    [(WBWeexViewController *)weexInstance.viewController refreshWeex];
}

/** 打开app内置webview */
- (void)toWebView:(NSDictionary *)info
{
    BMWebViewRouterModel *model = [BMWebViewRouterModel yy_modelWithJSON:info];
    [self toWebViewWithRouterInfo:model];
}

/** 使用iOS系统自带浏览器打开 url */
- (void)openBrowser:(NSString *)url
{
    NSURL *openUrl = [NSURL URLWithString:url];
    [[UIApplication sharedApplication] openURL:openUrl];
}

/** 拨打电话 */
- (void)callPhone:(NSDictionary *)info
{
    if (!info[@"phone"]) {
        WXLogError(@"电话号码错误");
        return;
    }
    
    /* ios10 以后会弹系统弹窗 */
    if (K_SYSTEM_VERSION > 10.2) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",info[@"phone"]]]];
    } else {
        HYAlertView *alert = [HYAlertView configWithTitle:nil message:info[@"phone"] cancelButtonTitle:@"取消" otherButtonTitle:@"呼叫" clickedButtonAtIndexBlock:^(NSInteger index) {
            if (index == 1) [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",info[@"phone"]]]];
        }];
        [alert show];
    }
}

- (void)openViewControllerWithRouterModel:(RouterModel *)routerModel weexInstance:(WXSDKInstance *)weexInstance
{
    if (!routerModel.url || !routerModel.url.length) {
        
        WXLogError(@"Error： url 为空");
        
        return;
    }
    
    [self _openViewControllerWithRouterModel:routerModel weexInstance:weexInstance];
}

- (void)_openViewControllerWithRouterModel:(RouterModel *)routerModel weexInstance:(WXSDKInstance *)weexInstance
{
    /* 初始化控制器 */
    WBWeexViewController *controller = [[WBWeexViewController alloc] init];
    controller.url = [UpdateManager getFullUrlWithFile:routerModel.url];
    controller.routerModel = routerModel;
    controller.hidesBottomBarWhenPushed = YES;
    
    /* 页面展现方式 */
    if (!routerModel.type || [routerModel.type isEqualToString:K_ANIMATE_PUSH])
    {
        [weexInstance.viewController.navigationController pushViewController:controller animated:YES];
    }
    else if ([routerModel.type isEqualToString:K_ANIMATE_PRESENT])
    {
        WBNavigationController *navc = [[WBNavigationController alloc] initWithRootViewController:controller];
        [weexInstance.viewController presentViewController:navc animated:YES completion:nil];
    }
    else {
        WXLogError(@" 【JS ERROR】 animateType 拼写错误：%@",routerModel.type);
    }
}

- (void)backVcWithRouterModel:(RouterModel *)routerModel weexInstance:(WXSDKInstance *)weexInstance
{
    if ([routerModel.type isEqualToString:K_ANIMATE_PRESENT]) {
        [weexInstance.viewController dismissViewControllerAnimated:YES completion:nil];
    } else {
        if (routerModel.vLength == 1) {
            [weexInstance.viewController.navigationController popViewControllerAnimated:YES];
            return;
        }
        
        UINavigationController *nav = weexInstance.viewController.navigationController;
        if (nav.viewControllers.count - 1 <= routerModel.vLength) {
            [weexInstance.viewController.navigationController popToRootViewControllerAnimated:YES];
            return;
        }
        
        UIViewController *disVc = [nav.viewControllers objectAtIndex:nav.viewControllers.count - 1 - routerModel.vLength];
        if (disVc) [weexInstance.viewController.navigationController popToViewController:disVc animated:YES];
    }
}

- (void)toWebViewWithRouterInfo:(BMWebViewRouterModel *)routerInfo
{
    BMWebViewController *webView = [[BMWebViewController alloc] initWithRouterModel:routerInfo];
    webView.hidesBottomBarWhenPushed = YES;
    [weexInstance.viewController.navigationController pushViewController:webView animated:YES];
}

@end
