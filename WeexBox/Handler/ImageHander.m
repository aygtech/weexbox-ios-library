//
//  ImageHander.m
//  WeexBox
//
//  Created by Mario on 2018/8/2.
//  Copyright © 2018年 Ayg. All rights reserved.
//

#import "ImageHander.h"
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

@interface ImageHander()

@property (WXDispatchQueueSetterSementics, nonatomic) dispatch_queue_t ioQueue;

@end

@implementation ImageHander

#pragma mark -
#pragma mark WXImgLoaderProtocol

- (id<WXImageOperationProtocol>)downloadImageWithURL:(NSString *)url imageFrame:(CGRect)imageFrame userInfo:(NSDictionary *)userInfo completed:(void(^)(UIImage *image,  NSError *error, BOOL finished))completedBlock
{
    if ([url hasPrefix:@"bundle://"]) {
        // 加载app内置图片
        NSString *imageName = [url substringFromIndex:9];
        UIImage *image = [UIImage imageNamed:imageName];
        completedBlock(image, nil, YES);
        return nil;
    }
    //从沙盒加载。
    else if([url hasPrefix:@"file://"]){
        NSString *imagePath = [self getFullPathWithUrl:url];
        completedBlock([UIImage imageWithContentsOfFile:imagePath], nil, YES);
    }
    else if ([url hasPrefix:@"http"]) {
        // 从网络加载
        return (id<WXImageOperationProtocol>)[[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:url] options:0 progress:nil completed:^(UIImage *image, NSData *imageData, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            completedBlock(image, error, finished);
        }];
    }
    return nil;
}
-(NSString *)getFullPathWithUrl:(NSString *)url{
    NSString *tmpDirectory = NSTemporaryDirectory();
    NSArray *urls = [url componentsSeparatedByString:@"file://"];
    if(urls&&urls.count==2){
        NSString *fileName = urls[1];
        if(fileName&&fileName.length>0){
            return [NSString stringWithFormat:@"%@%@",tmpDirectory,fileName];
        }
        return @"";
    }
    return @"";
}

@end
