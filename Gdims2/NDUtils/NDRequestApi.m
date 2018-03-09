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
                    NSString * name = info[@"name"];
                    if (name && [name isKindOfClass:[NSString class]]) {
                        [NDUserInfo sharedInstance].name = name;
                    } else {
                        [NDUserInfo sharedInstance].name = nil;
                    }
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
                        completion:(void (^)(NSInteger, BOOL, NSString *))completion {
    NSMutableDictionary * dicP = [NSMutableDictionary dictionary];
    [dicP setObject:phoneNum ? : @"" forKey:@"phoneNum"];
    [dicP setObject:@(type) forKey:@"phoneID"];
    [dicP setObject:userName ? : @"" forKey:@"userName"];
    [dicP setObject:happenTime ? : @"" forKey:@"happenTime"];
    [dicP setObject:township ? : @"" forKey:@"township"];
    [dicP setObject:village ? : @"" forKey:@"village"];
    [dicP setObject:group ? : @"" forKey:@"group"];
    [dicP setObject:disasterNum ? : @"" forKey:@"disasterNum"];
    [dicP setObject:dieNum ? : @"" forKey:@"dieNum"];
    [dicP setObject:missingNum ? : @"" forKey:@"missingNum"];
    [dicP setObject:injuredNum ? : @"" forKey:@"injuredNum"];
    [dicP setObject:houseNum ? : @"" forKey:@"houseNum"];
    [dicP setObject:peopleNum ? : @"" forKey:@"peopleNum"];
    [dicP setObject:notes ? : @"" forKey:@"notes"];
    if (images && images.count > 0) {
        [NDNetwork uploadImageToResourceURL:NDAPI_Address(NDAPI_GARRISON_SAVE_DISATER, NDApiTypeLog) images:images fileNames:fileNames name:@"upload" compressQulity:0.8 params:dicP NDCompletion:^(id content, NSInteger status, BOOL success, NSString *errorMsg) {
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
    } else {
        [NDNetwork asycnRequestWithURL:NDAPI_Address(NDAPI_GARRISON_SAVE_DISATER, NDApiTypeLog) params:dicP method:POST NDCompletion:^(id content, NSInteger status, BOOL success, NSString *errorMsg) {
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
}

+ (void)garrison_DaliyListByMobile:(NSString *)mobile
                        completion:(void (^)(BOOL, NSArray<NDGarrisonDailyModel *> *, NSString *))completion {
    NSMutableDictionary * dicp = [NSMutableDictionary dictionary];
    dicp[@"mobile"] = mobile ? mobile : @"";
    dicp[@"type"] = @"1";
    [NDNetwork asycnRequestWithURL:NDAPI_Address(NDAPI_DAILY_WEEK_LIST, NDApiCommonType) params:dicp method:POST NDCompletion:^(id content, NSInteger status, BOOL success, NSString *errorMsg) {
        if (status == 200) {
            id info = [[content objectForKey:@"data"] mj_JSONObject];
            if ([info isKindOfClass:[NSArray class]] && [info count] > 0) {
                NSMutableArray * arrList = [NSMutableArray array];
                for (id obj in info) {
                    [arrList addObject:[NDGarrisonDailyModel mj_objectWithKeyValues:obj]];
                }
                if (completion) {
                    completion(true, arrList, @"");
                }
            } else {
                if (completion) {
                    completion(true, @[], @"无相关日志记录");
                }
            }
        } else {
            if (completion) {
                completion(status,false,errorMsg);
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

+ (void)uploadVideo:(NSArray<NSData *> *)videos
          fileNames:(NSArray<NSString *> *)fileNames
             mobile:(NSString *)mobile
           userType:(NDUserType)type
         completion:(void (^)(NSInteger, BOOL, NSString *))completion{
    NSMutableDictionary * dicp = [NSMutableDictionary dictionary];
    dicp[@"mobile"] = mobile ? mobile : @"";
    dicp[@"type"] = @(type);
    [NDNetwork uploadVideoToResourceURL:NDAPI_Address(NDAPI_VIDEO_UPLOAD, NDApiCommonType) videos:videos fileNames:fileNames params:dicp NDCompletion:^(id content, NSInteger status, BOOL success, NSString *errorMsg) {
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
