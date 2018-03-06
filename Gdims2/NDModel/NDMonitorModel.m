//
//  NDMonitorModel.m
//  Gdims2
//
//  Created by apple on 2018/3/6.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDMonitorModel.h"

@implementation NDMonitorModel
- (void)loadCache {
    
    self.imageFileName = [self zx_imageCachePath];
    self.zx_inputData = [self zx_inputDataCache];
    self.zx_resetRainFall = [self zx_isResetRainfallCacheData];
}

- (BOOL)zx_isMonitorRainValue {
    if ([self.monType isEqualToString:@"雨量"]) {
        return true;
    }
    return false;
}

- (NSURL *)imageUrl {
    if (self.zx_imageAbsolutePath && self.zx_imageAbsolutePath.length > 0) {
        return [NSURL fileURLWithPath:self.zx_imageAbsolutePath];
    }
    return nil;
}

- (NSString *)zx_imageAbsolutePath {
    if (self.imageFileName && self.imageFileName.length > 0) {
        return [[NDFileUtils imageCachePath] stringByAppendingPathComponent:self.imageFileName];
    }
    return nil;
}

- (NSString *)zx_savePrefix {
    return [NSString stringWithFormat:@"ZXMonitor%@_%@_%@_",[NDUserInfo sharedInstance].mobile,self.unifiedNumber,self.monPointNumber];
}

- (NSString *)zx_imageSaveKey {//用于缓存的Id
    return [NSString stringWithFormat:@"%@ImageFileName",[self zx_savePrefix]];
}

- (NSString *)zx_dataSaveKey {//用于缓存的Id
    return [NSString stringWithFormat:@"%@Data",[self zx_savePrefix]];
}

- (NSString *)zx_resetRainFallSaveKey {
    return [NSString stringWithFormat:@"%@ResetRF",[self zx_savePrefix]];
}

- (void)save {
    if ([self.imageFileName isKindOfClass:[NSString class]] && [self.imageFileName length] > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:self.imageFileName forKey:[self zx_imageSaveKey]];
    } else {
        [NDFileUtils deleteFileWithPath:self.zx_imageAbsolutePath];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:[self zx_imageSaveKey]];
    }
    if ([self.zx_inputData isKindOfClass:[NSString class]] && [self.zx_inputData length] > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:self.zx_inputData forKey:[self zx_dataSaveKey]];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:[self zx_dataSaveKey]];
    }
    //if ([self zx_isMonitorRainValue]) {
    [[NSUserDefaults standardUserDefaults] setBool:self.zx_resetRainFall forKey:[self zx_resetRainFallSaveKey]];
    //}
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)clearCache {
    NSUserDefaults * deafults = [NSUserDefaults standardUserDefaults];
    [NDFileUtils deleteFileWithPath:self.zx_imageAbsolutePath];
    [deafults removeObjectForKey:[self zx_imageSaveKey]];
    [deafults removeObjectForKey:[self zx_dataSaveKey]];
    [deafults removeObjectForKey:[self zx_resetRainFallSaveKey]];
    [deafults synchronize];
    self.imageFileName = nil;
    self.zx_inputData = nil;
    
}

- (NSString *)zx_imageCachePath{
    NSString * path = [[NSUserDefaults standardUserDefaults] objectForKey:self.zx_imageSaveKey];
    if (path && [path isKindOfClass:[NSString class]] && [path length] > 0) {
        return  path;
    }
    return  nil;
}

- (NSString *)zx_inputDataCache{
    NSString * data = [[NSUserDefaults standardUserDefaults] objectForKey:self.zx_dataSaveKey];
    if (data && [data isKindOfClass:[NSString class]] && [data length] > 0) {
        return  data;
    }
    return  nil;
}

- (BOOL)zx_isResetRainfallCacheData {
    return [[NSUserDefaults standardUserDefaults] boolForKey:[self zx_resetRainFallSaveKey]];
}
@end
