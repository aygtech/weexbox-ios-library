//
//  DDWriteFileSupport.m
//  ResultContained
//
//  Created by 李胜书 on 15/8/17.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//


/**
 1:Documents：应用中用户数据可以放在这里，iTunes备份和恢复的时候会包括此目录
 2:tmp：存放临时文件，iTunes不会备份和恢复此目录，此目录下文件可能会在应用退出后删除
 3:Library/Caches：存放缓存文件，iTunes不会备份此目录，此目录下文件不会在应用退出删除
 */


#import "DDWriteFileSupport.h"
#import <SDWebImage/SDImageCache.h>

@interface DDWriteFileSupport()

@property (nonatomic,strong) NSCache *fileCache;

@end;

@implementation DDWriteFileSupport

+ (DDWriteFileSupport *) ShareInstance {
    static DDWriteFileSupport *sharedWriteFileInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedWriteFileInstance = [[self alloc] init];
    });
    return sharedWriteFileInstance;
}
#pragma mark - Main Methods
- (BOOL)directWriteFile:(NSString *)path
                   Data:(id)data {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL res = NO;
    if ([data isKindOfClass:[NSDictionary class]] || [data isKindOfClass:[NSArray class]]) {
        NSData *myData = [NSKeyedArchiver archivedDataWithRootObject:data];
        res = [fileManager createFileAtPath:path
                                   contents:myData
                                 attributes:nil];
    }else if ([data isKindOfClass:[UIImage class]]) {
        NSData *myData = [self transformPNG:data];
        res = [fileManager createFileAtPath:path
                                   contents:myData
                                 attributes:nil];
    }else {
        res = [fileManager createFileAtPath:path
                                   contents:data
                                 attributes:nil];
    }
    if (res) {
        if (!_fileCache) {
            _fileCache = [[NSCache alloc]init];
        }
        if (path) {
            [_fileCache setObject:data forKey:path];
        }
    }
    return res;
}

- (BOOL)directWriteFile:(NSString *)path
                   Data:(UIImage *)data
              ImageType:(DDImgType)imgType {
    NSData *imgData = [self getImageData:data
                               DDImgType:imgType];
    return [self directWriteFile:path
                            Data:imgData];
}

- (BOOL)writeFile:(NSString *)path
             Data:(id)data {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL res = NO;
    if(![fileManager fileExistsAtPath:path]) {
        if ([data isKindOfClass:[NSDictionary class]] || [data isKindOfClass:[NSArray class]]) {
            NSData *myData = [NSKeyedArchiver archivedDataWithRootObject:data];
            res = [fileManager createFileAtPath:path
                                       contents:myData
                                     attributes:nil];
        }else if ([data isKindOfClass:[UIImage class]]) {
            NSData *myData = [self transformPNG:data];
            res = [fileManager createFileAtPath:path
                                       contents:myData
                                     attributes:nil];
        }else {
            res = [fileManager createFileAtPath:path
                                       contents:data
                                     attributes:nil];
        }
    }
    if (res) {
        if (!_fileCache) {
            _fileCache = [[NSCache alloc]init];
        }
        if (path) {
            [_fileCache setObject:data forKey:path];
        }
    }
    return res;
}

- (BOOL)writeFile:(NSString *)path
             Data:(id)data
        ImageType:(DDImgType)imgType {
    NSData *imgData = [self getImageData:data
                               DDImgType:imgType];
    return [self writeFile:path
                      Data:imgData];
}

- (BOOL)directWriteFileType:(NSString *)path
                       Data:(id)data
                      Field:(DDFileField)field {
    NSString *finalPath = [self getAbPath:path
                                FileField:field];
    return [self directWriteFile:finalPath
                            Data:data];
}

- (BOOL)directWriteFileType:(NSString *)path
                       Data:(id)data
                  ImageType:(DDImgType)imgType
                      Field:(DDFileField)field {
    NSData *imgData = [self getImageData:data
                               DDImgType:imgType];
    return [self directWriteFileType:path
                                Data:imgData
                               Field:field];
}

- (BOOL)writeFileType:(NSString *)path
                 Data:(id)data
                Field:(DDFileField)field {
    NSString *finalPath = [self getAbPath:path
                                FileField:field];
    return [self writeFile:finalPath
                      Data:data];
}

