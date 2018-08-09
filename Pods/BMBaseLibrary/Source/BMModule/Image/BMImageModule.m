//
//  BMImageModule.m
//  BMBaseLibrary
//
//  Created by XHY on 2017/12/29.
//

#import "BMImageModule.h"

#import <SDWebImage/SDImageCache.h>
#import <PhotoBrowser/PBViewController.h>
#import <objc/runtime.h>
#import <SDWebImage/UIImageView+WebCache.h>

#import "BMImageManager.h"

#import "BMUploadImageModel.h"
#import <YYModel/YYModel.h>

#import <TZImagePickerController/TZImagePickerController.h>
#import "NSDictionary+Util.h"
#import "BMDefine.h"

static NSString * indexKey = @"index";
static NSString * imagesKey = @"images";
static NSString * localKey = @"local";
static NSString * networkKey = @"network";
static NSString * pathKey = @"path";

@interface BMImageModule () <PBViewControllerDelegate,PBViewControllerDataSource>
{
    PBViewController * _photoBrowser;
}

@property (nonatomic,strong)NSMutableArray * images;

@end

@implementation BMImageModule
@synthesize weexInstance;

WX_EXPORT_METHOD(@selector(camera::))
WX_EXPORT_METHOD(@selector(pick::))
WX_EXPORT_METHOD(@selector(uploadImage::))
WX_EXPORT_METHOD(@selector(preview::))
WX_EXPORT_METHOD(@selector(scanImage::))


/** 拍照 */
- (void)camera:(NSDictionary *)info :(WXModuleCallback)callback
{
    BMUploadImageModel *model = [BMUploadImageModel yy_modelWithJSON:info];
    [BMImageManager camera:model weexInstance:weexInstance callback:callback];
}

/** 从相册选择图片最多9张 */
- (void)pick:(NSDictionary *)info :(WXModuleCallback)callback
{
    BMUploadImageModel *model = [BMUploadImageModel yy_modelWithJSON:info];
    [BMImageManager pick:model weexInstance:weexInstance callback:callback];
}

/** 可选择拍照或者从相册选择图片上传至服务器 */
- (void)uploadImage:(NSDictionary *)info :(WXModuleCallback)callback
{
    BMUploadImageModel *model = [BMUploadImageModel yy_modelWithJSON:info];
    [BMImageManager uploadImageWithInfo:model weexInstance:weexInstance callback:callback];
}

/** 识别图片二维码 */
- (void)scanImage:(NSDictionary *)info :(WXModuleCallback)callback
{
    if ([info isKindOfClass:[NSDictionary class]]) {

        NSString *path = [(NSDictionary*)info objectForKey:pathKey];

        UIImage *image = [UIImage imageWithContentsOfFile:path];

        //识别二维码
        CIImage *ciImage = [[CIImage alloc] initWithCGImage:image.CGImage options:nil];
        CIContext *ciContext = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(YES)}]; // 软件渲染
        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:ciContext options:@{CIDetectorAccuracy : CIDetectorAccuracyHigh}];// 二维码识别
        NSArray *features = [detector featuresInImage:ciImage];

        CIQRCodeFeature *feature = [features firstObject];

        if (callback) {
            NSDictionary *resultData = [NSDictionary configCallbackDataWithResCode:BMResCodeSuccess msg:nil data:feature.messageString];
            callback(resultData);
        }
    }
}

/** 预览图片 */
- (void)preview:(NSDictionary *)info :(WXModuleCallback)callback
{
    if ([info isKindOfClass:[NSDictionary class]]) {
        NSArray * images = [(NSDictionary*)info objectForKey:imagesKey];
        NSNumber * index = [(NSDictionary*)info objectForKey:indexKey];
    
        NSMutableArray * imagsArray = [[NSMutableArray alloc] initWithCapacity:0];

        if ([images isKindOfClass:[NSArray class]]) {
            for (int i = 0; i < images.count; i++) {
                NSString * url = [images objectAtIndex:i];
                if (nil != url) {
                    [imagsArray addObject:url];
                }
            }
            
            if (nil != self.images) {
                [self.images removeAllObjects];
                self.images = nil;
            }
            self.images = [[NSMutableArray alloc] initWithArray:imagsArray];
            
            if (nil != _photoBrowser) {
                _photoBrowser = nil;
            }
            
            _photoBrowser = [PBViewController new];
            _photoBrowser.pb_dataSource = self;
            _photoBrowser.pb_delegate = self;
            _photoBrowser.pb_startPage = [index integerValue];
            
            [weexInstance.viewController presentViewController:_photoBrowser animated:YES completion:^{
                if (callback) {
                    callback([NSDictionary dictionary]);
                }
            }];
            
        }
    }
}

#pragma mark - PBViewControllerDataSource

- (NSInteger)numberOfPagesInViewController:(PBViewController *)viewController {
    return self.images.count;
}

- (void)viewController:(PBViewController *)viewController presentImageView:(UIImageView *)imageView forPageAtIndex:(NSInteger)index progressHandler:(void (^)(NSInteger, NSInteger))progressHandler {
    
    NSString *url = self.images[index]?:@"";
    
    NSURL *imgUrl = [NSURL URLWithString:url];
    
    if (!imgUrl) {
        WXLogError(@"image url error: %@",url);
        return;
    }
    
    if (![url hasPrefix:@"http"])
    {
        NSFileManager *fm = [NSFileManager defaultManager];
        if ([fm fileExistsAtPath:url]) {
            UIImage *image = [UIImage imageWithContentsOfFile:url];
            imageView.image = image;
        } else {
            WXLogError(@"预览图片失败：%@",url);
        }
        return;
    }
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:url]
                 placeholderImage:nil
                          options:SDWebImageRetryFailed | SDWebImageAllowInvalidSSLCertificates
                         progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL *url) {
                             if (progressHandler)
                             {
                                 progressHandler(receivedSize,expectedSize);
                             }
                         } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                             
                         }];
}

- (UIView *)thumbViewForPageAtIndex:(NSInteger)index {
    return nil;
}

#pragma mark - PBViewControllerDelegate

- (void)viewController:(PBViewController *)viewController didSingleTapedPageAtIndex:(NSInteger)index presentedImage:(UIImage *)presentedImage {
    [_photoBrowser dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewController:(PBViewController *)viewController didLongPressedPageAtIndex:(NSInteger)index presentedImage:(UIImage *)presentedImage {
    NSLog(@"didLongPressedPageAtIndex: %@", @(index));
}

@end
