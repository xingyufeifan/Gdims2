//
//  NDAreaWeekModel.h
//  Gdims2
//
//  Created by 包宏燕 on 2018/3/7.
//  Copyright © 2018年 name. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 片区管理员-周报信息缓存，下次自动填充
 */
@interface NDAreaWeekMember : NSObject

@property (nonatomic, strong) NSString * user_name;
@property (nonatomic, strong) NSString * township;  //乡镇名称

- (void)save;
+ (NDAreaWeekMember *)cacheMember;

@end


/**
 * 片区管理员-周报
 */
@interface NDAreaWeekModel : NSObject

@property (nonatomic, strong) NSString * id;
@property (nonatomic, strong) NSString * units;        //乡镇名称
@property (nonatomic, strong) NSString * record_time;  //记录时录，自动填充
@property (nonatomic, strong) NSString * user_name;    //片区负责人
@property (nonatomic, strong) NSString * jobContent;   //本周工作情况

- (NSString *)un_inputMsg;

@end
