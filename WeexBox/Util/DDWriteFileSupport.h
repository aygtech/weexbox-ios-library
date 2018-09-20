//
//  DDWriteFileSupport.h
//  ResultContained
//
//  Created by 李胜书 on 15/8/17.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

typedef enum {
    ///在documents下
    Documents = 0,
    ///在library/caches下
    LibraryCaches,
    ///在temp下
    Temp
}DDFileField;
typedef enum {
    ///需要返回image
    Image = 0,
    ///需要返回数组
    Array,
    ///需要返回字典
    Dictionary,
    ///需要返回文件流
    Data
}DDFileType;
typedef enum {
    ///需要返回kb大小
    KB = 0,
    ///需要返回mb大小
    MB,
    ///需要返回gb大小
    GB,
    ///需要返回tb大小
    TB
}DDSizeType;
typedef enum {
    ///图片为PNG
    PNG = 0,
    ///图片为JPEG
    JPEG
}DDImgType;

#import <Foundation/Foundation.h>

@interface DDWriteFileSupport : NSObject

/**
 单实例化
 
 @return 返回生成的单实例
 */
+ (DDWriteFileSupport *)ShareInstance;
#pragma mark - 写入
/**
 直接存储data流到本地，绝对路径为path，不管路径上是否已存在文件
 
 @param path 文件路径，需要为绝对路径
 @param data 二进制流，数组或字典，图片，图片默认为png格式，如果需要写jpg图片请使用选择图片type的方法
 @return 返回写入结果
 */
- (BOOL)directWriteFile:(NSString *)path
                   Data:(id)data;
/**
 直接存储图片到本地，绝对路径为path，不管路径上是否已存在文件
 
 @param path 图片路径，需要为绝对路径
 @param data 图片
 @param imgType 图片类型
 @return 返回写入结果
 */
- (BOOL)directWriteFile:(NSString *)path
                   Data:(UIImage *)data
              ImageType:(DDImgType)imgType;
/**
 存储data流到本地，绝对路径为path，路径上如果已存在文件则返回失败
 
 @param path 文件路径，需要为绝对路径
 @param data 二进制流，数组或字典，图片，图片默认为png格式，如果需要写jpg图片请使用选择图片type的方法
 @return 返回写入结果
 */
- (BOOL)writeFile:(NSString *)path
             Data:(id)data;
/**
 存储图片到本地，绝对路径为path，路径上如果已存在文件则返回失败
 
 @param path 文件路径，需要为绝对路径
 @param data 图片
 @param imgType 图片类型
 @return 返回写入结果
 */
- (BOOL)writeFile:(NSString *)path
             Data:(id)data
        ImageType:(DDImgType)imgType;
/**
 直接存储data流到本地，相对路径为path，不管路径上是否已存在文件，可通过参数选择三处位置
 
 @param path 文件相对路径，如果直接给文件名则直接写
 @param data 二进制流，数组或字典，图片，图片默认为png格式，如果需要写jpg图片请使用选择图片type的方法
 @param field 选择type
 @return 返回写入结果
 */
- (BOOL)directWriteFileType:(NSString *)path
                       Data:(id)data
                      Field:(DDFileField)field;
/**
 直接存储图片到本地，相对路径为path，不管路径上是否已存在文件，可通过参数选择三处位置
 
 @param path 文件相对路径，如果直接给文件名则直接写
 @param data 图片
 @param imgType 图片类型
 @param field 选择type
 @return 返回写入结果
 */
- (BOOL)directWriteFileType:(NSString *)path
                       Data:(id)data
                  ImageType:(DDImgType)imgType
                      Field:(DDFileField)field;
/**
 存储data流到本地，相对路径为path，路径上已存在文件则返回失败，可通过参数选择三处位置
 
 @param path 文件相对路径，如果直接给文件名则直接写
 @param data 二进制流，数组或字典
 @param field 选择type
 @return 返回写入结果
 */
- (BOOL)writeFileType:(NSString *)path
                 Data:(id)data
                Field:(DDFileField)field;
