//
//  NDNetwork.h
//  Gdims2
//
//  Created by apple on 2018/3/5.
//  Copyright © 2018年 name. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum :NSUInteger{
    NDApiTypeQCQF = 1,  //群测群防 功能即可
    NDApiCommonType = 2,// 其他
    NDApiTypeLog = 3    //日志上报
}NDApiType;
/**构造完整接口地址*/
extern NSString * NDAPI_Address(NSString * module,NDApiType apiType);
typedef enum: NSUInteger{
    GET,
    POST
}NDRequestMethodType;
/**content：接口返回的原始数据
 * code:    从接口解析的状态码
 * success: true:接口访问成功（不代表code = 0） false 接口访问失败
 * errorMsg: 接口错误信息，取值于接口msg字段
 */
typedef void(^NDRequestCompletion)(id content,NSInteger status,BOOL success,NSString * errorMsg);

@interface NDNetwork : NSObject
/**请求成功回调方法*/
+ (void)commonProcess:(id)content NDCompletion:(NDRequestCompletion)completion;
/**请求失败回调方法*/
+ (void)httpError:(NSError *)error NDCompletion:(NDRequestCompletion)completion;

/**
 *  异步接口请求
 *
 *  @param url          接口地址
 *  @param params       接口参数
 *  @param method       请求方式 GET POST DELETE
 *  @param zxCompletion 接口请求完成回调
 */

+ (NSURLSessionDataTask *)asycnRequestWithURL:(NSString *)url
                                       params:(NSDictionary *)params
                                       method:(NDRequestMethodType)method
                                 NDCompletion:(NDRequestCompletion)zxCompletion;
@end
