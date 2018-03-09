//
//  NDQCQFDetailModel.h
//  Gdims2
//
//  Created by apple on 2018/3/9.
//  Copyright © 2018年 name. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NDQCQFDetailModel : NSObject
@property (nonatomic,strong) NSString * dis_name;
@property (nonatomic,strong) NSString * monitor_name;
@property (nonatomic,strong) NSString * u_time;
@property (nonatomic,strong) NSString * macro_data;     //宏观数据
@property (nonatomic,strong) NSString * monitor_data;   //实测数据
@property (nonatomic,assign) NSInteger  is_validate;    //0:不合法 /1:合法
@property (nonatomic,assign) NSInteger  warn_level;     //1:蓝色告警/2:黄色告警/3:橙色告警/4:红色告警/-1:异常/0或其他值:正常
@property (nonatomic,strong) NSString * upload_time;
@property (nonatomic,strong) NSString * macro_url;      //宏观图片
@property (nonatomic,strong) NSString * monitor_url;    //监测图片
@property (nonatomic,strong) NSString * serial_no;      //灾害点编号
@property (nonatomic,assign) NSInteger  state;          //(0:无效 /1:有效)
@property (nonatomic,strong) NSString * lon;
@property (nonatomic,strong) NSString * lat;
@property (nonatomic,strong) NSString * otherPhenomena; //其他现象
@property (nonatomic,strong) NSString * remarks;        //备注信息
@property (nonatomic,assign) NSInteger  has_clean;      //

@property (nonatomic,strong,readonly) NSArray<NSString *> * zx_imgList;
@property (nonatomic,strong,readonly) NSString * zx_validString;
@property (nonatomic,strong,readonly) NSString * zx_stateString;
@property (nonatomic,strong,readonly) NSString * zx_warnString;
@property (nonatomic,strong,readonly) UIColor * zx_warnColor;
@end
