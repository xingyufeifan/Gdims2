//
//  NDFileUtils.h
//  Gdims2
//
//  Created by apple on 2018/3/6.
//  Copyright © 2018年 name. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NDFileUtils : NSObject
+ (void)loadPath;

+ (NSString *)imageCachePath;
+ (void)saveImage:(UIImage *)image
       completion:(void(^)(BOOL success, NSString * fileName))completion;

+ (NSString *)videoCachePath;
//+ (void)saveVideoFrom:(NSString *)tempPath
//           completion:(void(^)(BOOL success, NSString * fileName))completion;

+ (void)deleteFileWithPath:(NSString *)path;

/**
 清除缓存
 - 图片
 - 视频
 - UserDefaults
 */
+ (void)deleteAllCaches:(void(^)(void))callBack;
@end
