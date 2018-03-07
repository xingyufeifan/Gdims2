//
//  NDAreaWeekModel.m
//  Gdims2
//
//  Created by 包宏燕 on 2018/3/7.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDAreaWeekModel.h"
#import "NSString+NDTimeString.h"

@implementation NDAreaWeekMember

- (instancetype)init {
    if (self = [super init]) {
        self.user_name = nil;
        self.township = nil;
    }
    return self;
}

- (void)save {
    [NDAreaWeekMember saveMember:self];
}

+ (NSString *)savekey {
    return [NSString stringWithFormat:@"NDAreaOfficer%@_Member", [NDUserInfo sharedInstance].mobile];
}

+ (void)saveMember:(NDAreaWeekMember *)member {
    if (member) {
        NSString * str = [member mj_JSONString];
        if (str) {
            [[NSUserDefaults standardUserDefaults] setObject:str forKey:[self savekey]];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:[self savekey]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (NDAreaWeekMember *)cacheMember {
    id obj = [[NSUserDefaults standardUserDefaults] objectForKey:[self savekey]];
    if (obj && [obj isKindOfClass:[NSString class]]) {
        NDAreaWeekMember * member = [NDAreaWeekMember mj_objectWithKeyValues:obj];
        if ([member.user_name zx_isEmpty]) {
            member.user_name = [NDUserInfo sharedInstance].name;
        }
        if (member) {
            return member;
        }
    }
    NDAreaWeekMember * member = [[NDAreaWeekMember alloc] init];
    member.user_name = [NDUserInfo sharedInstance].name;
    return member;
}

@end

@implementation NDAreaWeekModel

- (instancetype)init {
    if (self = [super init]) {
        self.units = nil;
        self.record_time = [NSString zx_currentDateString];
        self.user_name = nil;
        self.jobContent = nil;
    }
    return self;
}

/**
 * 检查输入框
 */
- (NSString *)un_inputMsg {
    if (self.units == nil || [self.units zx_isEmpty]) {
        return @"请填写乡镇名称";
    }
    if (self.user_name == nil || [self.user_name zx_isEmpty]) {
        return @"请填写负责人名称";
    }
    if (self.jobContent == nil || [self.jobContent zx_isEmpty]) {
        return @"请填写周报内容";
    }
    return nil;
}

@end
