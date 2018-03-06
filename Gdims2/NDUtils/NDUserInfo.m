//
//  NDUserInfo.m
//  Gdims2
//
//  Created by apple on 2018/3/5.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDUserInfo.h"

static NDUserInfo * userInfo = nil;
@implementation NDUserInfo
+(instancetype)sharedInstance{
    if (userInfo == nil) {
        userInfo = [[NDUserInfo alloc] init];
        [userInfo active];
    }
    return userInfo;
}

-(NDRouterType)routerType{
    switch (self.type) {
        case NDUserTypeQCQF:
            return NDRouterTypeQCQF;
            break;
        case NDUserTypeZS:
            return NDRouterTypeZS;
            break;
        case NDUserTypePQ:
            return NDRouterTypePQ;
            break;
        default:
            break;
    }
    return 0;
}
- (void)active{
    id mobile = [[NSUserDefaults standardUserDefaults] objectForKey:NDMOBILE_KEY];
    if([mobile isKindOfClass:[NSString class]] && [mobile length] > 0){
        _mobile = mobile;
    }
    
    id type = [[NSUserDefaults standardUserDefaults] objectForKey:NDUSER_TYPE_KEY];
    if ([type isKindOfClass:[NSString class]] && [type length] > 0) {
        _type = [type integerValue];
    }
}
- (BOOL)hasCache{
    if (self.mobile.length > 0) {
        return true;
    }else{
        return false;
    }
}
- (void)setMobile:(NSString *)mobile{
    _mobile = mobile;
    [[NSUserDefaults standardUserDefaults] setObject:mobile forKey:NDMOBILE_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setType:(NDUserType)type{
    _type = type;
    [[NSUserDefaults standardUserDefaults] setInteger:type forKey:NDUSER_TYPE_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)loginOut:(void (^)(void))callBack{
    self.mobile = nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:NDMOBILE_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:NDUSER_TYPE_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (callBack) {
        callBack();
    }
}
@end
