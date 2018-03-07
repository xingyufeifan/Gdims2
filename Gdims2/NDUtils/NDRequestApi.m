//
//  NDRequestApi.m
//  Gdims2
//
//  Created by apple on 2018/3/5.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDRequestApi.h"
#import <MJExtension/MJExtension.h>
#import "NDMacroListModel.h"
#import "NDMonitorModel.h"
#import "NDGarrisonModel.h"
@implementation NDRequestApi
+(void)loginWithMobile:(NSString *)mobile userType:(NDUserType)type completion:(void (^)(BOOL, NSString *))completion{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"mobile"] = mobile?mobile:@"";
    dict[@"imei"] = @(type);
    [NDNetwork asycnRequestWithURL:NDAPI_Address(NDAPI_LOGIN, NDApiTypeQCQF) params:dict method:POST NDCompletion:^(id content, NSInteger status, BOOL success, NSString *errorMsg) {
        if (status == 1) {
            if ([content isKindOfClass:[NSDictionary class]]) {
               id info = [[content objectForKey:@"info"] mj_JSONObject];
                if ([info isKindOfClass:[NSDictionary class]] && [info count]) {
                    if (completion) {
                        completion(true,@"登录成功");
                    }
                }else{
                    if (completion) {
                        completion(false,@"该账号无隐患点信息");
                    }
                }
            }else{
                if (completion) {
                    completion(false,@"该账号无隐患点信息");
                }
            }
        }else{
            if (completion) {
                completion(false,errorMsg);
            }
        }
    }];
}

+(void)getMacroListByMobile:(NSString *)mobile userType:(NDUserType)type completion:(void (^)(BOOL, NSArray<NDMacroListModel *> *, NSString *))completion{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"mobile"] = mobile?mobile:@"";
    dict[@"imei"] = @(type);
    [NDNetwork asycnRequestWithURL:NDAPI_Address(NDAPI_FIND_MACRO, NDApiTypeQCQF) params:dict method:POST NDCompletion:^(id content, NSInteger status, BOOL success, NSString *errorMsg) {
        if (status == 1) {
            if ([content isKindOfClass:[NSDictionary class]]) {
                id info = [[content objectForKey:@"info"] mj_JSONObject];
                if ([info isKindOfClass:[NSArray class]] && [info count] > 0) {
                    NSMutableArray * arrList = [NSMutableArray array];
                    for (id obj in info) {
                        [arrList addObject:[NDMacroListModel mj_objectWithKeyValues:obj]];
                    }
                    if (completion) {
                        completion(true, arrList, @"");
                    }
                } else {
                    if (completion) {
                        completion(false, nil, @"无相关灾害点数据");
                    }
                }
                
            } else {
                if (completion) {
                    completion(false, nil ,@"无相关灾害点数据");
                }
            }
        } else {
            if (completion) {
                NSString * errorMsg = [self errorMessageBy:status];
                if (errorMsg == nil) {
                    errorMsg =  @"查询灾害点失败";
                }
                completion(false, nil,errorMsg);
            }
        }
        
    }];
}

+(void)getMonitorListByMobile:(NSString *)mobile userType:(NDUserType)type completion:(void (^)(BOOL, NSArray<NDMonitorModel *> *, NSString *))completion{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"mobile"] = mobile?mobile:@"";
    dict[@"imei"] = @(type);
    [NDNetwork asycnRequestWithURL:NDAPI_Address(NDAPI_FIND_MONITOR, NDApiTypeQCQF) params:dict method:POST NDCompletion:^(id content, NSInteger status, BOOL success, NSString *errorMsg) {
        if (status == 1) {
            if ([content isKindOfClass:[NSDictionary class]]) {
                id info = [[content objectForKey:@"info"] mj_JSONObject];
                if ([info isKindOfClass:[NSArray class]] && [info count] > 0) {
                    NSMutableArray * arrList = [NSMutableArray array];
                    for (id obj in info) {
                        [arrList addObject:[NDMonitorModel mj_objectWithKeyValues:obj]];
                    }
                    if (completion) {
                        completion(true, arrList, @"");
                    }
                } else {
                    if (completion) {
                        completion(false, nil, @"无相关监测点数据");
                    }
                }
            } else {
                if (completion) {
                    completion(false, nil ,@"无相关监测点数据");
                }
            }
        } else {
            if (completion) {
                NSString * errorMsg = [self errorMessageBy:status];
                if (errorMsg == nil) {
                    errorMsg =  @"查询监测点数据失败";
                }
                completion(false, nil,errorMsg);
            }
        }
    }];
}

