//
//  NDMacroListModel.h
//  Gdims2
//
//  Created by apple on 2018/3/6.
//  Copyright © 2018年 name. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NDMonitorModel;
@interface NDMacroListModel : NSObject
@property (nonatomic, assign)   NSInteger legalR;           //合法性
@property (nonatomic, copy)     NSString * unifiedNumber;   //灾害点编号
@property (nonatomic, copy)     NSString * name;            //灾害点名称
@property (nonatomic, copy)     NSString * disasterType;    //灾害点类型
@property (nonatomic, strong)   NSNumber * longitude;
@property (nonatomic, strong)   NSNumber * latitude;
@property (nonatomic, copy)     NSString * macroscopicPhenomenon;   //宏观现象

@property (nonatomic, assign)   BOOL zxExand;
@property (nonatomic, assign)   NSInteger zxIndex;
@property (nonatomic, strong, readonly) NSArray * zx_macroList;
//自行分组 这尼玛 直接挂在灾害点下面不行
@property (nonatomic,strong) NSArray<NDMonitorModel *> * monitorList;

@end

@interface ZXMacroModel : NSObject
@property (nonatomic, assign)   BOOL checked;//是否异常
@property (nonatomic, copy)     NSString * name;
@property (nonatomic, copy)     NSString * imageFileName;
@property (nonatomic, copy)     NSString * unifiedNumber;//灾害点编号
@property (nonatomic, copy)     NSString * zx_otherData;//其他现象数据
@property (nonatomic, copy,readonly) NSString * zx_imageAbsolutePath;
@property (nonatomic, strong, readonly)   NSURL * imageUrl;
@property (nonatomic, assign, readonly)   BOOL zx_isOther;
@property (nonatomic, assign, readonly)   BOOL zx_hasValue;
- (void)loadCache;//在 unifiedNumber name 赋值完成之后调用
- (void)save;
- (void)clearCache;
- (void)otherUnCheckAction;//不清空文本输入
@end