/**
 存储图片到本地，相对路径为path，路径上已存在文件则返回失败，可通过参数选择三处位置
 
 @param path 文件相对路径，如果直接给文件名则直接写
 @param data 图片
 @param imgType 图片类型
 @param field 选择type
 @return 返回写入结果
 */
- (BOOL)writeFileType:(NSString *)path
                 Data:(id)data
            ImageType:(DDImgType)imgType
                Field:(DDFileField)field;
/**
 根据filed参数创建文件夹
 
 @param dirName 文件夹名
 @param field 选择的field地址
 @return 返回创建结果
 */
- (BOOL)createDir:(NSString *)dirName
            Filed:(DDFileField)field;
#pragma mark - 删除
/**
 以绝对路径删除单个文件，如果不存在文件也返回NO
 
 @param filePath 文件路径，绝对路径
 @return 删除结果
 */
- (BOOL)removeFile:(NSString *)filePath;
/**
 以绝对路径删除文件夹下所有子文件或文件夹，如果不存在文件夹也返回NO
 
 @param dirPath 文件夹路径，绝对路径
 @return 删除结果
 */
- (BOOL)removeDirFiles:(NSString *)dirPath;
#pragma mark - 读取文件夹下子文件路径或文件名
/**
 返回给定文件夹路径下所有文件或文件夹路径
 
 @param dirPath 给定的文件夹绝对路径
 @return 返回的文件列表数组，数组元素为子文件或子文件夹的绝对路径
 */
- (NSMutableArray *)readDirPath:(NSString *)dirPath;
/**
 读取文件夹下所有文件名。包含文件夹名，
 
 @param dirPath 要读取的文件夹名称
 @return 返回的文件列表数组，数组元素为自文件或自文件夹的名字
 */
- (NSArray *)readDirNames:(NSString *)dirPath;
#pragma mark - 读取文件操作
/**
 读取绝对路径下的文件，不存在则返回NO，可选择直接返回的type,如果缓存中存在则直接返回不需要设置返回type
 
 @param filePath 文件绝对路径
 @param type 返回文件类型
 @return 返回文件
 */
- (id)readFile:(NSString *)filePath
      FileType:(DDFileType)type;
/**
 读取filed相对路径下的文件，不存在则返回NO，可选择直接返回的type,如果缓存中存在则直接返回不需要设置返回type
 
 @param filePath 文件相对路径
 @param type 返回文件类型
 @param field 相对文件选址
 @return 返回文件
 */
- (id)readFile:(NSString *)filePath
      FileType:(DDFileType)type
     FileField:(DDFileField)field;
/**
 删除nscache内的缓存
 */
- (void)flushCache;
#pragma mark - 计算文件或文件夹大小操作
/**
 通过绝对路径获取文件大小
 
 @param filePath 文件绝对路径
 @param type 返回文件大小的计算格式，kb,mb,gb,tb
 @return 返回文件大小
 */
- (float)countFileSize:(NSString *)filePath
          FileSizeType:(DDSizeType)type;
/**
 通过相对路径获取文件大小
 
 @param filePath 文件相对路径
 @param field 文件选址
 @param type 返回文件大小的计算格式，kb,mb,gb,tb
 @return 返回文件大小
 */
- (float)countFileSize:(NSString *)filePath
                 Field:(DDFileField)field
          FileSizeType:(DDSizeType)type;
/**
 通过绝对路径获取文件夹大小
 
 @param dirPath 文件夹绝对路径
 @param type 返回文件大小的计算格式，kb,mb,gb,tb
 @return 返回文件夹大小
 */
- (float)countDirSize:(NSString *)dirPath
         FileSizeType:(DDSizeType)type;
/**
 通过相对路径获取文件夹大小
 
 @param dirPath 文件夹相对路径
 @param field 文件夹选址
 @param type 返回文件夹大小的计算格式，kb,mb,gb,tb
 @return 返回文件夹大小
 */
- (float)countDirSize:(NSString *)dirPath
                Field:(DDFileField)field
         FileSizeType:(DDSizeType)type;

@end
