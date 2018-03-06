//
//  NDMonitorModel.h
//  Gdims2
//
//  Created by apple on 2018/3/6.
//  Copyright © 2018年 name. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NDMonitorModel : NSObject
@property (nonatomic, assign)   NSInteger legalR;               //合法半径
@property (nonatomic, strong)   NSNumber * xpoint;              //经度
@property (nonatomic, strong)   NSNumber * ypoint;              //纬度
@property (nonatomic, copy)     NSString * unifiedNumber;       //灾害点编号
@property (nonatomic, copy)     NSString * monPointName;        //监测点名称
@property (nonatomic, copy)     NSString * monAngle;            //监测角度
@property (nonatomic, copy)     NSString * monDirection;        //监测方向
@property (nonatomic, copy)     NSString * monPointNumber;      //监测点编号
@property (nonatomic, copy)     NSString * dimension;           //单位
@property (nonatomic, copy)     NSString * monType;             //监测类型
@property (nonatomic, copy)     NSString * monPointLocation;    //监测点位置
@property (nonatomic, copy)     NSString * monContent;          //监测内容
@property (nonatomic, copy)     NSString * instrumentConstant;
@property (nonatomic, copy)     NSString * instrumentNumber;

//
@property (nonatomic, copy)     NSString * zx_inputData;
@property (nonatomic, copy)     NSString * imageFileName;
@property (nonatomic, assign)   BOOL zx_resetRainFall;          //清空雨量筒（雨量监测）
@property (nonatomic, copy,readonly)    NSString * zx_imageAbsolutePath;
@property (nonatomic, strong, readonly) NSURL * imageUrl;
@property (nonatomic, assign, readonly) BOOL zx_isMonitorRainValue;//是否为雨量监测
- (void)loadCache; //在 monPointNumber unifiedNumber赋值完成之后调用
- (void)save;
- (void)clearCache;
@end
