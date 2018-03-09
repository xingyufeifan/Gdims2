//
//  NDVideoModel.m
//  QCQF
//
//  Created by JuanFelix on 02/12/2017.
//  Copyright © 2017 screson. All rights reserved.
//

#import "NDVideoModel.h"

@implementation NDVideoModel

+ (NSString *)zx_savePrefix {
    return [NSString stringWithFormat:@"NDCacheVideo%@",[NDUserInfo sharedInstance].mobile];
}


+ (void)deleteVideo:(NDVideoModel *)model {
    if (model) {
        NSMutableArray<NDVideoModel *> * list = [self cacheList];
        NSInteger count = list.count;
        if (count > 0) {
            for (NSInteger i = 0; i < count; i++) {
                NDVideoModel * m = list[i];
                if ([m.name isEqualToString:model.name]) {
                    [list removeObjectAtIndex:i];
                    break;
                }
            }
            NSMutableArray<NSString *> * strList = [NSMutableArray array];
            for (NDVideoModel * m in list) {
                [strList addObject:[m mj_JSONString]];
            }
            [[NSUserDefaults standardUserDefaults] setObject:[strList mj_JSONString] forKey:[self zx_savePrefix]];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

+ (void)saveModel:(NDVideoModel *)model {
    if (model) {
        NSMutableArray<NDVideoModel *> * list = [self cacheList];
        if (list.count < 5) {
            [list addObject:model];
            NSMutableArray<NSString *> * strList = [NSMutableArray array];
            for (NDVideoModel * m in list) {
                [strList addObject:[m mj_JSONString]];
            }
            [[NSUserDefaults standardUserDefaults] setObject:[strList mj_JSONString] forKey:[self zx_savePrefix]];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

+ (NSMutableArray<NDVideoModel *> *)cacheList {
    NSMutableArray<NDVideoModel *> * list = [NSMutableArray array];
    NSString * strList = [[NSUserDefaults standardUserDefaults] objectForKey:[self zx_savePrefix]];
    if (strList && [strList isKindOfClass:[NSString class]] && strList.length) {
        id obj = [strList mj_JSONObject];
        if ([obj isKindOfClass:[NSArray class]]) {
            for (id m in obj) {
                NDVideoModel * model = [NDVideoModel mj_objectWithKeyValues:m];
                if (model) {
                    [list addObject:model];
                }
            }
        }
    }
    return list;
}


- (NSURL *)ND_videoUrl{
    if (self.ND_path) {
        return [NSURL fileURLWithPath:self.ND_path];
    }
    return nil;
}

- (NSString *)ND_path {
    if (self.name) {
        return [[NDFileUtils videoCachePath] stringByAppendingPathComponent:self.name];
    }
    return nil;
}

- (void)save {
    [NDVideoModel saveModel:self];
}

- (void)clearCache {
    [NDFileUtils deleteFileWithPath:[self ND_path]];
    [NDVideoModel deleteVideo:self];
}

+ (NSArray *)mj_ignoredPropertyNames {
    return @[@"zx_checked"];
}

@end