+(void)getHotLine:(void (^)(BOOL, NSString *))completion{
    [NDNetwork asycnRequestWithURL:NDAPI_Address(NDAPI_HOTLINE_URL, NDApiCommonType) params:nil method:POST NDCompletion:^(id content, NSInteger status, BOOL success, NSString *errorMsg) {
        if (status == 200) {
            if ([content isKindOfClass:[NSDictionary class]]) {
                if (completion) {
                    completion(true, content[@"message"]);
                }
            } else {
                if (completion) {
                    completion(false, @"数据格式错误");
                }
            }
        } else {
            if (completion) {
                NSString * errorMsg = [self errorMessageBy:status];
                if (errorMsg == nil) {
                    errorMsg =  @"获取电话号码失败";
                }
                completion(false, errorMsg);
            }
        }
    }];
}

+(void)uploadLoactionWithLatitude:(NSString *)latitude
                        longitude:(NSString *)longitude
                            phone:(NSString *)phone
                         userType:(NDUserType)type
                       completion:(void (^)(NSInteger, BOOL, NSString *))completion{
    NSString *url = NDAPI_Address(NDAPI_UPLAOD_LOCATION, NDApiCommonType);
    if (type == NDUserTypeZS) {
        url = NDAPI_Address(NDAPI_UPLAOD_LOCATION2, NDApiCommonType);
    }else if(type == NDUserTypePQ){
        url = NDAPI_Address(NDAPI_UPLAOD_LOCATION3, NDApiCommonType);
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"phone"] = phone ? phone : @"";
    param[@"lon"] = longitude ? longitude : @"";
    param[@"lat"] = latitude ? latitude : @"";
    [NDNetwork asycnRequestWithURL:url params:param method:POST NDCompletion:^(id content, NSInteger status, BOOL success, NSString *errorMsg) {
        if (status == 200) {
            completion(status, true, errorMsg);
        } else {
            if (completion) {
                completion(status, false, errorMsg);
            }
        }
    }];
}

+ (void)garrison_SaveDailyByName:(NSString *)userName
                        workType:(NSString *)workType
                       situation:(NSString *)situation
                      logContent:(NSString *)logContent
                          remark:(NSString *)remark
                      recordTime:(NSString *)recordTime
                        phoneNum:(NSString *)phoneNum
                      completion:(void (^)(NSInteger, BOOL, NSString *))completion{
    NSMutableDictionary * dicP = [NSMutableDictionary dictionary];
    [dicP setObject:userName ? : @"" forKey:@"userName"];
    [dicP setObject:workType ? : @"" forKey:@"workType"];
    [dicP setObject:situation ? : @"" forKey:@"situation"];
    [dicP setObject:logContent ? : @"" forKey:@"logContent"];
    [dicP setObject:remark ? : @"" forKey:@"remarks"];
    [dicP setObject:recordTime ? : @"" forKey:@"recordTime"];
    [dicP setObject:phoneNum ? : @"" forKey:@"phoneNum"];
    [NDNetwork asycnRequestWithURL:NDAPI_Address(NDAPI_GARRISON_SAVE_DAILY, NDApiTypeLog) params:dicP method:POST NDCompletion:^(id content, NSInteger status, BOOL success, NSString *errorMsg) {
        if (status == 200) {
            if (completion) {
                completion(status,true,@"");
            }
        } else {
            if (completion) {
                completion(status,false,errorMsg);
            }
        }
    }];
}

+ (NSString *)errorMessageBy:(NSInteger)code {
    switch (code) {
        case 900900:
            return @"接口数据格式错误";
            break;
        case -1001:
            return @"请求超时";
            break;
        case 900901:
            return @"此时无法访问服务器";
            break;
        default:
            break;
    }
    return nil;
}


@end
