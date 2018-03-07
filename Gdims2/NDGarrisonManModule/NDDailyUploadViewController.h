//
//  NDDailyUploadViewController.h
//  Gdims2
//
//  Created by 李青松 on 2018/3/6.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDViewController.h"

@class NDGarrisonDailyModel;

typedef enum : NSUInteger {
    NDDailyVCTypeUpload         = 0,
    NDDailyVCTypeNativeReview   = 1,
    NDDailyVCTypeRemoteReview   = 2
} NDDailyVCType;
/**
 日报上传、查看
 */
@interface NDDailyUploadViewController : NDViewController

@property (nonatomic, strong) NDGarrisonDailyModel * model;
@property (nonatomic, assign) NDDailyVCType type;
@end
