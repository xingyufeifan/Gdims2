//
//  NDGarrisonModel.m
//  Gdims2
//
//  Created by 李青松 on 2018/3/7.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDGarrisonModel.h"


/**
 驻守员
 */
@implementation NDGarrisonMember

- (instancetype)init{
    if (self = [super init]) {
        self.user_name = nil;
        self.situation = nil;
        self.work_type = nil;
    }
    return self;
}

- (void)save {
    [NDGarrisonMember saveMember:self];
}

+ (NSString *)saveKey{
    return [NSString stringWithFormat:@"NDGarrison%@_Member",[NDUserInfo sharedInstance].mobile];
}

+ (void)saveMember:(NDGarrisonMember *)member {
    if (member) {
        NSString * str = [member mj_JSONString];
        if (str) {
            [[NSUserDefaults standardUserDefaults] setObject:str forKey:[self saveKey]];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:[self saveKey]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (NDGarrisonMember *)cacheMember {
    id obj = [[NSUserDefaults standardUserDefaults] objectForKey:[self saveKey]];
    if (obj && [obj isKindOfClass:[NSString class]]) {
        NDGarrisonMember * member = [NDGarrisonMember mj_objectWithKeyValues:obj];
        if ([member.user_name zx_isEmpty]) {
            member.user_name = [NDUserInfo sharedInstance].name;
        }
        if (member) {
            return member;
        }
    }
    NDGarrisonMember * member = [[NDGarrisonMember alloc] init];
    member.user_name = [NDUserInfo sharedInstance].name;
    return member;
}

@end


/**
 日报
 */
@implementation NDGarrisonDailyModel

- (instancetype)init {
    if (self = [super init]) {
        self.nd_cacheId = [NSString zx_serialNumber];
        self.user_name = nil;
        self.record_time = [NSString zx_currentDateString];
        self.work_type = nil;
        self.situation = nil;
        self.remarks = nil;
        self.log_content = nil;
        NSLog(@"username = %@ ,remarks = %@ ,log_content =%@",self.user_name,self.remarks,self.log_content);
    }
    return self;
}


- (NSString *)un_inputMsg {
    if (self.user_name == nil || [self.user_name zx_isEmpty]) {
        return @"请填写记录人名称";
    }
    if (self.work_type == nil || [self.work_type zx_isEmpty]) {
        return @"请填写工作类型";
    }
    if (self.situation == nil || [self.situation zx_isEmpty]) {
        return @"请填写在岗情况";
    }
    if (self.log_content == nil || [self.log_content zx_isEmpty]) {
        return @"请填写日志内容";
    }
    return nil;
}

- (void)saveAction {
    [NDGarrisonDailyModel saveModel:self];
}

- (void)clearCache {
    [NDGarrisonDailyModel deleteModel:self];
}

+ (NSString *)nd_savePrefix {
    return [NSString stringWithFormat:@"NDGarrison%@_Daily",[NDUserInfo sharedInstance].mobile];
}

+ (void)saveModel:(NDGarrisonDailyModel *)model {
    if (model) {
        NSMutableArray<NDGarrisonDailyModel *> * list = [self cacheList];
        NSInteger count = list.count;
        if (count > 0) {
            BOOL hasCache = false;
            for (int i = 0; i < count; i++) {
                NDGarrisonDailyModel * cm = list[i];
                if ([cm.nd_cacheId isEqualToString:model.nd_cacheId]) {
                    [list replaceObjectAtIndex:i withObject:model];
                    hasCache = true;
                    break;
                }
            }
            if (!hasCache) {
                [list addObject:model];
            }
        } else {
            [list addObject:model];
        }
        NSMutableArray<NSString *> * strList = [NSMutableArray array];
        for (NDGarrisonDailyModel * m in list) {
            [strList addObject:[m mj_JSONString]];
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:[strList mj_JSONString] forKey:[self nd_savePrefix]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (void)deleteModel:(NDGarrisonDailyModel *)model {
    if (model) {
        NSMutableArray<NDGarrisonDailyModel *> * list = [self cacheList];
        NSInteger count = list.count;
        if (count > 0) {
            for (int i = 0; i < count; i++) {
                NDGarrisonDailyModel * cm = list[i];
                if ([cm.nd_cacheId isEqualToString:model.nd_cacheId]) {
                    [list removeObjectAtIndex:i];
                    break;
                }
            }
        }
        NSMutableArray<NSString *> * strList = [NSMutableArray array];
        for (NDGarrisonDailyModel * m in list) {
            [strList addObject:[m mj_JSONString]];
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:[strList mj_JSONString] forKey:[self nd_savePrefix]];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
}

+ (NSMutableArray<NDGarrisonDailyModel *> *)cacheList {
    NSMutableArray<NDGarrisonDailyModel *> * list = [NSMutableArray array];
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:[self nd_savePrefix]];
    if ([str isKindOfClass:[NSString class]] && str.length) {
        id obj = [str mj_JSONObject];
        if ([obj isKindOfClass:[NSArray class]]) {
            for (id m in obj) {
                NDGarrisonDailyModel * model = [NDGarrisonDailyModel mj_objectWithKeyValues:m];
                if (model) {
                    [list addObject:model];
                }
            }
            return list;
        }
    }
    return list;
}

@end


/**
 灾情
 */
@implementation NDDisasterModel

- (instancetype)init {
    if (self = [super init]) {
        self.userName = nil;
        self.happenTime = nil;
        self.township = nil;
        self.village = nil;
        self.group = nil;
        self.disasterNum = nil;
        self.dieNum = nil;
        self.missingNum = nil;
        self.injuredNum = nil;
        self.houseNum = nil;
        self.peopleNum = nil;
        self.notes = nil;
        self.imageNames = [NSMutableArray array];
    }
    return self;
}

- (NSString *)un_inputMsg {
    if (self.userName == nil || [self.userName zx_isEmpty]) {
        return @"请填写姓名";
    }
    if (self.happenTime == nil || [self.happenTime zx_isEmpty]) {
        return @"请填写日期";
    }
    if (self.township == nil || [self.township zx_isEmpty]) {
        return @"请填写乡/镇信息";
    }
    if (self.village == nil || [self.village zx_isEmpty]) {
        return @"请填写村信息";
    }
    if (self.group == nil || [self.group zx_isEmpty]) {
        return @"请填写组信息";
    }
    return nil;
}

- (NSArray<NSString *> *)zx_imagePaths {
    NSMutableArray<NSString *> * arrPaths = [NSMutableArray array];
    NSArray * arrNames = self.imageNames;
    if (arrNames && arrNames.count > 0) {
        for (NSString * name in arrNames) {
            if (name && ![name zx_isEmpty]) {
                [arrPaths addObject:[[NDFileUtils imageCachePath] stringByAppendingPathComponent:name]];
            }
        }
    }
    return arrPaths;
}

- (void)clearCache {
    NSArray * arrPaths = [self zx_imagePaths];
    if (arrPaths && arrPaths.count > 0) {
        for (NSString * path in arrPaths) {
            [NDFileUtils deleteFileWithPath:path];
        }
    }
    [self.imageNames removeAllObjects];
}

@end

