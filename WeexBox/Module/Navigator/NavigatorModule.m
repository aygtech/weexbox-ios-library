//
//  NavigatorModule.m
//  WeexBox
//
//  Created by Mario on 2018/8/9.
//  Copyright © 2018年 Ayg. All rights reserved.
//

#import "NavigatorModule.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <RTRootNavigationController/RTRootNavigationController.h>

typedef NS_ENUM(NSUInteger, NavigationItemPosition) {
    NavigationItemPositionRight = 1,      /* 右边位置 */
    NavigationItemPositionLeft,           /* 左边位置 */
    NavigationItemPositionCenter          /* 中间位置 */
};

@interface NavigatorModule ()

@property (nonatomic, strong) WXModuleKeepAliveCallback rightItemsCallback;    /* 导航栏右边按钮点击回调方法 */
@property (nonatomic, strong) WXModuleKeepAliveCallback leftItemsCallback;     /* 导航栏左边按钮点击回调方法 */
@property (nonatomic, strong) WXModuleKeepAliveCallback centerItemCallback;   /* 中间的视图点击回调 */

@end

@implementation NavigatorModule

@synthesize weexInstance;

WX_EXPORT_METHOD(@selector(disableGestureBack:))
WX_EXPORT_METHOD(@selector(barHidden:))
WX_EXPORT_METHOD(@selector(setRightItems:callback:))
WX_EXPORT_METHOD(@selector(setLeftItems:callback:))
WX_EXPORT_METHOD(@selector(setCenterItem:callback:))
//WX_EXPORT_METHOD(@selector(statusBarHidden:))

#pragma mark - Public Method

// 禁用返回手势
- (void)disableGestureBack:(BOOL)disable {
    weexInstance.viewController.rt_disableInteractivePop = disable;
}

// 隐藏导航栏
- (void)barHidden:(BOOL)hidden {
    weexInstance.viewController.navigationController.navigationBarHidden = hidden;
}

/* 设置导航栏右侧按钮 */
- (void)setRightItems:(NSArray *)items callback:(WXModuleKeepAliveCallback)callback
{
    self.rightItemsCallback = callback;
    NSArray *barButtonItems = [self createBarButtons:items position:NavigationItemPositionRight];
    weexInstance.viewController.navigationItem.rightBarButtonItems = barButtonItems;
}

/* 设置导航栏左侧按钮 */
- (void)setLeftItems:(NSArray *)items callback:(WXModuleKeepAliveCallback)callback
{
    self.leftItemsCallback = callback;
    NSArray *barButtonItems = [self createBarButtons:items position:NavigationItemPositionLeft];
    weexInstance.viewController.navigationItem.leftBarButtonItems = barButtonItems;
}

/* 设置导航栏中间按钮 */
- (void)setCenterItem:(NSDictionary *)info callback:(WXModuleKeepAliveCallback)callback
{
    self.centerItemCallback = callback;
    if(callback) {
        UIBarButtonItem *barButtonItem = [self createBarButton:info position:NavigationItemPositionCenter tag:0];
        weexInstance.viewController.navigationItem.titleView = barButtonItem;
    } else {
        weexInstance.viewController.navigationItem.title = info[@"title"];
    }
}

- (NSArray *)createBarButtons:(NSArray *)items position:(NavigationItemPosition)position {
    NSMutableArray *barButtonItems = [[NSMutableArray alloc] init];
    for(int i = 0; i < items.count; i++) {
        NSDictionary *param = items[i];
        [barButtonItems addObject:[self createBarButton:param position:position tag:i]];
    }
    return barButtonItems;
}

- (UIBarButtonItem *)createBarButton:(NSDictionary *)param position:(NavigationItemPosition)position tag:(NSInteger)tag
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = tag;
    switch (position) {
            case NavigationItemPositionRight:
            [button addTarget:self action:@selector(onClickRightBarButton:) forControlEvents:UIControlEventTouchUpInside];
            break;
            case NavigationItemPositionLeft:
            [button addTarget:self action:@selector(onClickLeftBarButton:) forControlEvents:UIControlEventTouchUpInside];
            break;
            case NavigationItemPositionCenter:
            [button addTarget:self action:@selector(onClickCenterBarButtion:) forControlEvents:UIControlEventTouchUpInside];
            break;
        default:
            break;
    }
    
    if (param[@"text"]) {
        NSString *title = param[@"text"];
        
        CGFloat fontWeight = 0;
        if (param[@"fontWeight"]) {
            fontWeight = [WXConvert WXTextWeight:param[@"fontWeight"]];
        }
        
        UIColor *textColor = [UIColor whiteColor];
        if (param[@"textColor"]) {
            textColor = [WXConvert UIColor:param[@"textColor"]];
        }
        
        CGFloat fontSize = 16;
        if (param[@"fontSize"]) {
            fontSize = [param[@"fontSize"] floatValue] / 2.0;
        }
        
        UIFont *textFont = [WXUtility fontWithSize:fontSize textWeight:fontWeight textStyle:WXTextStyleNormal fontFamily:nil scaleFactor:self.weexInstance.pixelScaleFactor];
        
        NSDictionary *attribute = @{NSFontAttributeName: textFont};
        CGSize size = [title boundingRectWithSize:CGSizeMake(110.0f, 30.0f) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        
        button.frame = CGRectMake(0, 0, size.width + 5, size.height);
        button.titleLabel.font = textFont;
        //        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        button.titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        [button setTitleColor:textColor forState:UIControlStateNormal];
        [button setTitleColor:textColor  forState:UIControlStateHighlighted];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateHighlighted];
    }
    else if (param[@"image"]) {
        NSString *icon = param[@"image"];
        
        if (icon) {
            //            button.frame = CGRectMake(0, 0, 50, 15);
            [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:icon] options:0 progress:nil completed:^(UIImage *image, NSData *data, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                
                CGRect rect = button.frame;
                rect.size = image.size;
                button.frame = rect;
                
                [button setBackgroundImage:image forState:UIControlStateNormal];
                [button setBackgroundImage:image forState:UIControlStateHighlighted];
            }];
        }
    }
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

/* 右侧itme响应事件 */
- (void)onClickRightBarButton:(UIButton *)button
{
    if (self.rightItemsCallback) {
        self.rightItemsCallback([NSNumber numberWithInteger:button.tag], YES);
    }
}

/* 左侧item响应事件 */
- (void)onClickLeftBarButton:(UIButton *)button
{
    if (self.leftItemsCallback) {
        self.leftItemsCallback([NSNumber numberWithInteger:button.tag],YES);
    }
}

/* 中间item响应事件 */
- (void)onClickCenterBarButtion:(UIButton *)button
{
    if (self.centerItemCallback) {
        self.centerItemCallback(nil, YES);
    }
}

/** 是否显示状态栏 */
- (void)statusBarHidden:(BOOL)hidden
{
    [[UIApplication sharedApplication] setStatusBarHidden:hidden withAnimation:UIStatusBarAnimationNone];
}
@end

