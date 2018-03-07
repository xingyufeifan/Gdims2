//
//  NDWeekLogUploadViewController.h
//  Gdims2
//
//  Created by 包宏燕 on 2018/3/7.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDViewController.h"
@class NDAreaWeekModel;
typedef enum : NSUInteger {
    NDWeekLogVCTypeUpload = 0,
    NDWeekLogVCTypeReview = 1
} NDWeekLogVCType;

/**
 * 片区周报上报页面
 */
@interface NDWeekLogUploadViewController : NDViewController

@property (nonatomic, strong) NDAreaWeekModel * model;
@property (nonatomic, assign) NDWeekLogVCType type;

@end
