//
//  NDLocationUtils.h
//  Gdims2
//
//  Created by 包宏燕 on 2018/3/6.
//  Copyright © 2018年 name. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void(^NDCheckLocation) (BOOL success, CLLocation * location);

@interface NDLocationUtils : NSObject<CLLocationManagerDelegate>

@property (nonatomic, copy)NDCheckLocation checkEnd;

+ (instancetype)shareInstance;

- (void)checkCurrentLocation: (NDCheckLocation)completion;

+ (void)checkService: (void(^)(BOOL success, NSString * errorMsg))completion;

+ (void)showOpenSettingUp: (UIViewController *)vc;

@end
