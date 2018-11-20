//
//  ModalModule.m
//  WeexBox
//
//  Created by Mario on 2018/8/18.
//  Copyright © 2018年 Ayg. All rights reserved.
//

#import "ModalModule.h"

#pragma clang diagnostic ignored "-Wundeclared-selector"
@implementation ModalModuleOC

WX_EXPORT_METHOD(@selector(alert:callback:))
WX_EXPORT_METHOD(@selector(confirm:callback:))
WX_EXPORT_METHOD(@selector(prompt:callback:))
WX_EXPORT_METHOD(@selector(actionSheet:callback:))
WX_EXPORT_METHOD(@selector(showToast:))
WX_EXPORT_METHOD(@selector(showLoading:))
WX_EXPORT_METHOD(@selector(dismiss))

@end
#pragma clang diagnostic pop
