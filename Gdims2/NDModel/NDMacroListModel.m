//
//  NDMacroListModel.m
//  Gdims2
//
//  Created by apple on 2018/3/6.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDMacroListModel.h"
//灾害点模型
@implementation NDMacroListModel
- (NSArray *)zx_macroList {
    if ([self.macroscopicPhenomenon isKindOfClass:[NSString class]] &&
        self.macroscopicPhenomenon.length > 0) {
        //test
        //NSMutableArray * arrtemp = [NSMutableArray arrayWithArray:[self.macroscopicPhenomenon componentsSeparatedByString:@","]];
        //[arrtemp addObject:@"其他现象"];
        //return arrtemp;
        
        NSMutableArray * list = [[self.macroscopicPhenomenon componentsSeparatedByString:@","] mutableCopy];
        NSString * last = [list lastObject];
        if ([last zx_isEmpty]) {
            [list removeLastObject];
        }
        return list;
    }
    return @[];
}
@end

@implementation ZXMacroModel


- (void)loadCache {
    self.imageFileName = [self zx_imageNameCache];
    self.checked = [self zx_checkedCacheData];
    self.zx_otherData = [self zx_otherDataCacheData];
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

- (BOOL)zx_isOther {
    if ([self.name isEqualToString:@"其他现象"]) {
        return true;
    }
    return false;
}

- (BOOL)zx_hasValue {
    if (self.checked) {
        return true;
    } else if (self.zx_isOther) {
        if (self.zx_otherData && [self.zx_otherData isKindOfClass:[NSString class]] && [self.zx_otherData length] > 0) {
            return true;
        }
    }
    return false;
}
- (NSString *)zx_savePrefix {
    return [NSString stringWithFormat:@"ZXMacro%@_%@_%@_",[NDUserInfo sharedInstance].mobile,self.unifiedNumber,self.name];
}

- (NSString *)zx_imageSaveKey {//用于缓存的Id
    return [NSString stringWithFormat:@"%@ImageFileName",[self zx_savePrefix]];
}

- (NSString *)zx_checkedSaveKey {//
    return [NSString stringWithFormat:@"%@Checked",[self zx_savePrefix]];
}

- (NSString *)zx_otherDataSaveKey {//
    return [NSString stringWithFormat:@"%@OtherData",[self zx_savePrefix]];
}

- (void)save {
    if ([self.imageFileName isKindOfClass:[NSString class]] && [self.imageFileName length] > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:self.imageFileName forKey:self.zx_imageSaveKey];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:self.zx_imageSaveKey];
    }
    if (self.checked) {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:self.zx_checkedSaveKey];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:self.zx_checkedSaveKey];
    }
    if ([self zx_isOther]) {//其他现象文字
        if ([self.zx_otherData isKindOfClass:[NSString class]] &&
            [self.zx_otherData length] > 0) {
            [[NSUserDefaults standardUserDefaults] setObject:self.zx_otherData forKey:self.zx_otherDataSaveKey];
        } else {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:self.zx_otherDataSaveKey];
        }
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)zx_imageNameCache{
    NSString * path = [[NSUserDefaults standardUserDefaults] objectForKey:self.zx_imageSaveKey];
    if (path && [path isKindOfClass:[NSString class]] && [path length] > 0) {
        return  path;
    }
    return  nil;
}

- (NSString *)zx_otherDataCacheData {
    NSString * otherData = [[NSUserDefaults standardUserDefaults]objectForKey:self.zx_otherDataSaveKey];
    if (otherData && [otherData isKindOfClass:[NSString class]] && [otherData length] > 0) {
        return  otherData;
    }
    return  nil;
}

- (BOOL)zx_checkedCacheData {
    NSString * zx_checked = [[NSUserDefaults standardUserDefaults]objectForKey:self.zx_checkedSaveKey];
    
    if (zx_checked && [zx_checked isKindOfClass:[NSString class]] && [zx_checked isEqualToString:@"1"]) {
        return true;
    }
    return  false;
}

- (void)clearCache {
    NSUserDefaults * deafults = [NSUserDefaults standardUserDefaults];
    [NDFileUtils deleteFileWithPath:self.zx_imageAbsolutePath];
    [deafults removeObjectForKey:[self zx_imageSaveKey]];
    [deafults removeObjectForKey:[self zx_otherDataSaveKey]];
    [deafults removeObjectForKey:[self zx_checkedSaveKey]];
    [deafults synchronize];
    self.imageFileName = nil;
    self.zx_otherData = nil;
    self.checked = false;
}

- (void)otherUnCheckAction {
    NSUserDefaults * deafults = [NSUserDefaults standardUserDefaults];
    [NDFileUtils deleteFileWithPath:self.zx_imageAbsolutePath];
    [deafults removeObjectForKey:[self zx_imageSaveKey]];
    [deafults removeObjectForKey:[self zx_checkedSaveKey]];
    [deafults synchronize];
    self.zx_otherData = nil;
    self.imageFileName = nil;
    self.checked = false;
}
@end