- (BOOL)writeFileType:(NSString *)path
                 Data:(id)data
            ImageType:(DDImgType)imgType
                Field:(DDFileField)field {
    NSData *imgData = [self getImageData:data
                               DDImgType:imgType];
    return [self writeFileType:path
                          Data:imgData
                         Field:field];
}

- (BOOL)createDir:(NSString *)dirName
            Filed:(DDFileField)field {
    NSString *finalPath = [self getAbPath:dirName
                                FileField:field];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL res = [fileManager createDirectoryAtPath:finalPath
                      withIntermediateDirectories:YES
                                       attributes:nil
                                            error:nil];
    return res;
}

- (BOOL)removeFile:(NSString *)filePath {
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSError *err;
    BOOL result = NO;
    BOOL bRet = [fileMgr fileExistsAtPath:filePath];
    if (bRet)
        result = [fileMgr removeItemAtPath:filePath
                                     error:&err];
    if (result) {
        if (!_fileCache) {
            _fileCache = [[NSCache alloc]init];
        }
        if (filePath) {
            [_fileCache removeObjectForKey:filePath];
        }
    }
    return result;
}

- (BOOL)removeDirFiles:(NSString *)dirPath {
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSArray *filePaths = [self readDirPath:dirPath];
    __block BOOL result = NO;
    if (filePaths.count > 0) {
        result = YES;
    }
    [filePaths enumerateObjectsUsingBlock:^(NSString *filePath, NSUInteger idx, BOOL * _Nonnull stop) {
        BOOL bRet = [fileMgr fileExistsAtPath:filePath];
        BOOL removeResult = NO;
        NSError *err;
        if (bRet)
            removeResult = [fileMgr removeItemAtPath:filePath
                                               error:&err];
        if (!removeResult) {
            result = NO;
            *stop = YES;
        }
    }];
    return result;
}

- (NSMutableArray *)readDirPath:(NSString *)dirPath {
    __block NSMutableArray *filePaths = [@[] mutableCopy];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:dirPath
                                                         error:&error];
    [fileList enumerateObjectsUsingBlock:^(NSString *path, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *picturePath = [dirPath stringByAppendingPathComponent:path];
        picturePath ? [filePaths addObject:picturePath] : nil;
    }];
    return filePaths;
}

- (NSArray *)readDirNames:(NSString *)dirPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //在这里获取应用程序Documents文件夹里的文件及文件夹列表
    NSError *error = nil;
    NSArray *fileList = [[NSArray alloc] init];
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    fileList = [fileManager contentsOfDirectoryAtPath:dirPath
                                                error:&error];
    return fileList;
}

- (id)readFile:(NSString *)filePath
      FileType:(DDFileType)type {
    BOOL isExist;
    if (!_fileCache) {
        _fileCache = [[NSCache alloc]init];
    }
    if ([_fileCache objectForKey:filePath]) {
        return [_fileCache objectForKey:filePath];
    }else {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        isExist = [fileManager fileExistsAtPath:filePath];
        if (isExist) {
            NSData *tempData = [NSData dataWithContentsOfFile:filePath];
            switch (type) {
                case Image: {
                    UIImage *fileImg = [UIImage imageWithData:tempData];
                    [_fileCache setObject:fileImg forKey:filePath];
                    return fileImg;
                }
                case Array: {
                    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:tempData];
                    [_fileCache setObject:array forKey:filePath];
                    return array;
                }
                case Dictionary: {
                    NSDictionary *dictionary = [NSKeyedUnarchiver unarchiveObjectWithData:tempData];
                    [_fileCache setObject:dictionary forKey:filePath];
                    return dictionary;
                }
                case Data: {
                    [_fileCache setObject:tempData forKey:filePath];
                    return tempData;
                }
                default: {
                    [_fileCache setObject:tempData forKey:filePath];
                    return tempData;
                }
            }
        }else {
            return nil;
        }
    }
}

- (id)readFile:(NSString *)filePath
      FileType:(DDFileType)type
     FileField:(DDFileField)field {
    NSString *finalPath = [self getAbPath:filePath
                                FileField:field];
    return [self readFile:finalPath
                 FileType:type
                FileField:field];
}

