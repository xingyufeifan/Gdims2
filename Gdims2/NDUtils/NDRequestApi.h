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
typedef enum: NSUInteger{
    NDUserTypeQCQF = 0,
    NDUserTypeZS = 1,
    NDUserTypePQ = 2
}NDUserType;
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
@end
