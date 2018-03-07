//
//  NDGarrisonModel.h
//  Gdims2
//
//  Created by 李青松 on 2018/3/7.
//  Copyright © 2018年 name. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 驻守员-日报信息缓存，下次自动填充
 */
@interface NDGarrisonMember : NSObject
@property (nonatomic, strong) NSString * user_name;
@property (nonatomic, strong) NSString * work_type;
@property (nonatomic, strong) NSString * situation;

- (void)save;
+ (NDGarrisonMember *)cacheMember;

@end

/**
 驻守员 日报
 */
@interface NDGarrisonDailyModel : NSObject
@property (nonatomic, strong) NSString * nd_cacheId;
@property (nonatomic, strong) NSString * id;
@property (nonatomic, strong) NSString * user_id;
@property (nonatomic, strong) NSString * user_name;
@property (nonatomic, strong) NSString * work_type;
@property (nonatomic, strong) NSString * situation;//在岗情况
@property (nonatomic, strong) NSString * remarks;
@property (nonatomic, strong) NSString * log_content;
@property (nonatomic, strong) NSString * record_time;

- (NSString *)un_inputMsg;
- (void)saveAction;
- (void)clearCache;

+ (NSMutableArray<NDGarrisonDailyModel *> *)cacheList;

@end



/**
 灾情速报-Model
 */
@interface NDDisasterModel: NSObject

@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSString * happenTime;
@property (nonatomic, strong) NSString * township;
@property (nonatomic, strong) NSString * village;
@property (nonatomic, strong) NSString * group;
@property (nonatomic, strong) NSString * disasterNum;
@property (nonatomic, strong) NSString * dieNum;
@property (nonatomic, strong) NSString * missingNum;
@property (nonatomic, strong) NSString * injuredNum;
@property (nonatomic, strong) NSString * houseNum;
@property (nonatomic, strong) NSString * peopleNum;
@property (nonatomic, strong) NSString * notes;
@property (nonatomic, strong) NSMutableArray<NSString *> * imageNames;
@property (nonatomic, strong, readonly) NSArray<NSString *> * nd_imagePaths;

- (void)clearCache;
- (NSString *)un_inputMsg;

@end