- (void)flushCache {
    [_fileCache removeAllObjects];
}

- (float)countFileSize:(NSString *)filePath
          FileSizeType:(DDSizeType)type {
    NSFileManager *manager = [NSFileManager defaultManager];
    float size = 0;
    if ([manager fileExistsAtPath:filePath]) {
        size = [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    switch (type) {
        case KB:
            size = size/1024.0;
            break;
        case MB:
            size = size/(1024.0*1024.0);
            break;
        case GB:
            size = size/(1024.0*1024.0*1024.0);
            break;
        case TB:
            size = size/(1024.0*1024.0*1024.0*1024.0);
            break;
        default:
            size = size/1024.0;
            break;
    }
    return size;
}

- (float)countFileSize:(NSString *)filePath
                 Field:(DDFileField)field
          FileSizeType:(DDSizeType)type {
    NSString *finalPath = [self getAbPath:filePath
                                FileField:field];
    return [self countFileSize:finalPath
                  FileSizeType:type];
}

- (float)countDirSize:(NSString *)dirPath
         FileSizeType:(DDSizeType)type {
    __block float size = 0;
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:dirPath]) {
        NSArray *dirArr = [self readDirPath:dirPath];
        [dirArr enumerateObjectsUsingBlock:^(NSString *file, NSUInteger idx, BOOL * _Nonnull stop) {
            size += [self countFileSize:file
                           FileSizeType:type];
        }];
    }
    return size;
}

- (float)countDirSize:(NSString *)dirPath
                Field:(DDFileField)field
         FileSizeType:(DDSizeType)type {
    NSString *finalPath = [self getAbPath:dirPath
                                FileField:field];
    return [self countDirSize:finalPath
                 FileSizeType:type];
}
#pragma mark - Support Methods
/**
 通过选择的相对位置获取绝对路径
 
 @param filePath 相对路径
 @param field 选择位置
 @return 返回绝对路径
 */
- (NSString *)getAbPath:(NSString *)filePath
              FileField:(DDFileField)field {
    ///选择的路径位置
    NSString *typePath;
    switch (field) {
        case Documents: {
            typePath = [self getDocPath];
        }
            break;
        case LibraryCaches: {
            typePath = [self getCachePath];
        }
            break;
        case Temp: {
            typePath = [self getTempPath];
        }
            break;
        default:
            break;
    }
    NSString *finalPath = [typePath stringByAppendingPathComponent:filePath];
    return finalPath;
}

- (NSData *)getImageData:(UIImage *)image
               DDImgType:(DDImgType)imgType {
    NSData *imgData;
    switch (imgType) {
        case PNG:
            imgData = [self transformPNG:image];
            break;
        case JPEG:
            imgData = [self transformJEPG:image];
            break;
        default:
            imgData = [self transformPNG:image];
            break;
    }
    return imgData;
}
/**
 剪切图片为目标size
 
 @param targetSize 目标size
 @param sourceImage 源图片
 @return 返回剪切后的图片
 */
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize
                                    SourceImage:(UIImage *)sourceImage {
    UIGraphicsBeginImageContext(targetSize);
    [sourceImage drawInRect:CGRectMake(0, 0, targetSize.width, targetSize.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
///PNG to Data
- (NSData *)transformPNG:(UIImage *)image {
    NSData *insertPngImageData = UIImagePNGRepresentation(image);
    return insertPngImageData;
}
///JEPG to Data
- (NSData *)transformJEPG:(UIImage *)image {
    NSData *insertJepgImageData = UIImageJPEGRepresentation(image,1.0);
    return insertJepgImageData;
}
///获取documents路径
- (NSString *)getDocPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}
///获取Library目录
- (NSString *)getLibPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryDirectory = [paths objectAtIndex:0];
    return libraryDirectory;
}
///获取Cache目录
- (NSString *)getCachePath {
    NSArray *cacPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [cacPath objectAtIndex:0];
    return cachePath;
}
///获取Tmp目录
- (NSString *)getTempPath {
    NSString *tmpDirectory = NSTemporaryDirectory();
    return tmpDirectory;
}

@end
