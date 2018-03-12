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
#import "NDAreaWeekModel.h"
#import "NDQCQFDetailModel.h"
@implementation NDRequestApi

+ (NSString *)valueOfType:(NDDataUploadType)type {
    switch (type) {
        case NDDataUploadMacroMonitor:
            return @"宏观观测";
            break;
        case NDDataUploadQuantiativeMonitor:
            return @"定量监测";
            break;
        case NDDataUploadRainFallMonitor:
            return @"雨量监测";
            break;
        default:
            break;
    }
    return nil;
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
    // 群测群防
    NSString *url = NDAPI_Address(NDAPI_UPLAOD_LOCATION, NDApiCommonType);
    if (type == NDUserTypeZS) { //驻守人员
        url = NDAPI_Address(NDAPI_UPLAOD_LOCATION2, NDApiCommonType);
    }
    else if(type == NDUserTypePQ){ //片区专管
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

+ (void)uploadMacroMoDataWithRIndex:(NSInteger)requestIndex
                             mobile:(NSString *)mobile
                           serialNo:(NSString *)serialNo
                          longitude:(NSString *)longitude
                           latitude:(NSString *)latitude
              macroscopicPhenomenon:(NSString *)macroscopicPhenomenon
                      unifiedNumber:(NSString *)unifiedNumber
                       monPointDate:(NSString *)monPointDate
                         totalCount:(NSString *)totalCount
                              image:(UIImage *)image
                           fileName:(NSString *)fileName
                     otherPhenomena:(NSString *)otherPhenomena
                            remarks:(NSString *)remarks
                         completion:(void (^)(NSInteger, BOOL, NSString *, NSInteger))completion{
    NSMutableDictionary * dicP = [NSMutableDictionary dictionary];
    //无值 字段必传
    [dicP setObject:serialNo ? serialNo : @"" forKey:@"serialNo"];
    [dicP setObject:mobile ? mobile : @"" forKey:@"mobile"];
    [dicP setObject:longitude ? longitude : @"" forKey:@"xpoint"];
    [dicP setObject:latitude ? latitude : @"" forKey:@"ypoint"];
    [dicP setObject:totalCount ? totalCount : @"" forKey:@"count"];
    [dicP setObject:@"宏观观测" forKey:@"monitorType"];
    [dicP setObject:unifiedNumber ? unifiedNumber : @"" forKey:@"unifiedNumber"];
    [dicP setObject:macroscopicPhenomenon ? macroscopicPhenomenon : @"" forKey:@"macroscopicPhenomenon"];
    [dicP setObject:monPointDate ? monPointDate : @"" forKey:@"monPointDate"];
    [dicP setObject:otherPhenomena ? otherPhenomena : @"" forKey:@"otherPhenomena"];
    [dicP setObject:remarks ? remarks : @"" forKey:@"remarks"];
    if (image) {
        [NDNetwork uploadImageToResourceURL:NDAPI_Address(NDAPI_UPLOAD_DATA, NDApiTypeQCQF) images:@[image] fileNames:@[fileName] name:@"uploads" compressQulity:0.8 params:dicP NDCompletion:^(id content, NSInteger status, BOOL success, NSString *errorMsg) {
            if (status == 1) {
                if (completion) {
                    completion(status,true,@"",requestIndex);
                }
            } else {
                if (completion) {
                    completion(status,false,errorMsg,requestIndex);
                }
            }
        }];
    }else{
        [NDNetwork asycnRequestWithURL:NDAPI_Address(NDAPI_UPLOAD_DATA, NDApiTypeQCQF) params:dicP method:POST NDCompletion:^(id content, NSInteger status, BOOL success, NSString *errorMsg) {
            if (status == 1) {
                if (completion) {
                    completion(status,true,@"",requestIndex);
                }
            } else {
                if (completion) {
                    completion(status,false,errorMsg,requestIndex);
                }
            }
        }];
    }
}

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
                         completion:(void (^)(NSInteger, BOOL, NSString *))completion{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"" forKey:@"serialNo"];
    [params setObject:@"" forKey:@"mobile"];
    [params setObject:@"" forKey:@"xpoint"];
    [params setObject:@"" forKey:@"ypoint"];
    [params setObject:@"" forKey:@"monitorType"];
    [params setObject:@"" forKey:@"unifiedNumber"];
    [params setObject:@"" forKey:@"monPointNumber"];
    [params setObject:@"" forKey:@"resets"];
    [params setObject:@"" forKey:@"monPointDate"];
    [params setObject:@"" forKey:@"measuredData"];
    if (serialNum) {
        [params setObject:serialNum forKey:@"serialNo"];
    }
    if (mobile) {
        [params setObject:mobile forKey:@"mobile"];
    }
    if (longitude) {
        [params setObject:longitude forKey:@"xpoint"];
    }
    if (latitude) {
        [params setObject:latitude forKey:@"ypoint"];
    }
    [params setObject:[self valueOfType:type] forKey:@"monitorType"];
    if (unifiedNumber) {
        [params setObject:unifiedNumber forKey:@"unifiedNumber"];
    }
    if (monPointNumber) {
        [params setObject:monPointNumber forKey:@"monPointNumber"];
    }
    if (type == NDDataUploadRainFallMonitor) {
        if (reset) {
            [params setObject:@"1" forKey:@"resets"];
        } else {
            [params setObject:@"0" forKey:@"resets"];
        }
    }
    if (monPointDate) {
        [params setObject:monPointDate forKey:@"monPointDate"];
    }
    if (measuredData) {
        [params setObject:measuredData forKey:@"measuredData"];
    }
    if (image) {
        [NDNetwork uploadImageToResourceURL:NDAPI_Address(NDAPI_UPLOAD_DATA, NDApiTypeQCQF) images:@[image] fileNames:@[fileName] name:@"uploads" compressQulity:0.8 params:params NDCompletion:^(id content, NSInteger status, BOOL success, NSString *errorMsg) {
            if (status == 1) {
                if (completion) {
                    completion(status,true,@"");
                }
            } else {
                if (completion) {
                    completion(status,false,errorMsg);
                }
            }
        }];
    }else{
        [NDNetwork asycnRequestWithURL:NDAPI_Address(NDAPI_UPLOAD_DATA, NDApiTypeQCQF) params:params method:POST NDCompletion:^(id content, NSInteger status, BOOL success, NSString *errorMsg) {
            if (status == 1) {
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
+ (void)qcqfHistoryListType:(NDQCQFDetailType)type
                     mobile:(NSString *)mobile
                  startTime:(NSString *)startTime
                    endTime:(NSString *)endTime
                      disNo:(NSString *)disNo
                  monitorNo:(NSString *)monitorNo
                 completion:(void (^)(BOOL success, NSArray<NDQCQFDetailModel*> * array, NSString * str))completion{
    NSMutableDictionary * dicP = [NSMutableDictionary dictionary];
    [dicP setObject:@(type) forKey:@"monitorOrMacro"];
    [dicP setObject:mobile ? : @"" forKey:@"mobile"];
    [dicP setObject:startTime ? : @"" forKey:@"startTime"];
    [dicP setObject:endTime ? : @"" forKey:@"endTime"];
    [dicP setObject:disNo ? : @"" forKey:@"disNo"];
    [dicP setObject:monitorNo ? : @"" forKey:@"monitorNo"];
    [NDNetwork asycnRequestWithURL:NDAPI_Address(NDAPI_QCQF_HISTORY, NDApiTypeLog) params:dicP method:POST NDCompletion:^(id content, NSInteger status, BOOL success, NSString *errorMsg) {
        if (status == 200) {
            id info = [[content objectForKey:@"data"] mj_JSONObject];
            if ([info isKindOfClass:[NSArray class]] && [info count] > 0) {
                NSMutableArray<NDQCQFDetailModel *> * arrList = [NSMutableArray array];
                for (id obj in info) {
                    [arrList addObject:[NDQCQFDetailModel mj_objectWithKeyValues:obj]];
                }
                if (completion) {
                    completion(true, arrList, @"");
                }
            } else {
                if (completion) {
                    completion(true, @[], @"无相关历史记录");
                }
            }
        } else {
            if (completion) {
                completion(status,false,errorMsg);
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




//片区
+ (void)areaOfficer_SaveWeekLogByName:(NSString *)userName
                               member:(NSString *)member
                             phoneNum:(NSString *)phoneNum
                                units:(NSString *)units
                           jobContent:(NSString *)jobContent
                           recordTime:(NSString *)recordTime
                           completion:(void (^)(NSInteger, BOOL, NSString *))completion {
    NSMutableDictionary * dataDic = [NSMutableDictionary dictionary];
    [dataDic setObject:@"" forKey:@"member"];
    [dataDic setObject:phoneNum ? : @"" forKey:@"phoneNum"];
    [dataDic setObject:units ? : @"" forKey:@"units"];
    [dataDic setObject:recordTime ? : @"" forKey:@"recordTime"];
    [dataDic setObject:userName ? : @"" forKey:@"userName"];
    [dataDic setObject:jobContent ? : @"" forKey:@"jobContent"];
    
    NSMutableDictionary * dicp = [NSMutableDictionary dictionary];
    dicp[@"data"] = [dataDic mj_JSONString];
    
    [NDNetwork asycnRequestWithURL:NDAPI_Address(NDAPI_AREAOFFICER_SAVE_WEEK, NDApiTypeLog) params:dicp method:GET NDCompletion:^(id content, NSInteger status, BOOL success, NSString *errorMsg) {
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

+ (void)areaOfficer_WeekListByMobile:(NSString *)mobile
                          completion:(void (^)(BOOL, NSArray<NDAreaWeekModel *> *, NSString *))completion {
    NSMutableDictionary * dicp = [NSMutableDictionary dictionary];
    dicp[@"mobile"] = mobile ? mobile : @"";
    dicp[@"type"] = @"2";
    
    [NDNetwork asycnRequestWithURL:NDAPI_Address(NDAPI_DAILY_WEEK_LIST, NDApiCommonType) params:dicp method:POST NDCompletion:^(id content, NSInteger status, BOOL success, NSString *errorMsg) {
        if (status == 200) {
            id info = [[content objectForKey:@"data"] mj_JSONObject];
            if ([info isKindOfClass:[NSArray class]] && [info count]>0) {
                NSMutableArray * arrList = [NSMutableArray array];
                for (id obj in info) {
                    [arrList addObject:[NDAreaWeekModel mj_objectWithKeyValues:obj]];
                }
                if (completion) {
                    completion(true, arrList, @"");
                }
            } else {
                if (completion) {
                    completion(true, @[], @"无相关周报记录");
                }
            }
        } else {
            if (completion) {
                completion(status,false,errorMsg);
            }
        }
    }];
}



@end
