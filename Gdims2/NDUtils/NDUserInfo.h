//
//  NDUserInfo.h
//  Gdims2
//
//  Created by apple on 2018/3/5.
//  Copyright © 2018年 name. All rights reserved.
//

#import <Foundation/Foundation.h>
#define NDMOBILE_KEY        @"NDUserMobile"
#define NDUSER_TYPE_KEY     @"NDUserType"
#define NDUUSER_NAME        @"NDUserName"

@interface NDUserInfo : NSObject
@property(nonatomic,strong) NSString *mobile;
@property(nonatomic,strong) NSString *name;
@property (nonatomic, assign) NDUserType type;
@property (nonatomic, assign, readonly) NDRouterType routerType;
+ (instancetype)sharedInstance;
- (BOOL)hasCache;
- (void)loginOut:(void(^)(void))callBack;
@end
