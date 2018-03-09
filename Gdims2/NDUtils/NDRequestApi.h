//
//  NDRequestApi.h
//  Gdims2
//
//  Created by apple on 2018/3/5.
//  Copyright © 2018年 name. All rights reserved.
//

#import <Foundation/Foundation.h>
@class NDMacroListModel;
@class NDMonitorModel;
@class NDGarrisonDailyModel;

typedef enum: NSUInteger{
    NDUserTypeQCQF = 0,
    NDUserTypeZS = 1,
    NDUserTypePQ = 2
}NDUserType;

typedef enum : NSUInteger {
    NDQCQFDetailTypeMacro   = 1,    //宏观
    NDQCQFDetailTypeMonitor = 2     //定量
} NDQCQFDetailType;//群测群防历史记录类型

typedef enum : NSUInteger {
    NDDataUploadMacroMonitor,
    NDDataUploadQuantiativeMonitor,
    NDDataUploadRainFallMonitor,
} NDDataUploadType;
@interface NDRequestApi : NSObject
/**
 登录接口
 
 @param mobile Tel
 @param type -
 @param completion callBack
 */
+ (void)loginWithMobile:(NSString *)mobile
               userType:(NDUserType)type
             completion:(void(^)(BOOL,NSString *))completion;
/**
 热线电话
 
 @param completion _
 */
+ (void)getHotLine:(void(^)(BOOL success,NSString * message))completion;


/**
 灾害点列表
 
 @param mobile Tel
 @param type 0
 @param completion _
 */
+ (void)getMacroListByMobile:(NSString *)mobile
                        userType:(NDUserType)type
                  completion:(void(^)(BOOL success,NSArray<NDMacroListModel *> * list,NSString * errorMsg))completion;

/**
 监测点列表
 
 @param mobile Tel
 @param type 0
 @param completion _
 */
+ (void)getMonitorListByMobile:(NSString *)mobile
                          userType:(NDUserType)type
                    completion:(void(^)(BOOL success,NSArray<NDMonitorModel *> * list,NSString * errorMsg))completion;

/**
 上传定位
 
 @param latitude latitude description
 @param longitude longitude description
 @param phone phone description
 @param type 用户类型不一样，接口地址不一样
 @param completion completion description
 */
+ (void)uploadLoactionWithLatitude:(NSString *)latitude
                         longitude:(NSString *)longitude
                             phone:(NSString *)phone
                          userType:(NDUserType)type
                        completion:(void(^)(NSInteger status, BOOL success, NSString *errorMsg))completion;
/**
 上传定量监测/雨量监测数据
 
 @param mobile mobile description
 @param type type description
 @param serialNum serialNum description
 @param longitude longitude description
 @param latitude latitude description
 @param unifiedNumber 灾害点变化
 @param monPointNumber 监测点编号
 @param monPointDate monPointDate description
 @param reset 是否清空雨量
 @param measuredData 计量值
 @param image image description
 @param completion completion description
 */
+ (void)uploadMonitorDataWithMobile:(NSString *)mobile
                               type:(NDDataUploadType)type
                          serialNum:(NSString *)serialNum
                          longitude:(NSString *)longitude
                           latitude:(NSString *)latitude
                      unifiedNumber:(NSString *)unifiedNumber
                     monPointNumber:(NSString *)monPointNumber
                       monPointDate:(NSString *)monPointDate
                      resetRailfall:(BOOL)reset
                       measuredData:(NSString *)measuredData
                              image:(UIImage *)image
                           fileName:(NSString *)fileName
                         completion:(void(^)(NSInteger status, BOOL success, NSString *errorMsg))completion;

/**
 驻守人员-灾情速报上报接口
 
 @param userName userName description
 @param type userType
 @param phoneNum phoneNum description
 @param happenTime happenTime description
 @param township 乡/镇
 @param village 村
 @param group 组
 @param disasterNum 受灾人数
 @param dieNum 死亡人数
 @param missingNum 失踪人数
 @param injuredNum 受伤人数
 @param houseNum 潜在威胁户数
 @param peopleNum 潜在威胁人数
 @param notes 备注
 @param images 图片文件
 @param fileNames 图片名称
 @param completion completion description
 */
+ (void)garrison_SaveDisaterByName:(NSString *)userName
                          userType:(NDUserType)type
                          phoneNum:(NSString *)phoneNum
                        happenTime:(NSString *)happenTime
                          township:(NSString *)township
                           village:(NSString *)village
                             group:(NSString *)group
                       disasterNum:(NSString *)disasterNum
                            dieNum:(NSString *)dieNum
                        missingNum:(NSString *)missingNum
                        injuredNum:(NSString *)injuredNum
                          houseNum:(NSString *)houseNum
                         peopleNum:(NSString *)peopleNum
                             notes:(NSString *)notes
                            images:(NSArray<UIImage *> *)images
                         fileNames:(NSArray<NSString *> *)fileNames
                        completion:(void(^)(NSInteger status, BOOL success, NSString *errorMsg))completion;
/**
 驻守人员 日报列表
 
 @param mobile mobile description
 @param completion completion description
 */
+ (void)garrison_DaliyListByMobile:(NSString *)mobile
                        completion:(void(^)(BOOL success, NSArray<NDGarrisonDailyModel * > * list, NSString *errorMsg))completion;
/**
 驻守人员-工作日志上报
 
 @param userName userName description
 @param workType 工作类型
 @param situation 在岗情况
 @param logContent logContent description
 @param remark remark description
 @param recordTime recordTime description
 @param phoneNum phoneNum description
 @param completion completion description
 */
+ (void)garrison_SaveDailyByName:(NSString *)userName
                        workType:(NSString *)workType
                       situation:(NSString *)situation
                      logContent:(NSString *)logContent
                          remark:(NSString *)remark
                      recordTime:(NSString *)recordTime
                        phoneNum:(NSString *)phoneNum
                      completion:(void(^)(NSInteger status, BOOL success, NSString *errorMsg))completion;
@end
