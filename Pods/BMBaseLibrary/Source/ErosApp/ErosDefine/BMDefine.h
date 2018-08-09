//
//  BMDefine.h
//  WeexDemo
//
//  Created by XHY on 2017/1/10.
//  Copyright © 2017年 taobao. All rights reserved.
//

#ifndef BMDefine_h
#define BMDefine_h

/**--------------------------------- 本地资源目录 -------------------------------------------------**/
#define K_DOCUMENT_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define K_LIBRARY_PATH [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0]

/* 本地的bundlejs目录 */
#define K_JS_BUNDLE_PATH [K_LIBRARY_PATH stringByAppendingPathComponent:@"Bundlejs"]

/**----------------------------- 字体大小key ------------------------------------*/
#define K_CHANGE_FONT_SIZE_NOTIFICATION     @"change_font_size"
#define K_FONT_SIZE_KEY                     @"font_size"
#define K_FONT_SIZE_NORM                    @"NORM"
#define K_FONT_SIZE_BIG                     @"BIG"
#define k_FONT_SIZE_EXTRALARGE              @"EXTRALARGE"
// 字体方法倍数
#define K_FontSizeBig_Scale 1.15
#define K_FontSizeExtralarge_Scale 1.3

/**----------------------------- BMNotification ------------------------------------*/
#define K_BMAppReStartNotification          @"BMAppReStartNotification"
#define K_BMTabbarChangeIndex               @"BMTabbarChangeIndex"

/**----------------------------- key ------------------------------------*/
#define K_HomePagePath @"HomePagePathKey"
#define K_BMTabbarInfo @"BMTabbarInfo"
#define BM_LOCAL @"bmlocal"

#endif /* BMDefine_h */
