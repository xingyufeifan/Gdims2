//
//  NDFileUtils.m
//  Gdims2
//
//  Created by apple on 2018/3/6.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDFileUtils.h"
#import <SDWebImage/SDImageCache.h>
@implementation NDFileUtils
+ (void)loadPath {
    [self imageCachePath];
    [self videoCachePath];
}

+ (NSString *)imageCachePath{
    NSString * home = NSHomeDirectory();
    NSString * cachePath = [home stringByAppendingPathComponent:@"Library/ZXImageCache"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:cachePath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:cachePath withIntermediateDirectories:true attributes:nil error:nil];
    }
    return cachePath;
}

+ (void)saveImage:(UIImage *)image
       completion:(void(^)(BOOL success, NSString * fileName))completion {
    NSString * fileName = [NSString stringWithFormat:@"%@.jpg",[NSString zx_serialNumber]];
    NSString * filePath = [[self imageCachePath] stringByAppendingPathComponent:fileName];
    NSData * data = UIImageJPEGRepresentation(image, 0.5);
    if (data) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            if ([data writeToFile:filePath atomically:true]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) {
                        completion(true,fileName);
                    }
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion) {
                        completion(false,nil);
                    }
                    
                });
            }
        });
    } else {
        if (completion) {
            completion(false,nil);
        }
    }
}

+ (void)deleteFileWithPath:(NSString *)path{
    NSFileManager * manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:path]) {
        [manager removeItemAtPath:path error:nil];
    }
}

+ (NSString *)videoCachePath{
    NSString * home = NSHomeDirectory();
    NSString * cachePath = [home stringByAppendingPathComponent:@"Library/ZXVideoCache"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:cachePath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:cachePath withIntermediateDirectories:true attributes:nil error:nil];
    }
    return cachePath;
}

+ (void)deleteAllCaches:(void(^)(void))callBack {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
        NSFileManager * manager = [NSFileManager defaultManager];
        NSString * imagePath = [self imageCachePath];//清空图片
        if ([manager fileExistsAtPath:imagePath]) {
            [manager removeItemAtPath:imagePath error:nil];
        }
        
        NSString * videoPath = [self videoCachePath];//清空视频
        if ([manager fileExistsAtPath:videoPath]) {
            [manager removeItemAtPath:videoPath error:nil];
        }
        //清空所有保存的值
        NSDictionary * dic = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
        for (id key in dic) {
            if ([key isKindOfClass:[NSString class]]) {
                if ([key hasPrefix:@"ZXMacro"] ||
                    [key hasPrefix:@"ZXMonitor"] ||
                    [key hasPrefix:@"ZXGarrison"] ||
                    [key hasPrefix:@"ZXCacheVideo"] ||
                    [key hasPrefix:@"ZXAreaOfficer"]) {
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
                }
            }
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (callBack) {
                callBack();
            }
        });
    });
}
@end
