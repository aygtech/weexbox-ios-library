//
//  WXImgLoaderDefaultImpl.m
//  WeexBox
//
//  Created by Mario on 2018/8/2.
//  Copyright © 2018年 Ayg. All rights reserved.
//

#import "WXImgLoaderDefaultImpl.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define MIN_IMAGE_WIDTH 36
#define MIN_IMAGE_HEIGHT 36

#if OS_OBJECT_USE_OBJC
#undef  WXDispatchQueueRelease
#undef  WXDispatchQueueSetterSementics
#define WXDispatchQueueRelease(q)
#define WXDispatchQueueSetterSementics strong
#else
#undef  WXDispatchQueueRelease
#undef  WXDispatchQueueSetterSementics
#define WXDispatchQueueRelease(q) (dispatch_release(q))
#define WXDispatchQueueSetterSementics assign
#endif

@interface WXImgLoaderDefaultImpl()

@property (WXDispatchQueueSetterSementics, nonatomic) dispatch_queue_t ioQueue;

@end

@implementation WXImgLoaderDefaultImpl

#pragma mark -
#pragma mark WXImgLoaderProtocol

- (id<WXImageOperationProtocol>)downloadImageWithURL:(NSString *)url imageFrame:(CGRect)imageFrame userInfo:(NSDictionary *)userInfo completed:(void(^)(UIImage *image,  NSError *error, BOOL finished))completedBlock
{
    if ([url hasPrefix:@"app://"]) {
        // 加载app内置图片
        NSString *imageName = [url substringFromIndex:5];
        UIImage *image = [UIImage imageNamed:imageName];
        completedBlock(image, nil, YES);
        return nil;
    } else if ([url hasPrefix:@"http"]) {
        // 从网络加载
        return (id<WXImageOperationProtocol>)[[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:url] options:0 progress:nil completed:^(UIImage *image, NSData *imageData, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            completedBlock(image, error, finished);
        }];
    }
    // 从本地加载
    completedBlock([UIImage imageWithContentsOfFile:url], nil, YES);
    return nil;
}

@end
