//
//  NavigatorModule.h
//  WeexBox
//
//  Created by Mario on 2018/8/9.
//  Copyright © 2018年 Ayg. All rights reserved.
//

#import <WeexBox/BaseModule.h>

@interface NavigatorModuleOC: BaseModule

// 右边按钮点击回调
@property (nonatomic, strong, nonnull) WXModuleKeepAliveCallback rightItemsCallback;
// 左边按钮点击回调
@property (nonatomic, strong, nonnull) WXModuleKeepAliveCallback leftItemsCallback;
// 中间按钮点击回调
@property (nonatomic, strong, nonnull) WXModuleKeepAliveCallback centerItemCallback;

@end


