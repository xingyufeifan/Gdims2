//
//  NDNetwork.m
//  Gdims2
//
//  Created by apple on 2018/3/5.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDNetwork.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#define NDAPI_FORMAT_ERROR     900900   //接口返回数据非json字典
#define NDAPI_TIMEOUT_INTREVAL     30   //接口超时时间
#define NDAPI_HTTP_TIME_OUT     -1001   //请求超时
#define NDAPI_HTTP_ERROR       900901   //HTTP请求失败
#define ND_SHOW_LOG                 1
extern NSString * NDAPI_Address(NSString * module,NDApiType apiType){
    NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@:%@",NDROOT_URL1,NDPORT1];
    switch (apiType) {
        case NDApiTypeQCQF:
            urlStr = [NSMutableString stringWithFormat:@"%@:%@",NDROOT_URL1,NDPORT1];
            break;
        case NDApiCommonType:
            urlStr = [NSMutableString stringWithFormat:@"%@:%@",NDROOT_URL2,NDPORT2];
            break;
        case NDApiTypeLog:
            urlStr = [NSMutableString stringWithFormat:@"%@:%@",NDROOT_URL3,NDPORT3];
            break;
        default:
            break;
    }
    [urlStr appendString:module];
    return urlStr;

}
@implementation NDNetwork
+(void)commonProcess:(id)content NDCompletion:(NDRequestCompletion)completion{
    if (ND_SHOW_LOG) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:content options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"接口返回数据:\n%@",str);
        NSLog(@"------------结束------------");
    }
    if ([content isKindOfClass:[NSDictionary class]]) {
        NSInteger status = 0;
        if ([content objectForKey:@"result"]) {
            status = [content[@"result"] integerValue];
        } else if ([content objectForKey:@"status"]) {
            status = [content[@"status"] integerValue];
        }
        NSString * errorMsg = content[@"info"];
        if (!errorMsg) {
            errorMsg = content[@"message"];
        }
        if (completion) {
            completion(content,status,true,errorMsg);
        }
    } else {
        if (completion) {
            completion(content,NDAPI_FORMAT_ERROR,false,@"接口数据格式错误");
        }
    }
}
+(void)httpError:(NSError *)error NDCompletion:(NDRequestCompletion)completion{
    if (ND_SHOW_LOG) {
        NSLog(@"接口错误返回数据:\n%@",error);
        NSLog(@"------------结束------------");
    }
    if (completion) {
        if (error.code == NDAPI_HTTP_TIME_OUT) {
            completion(error,NDAPI_HTTP_TIME_OUT,false,@"访问超时,请稍后再试");
        } else {
            completion(error,NDAPI_HTTP_ERROR,false,@"此时无法访问服务器");
        }
    }
}

+ (NSURLSessionDataTask *)uploadImageToResourceURL:(NSString *)resourceURL
                                            images:(NSArray *)images
                                         fileNames:(NSArray<NSString *> *)fileNames
                                              name:(NSString *)name
                                    compressQulity:(float)qulity
                                            params:(NSDictionary *)params
                                      NDCompletion:(NDRequestCompletion)completion{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = NDAPI_TIMEOUT_INTREVAL;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    if (ND_SHOW_LOG) {
        NSLog(@"------------uploadImageToResourceURL开始------------");
        NSLog(@"请求地址:%@",resourceURL);
        NSLog(@"请求参数:\n%@",params);
    }
    NSURLSessionDataTask * task = [manager POST:resourceURL parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        NSInteger count = [images count];
        for (NSInteger idx = 0; idx < count; idx ++) {
            UIImage *  image = images[idx];
            NSString * fileName = nil;
            if (idx < fileNames.count) {
                fileName = fileNames[idx];
            }
            if (fileName == nil) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat =@"yyyyMMddHHmmssSSS";
                NSString * str = [formatter stringFromDate:[NSDate date]];
                fileName = [NSString stringWithFormat:@"%@.jpg", str];
            }
            [formData appendPartWithFileData:UIImageJPEGRepresentation(image, qulity)
                                        name:name
                                    fileName:fileName
                                    mimeType:@"image/jpeg"];
        }
    } progress:^(NSProgress *_Nonnull uploadProgress) {
        //打印下上传进度
    } success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        //上传成功
        [self commonProcess:responseObject NDCompletion:completion];
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
        //上传失败
        [self httpError:error NDCompletion:completion];
    }];
    return task;
}


+(NSURLSessionDataTask *)asycnRequestWithURL:(NSString *)url
                                      params:(NSDictionary *)params
                                      method:(NDRequestMethodType)method
                                      NDCompletion:(NDRequestCompletion)completion{
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = NDAPI_TIMEOUT_INTREVAL;
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    NSURLSessionDataTask * task = nil;
    if (ND_SHOW_LOG) {
        NSLog(@"-------------------asycnRequestWithURL请求开始------------------");
        NSLog(@"请求参数:%@",params);
        NSLog(@"请求地址:%@",url);
    }
    switch (method) {
        case GET:
        {
            task = [manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self commonProcess:responseObject NDCompletion:completion];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self httpError:error NDCompletion:completion];
            }];
        }
            break;
        case POST:
        {
            task = [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self commonProcess:responseObject NDCompletion:completion];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self httpError:error NDCompletion:completion];
            }];
        }
            break;
        default:
            break;
    }
    return task;
}

+ (NSURLSessionDataTask *)uploadVideoToResourceURL:(NSString *)resourceURL
                                            videos:(NSArray<NSData *> *)videos
                                         fileNames:(NSArray<NSString *> *)fileNames
                                            params:(NSDictionary *)params
                                      NDCompletion:(NDRequestCompletion)completion{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = NDAPI_TIMEOUT_INTREVAL;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"text/plain",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    if (ND_SHOW_LOG) {
        NSLog(@"------------uploadVideoToResourceURL开始------------");
        NSLog(@"请求地址:%@",resourceURL);
        NSLog(@"请求参数:\n%@",params);
    }
    NSURLSessionDataTask * task = [manager POST:resourceURL parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        NSInteger count = [videos count];
        for (NSInteger idx = 0; idx < count; idx ++) {
            NSData *  data = videos[idx];
            NSString * fileName = nil;
            if (idx < fileNames.count) {
                fileName = fileNames[idx];
            }
            if (fileName == nil) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat =@"yyyyMMddHHmmssSSS";
                NSString * str = [formatter stringFromDate:[NSDate date]];
                fileName = [NSString stringWithFormat:@"%@.mp4", str];
            }
            [formData appendPartWithFileData:data
                                        name:@"file"
                                    fileName:fileName
                                    mimeType:@"video/mp4"];
            
        }
    } progress:^(NSProgress *_Nonnull uploadProgress) {
        //打印下上传进度
    } success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        //上传成功
        [self commonProcess:responseObject NDCompletion:completion];
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
        //上传失败
        [self httpError:error NDCompletion:completion];
    }];
    return task;
}
@end
