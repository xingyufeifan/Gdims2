//
//  NDLocationUtils.m
//  Gdims2
//
//  Created by 包宏燕 on 2018/3/6.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDLocationUtils.h"
#import <JZLocationConverter/JZLocationConverter.h>

static NDLocationUtils * ndLocation = nil;

@implementation NDLocationUtils
{
    CLLocationManager * locationManager;
    BOOL located;
}

+ (instancetype)shareInstance {
    if (!ndLocation) {
        ndLocation = [[NDLocationUtils alloc] init];
    }
    return ndLocation;
}

- (void)checkCurrentLocation:(NDCheckLocation)completion {
    located = false;
    _checkEnd = completion;
    [locationManager startUpdatingLocation];
}

+ (void)checkService:(void (^)(BOOL, NSString *))completion {
    if ([CLLocationManager locationServicesEnabled]) {
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        if (status == kCLAuthorizationStatusDenied ||
            status == kCLAuthorizationStatusRestricted) {
            if (completion) {
                completion(false, @"定位服务不可用");
            }
        } else {
            if (completion) {
                completion(true, nil);
            }
        }
    } else {
        if (completion) {
            completion(false, @"定位服务不可用");
        }
    }
}

- (instancetype)init {
    if (self = [super init]) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        [locationManager requestWhenInUseAuthorization];
        [locationManager requestAlwaysAuthorization];
        located = false;
    }
    return self;
}

#pragma mark - LocationDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if (_checkEnd) {
        _checkEnd(false, nil);
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if (located) {
        return;
    }
    located = true;
    [manager stopUpdatingLocation];
    
    CLLocation * location = [locations lastObject];
    CLLocationCoordinate2D coordinate = [JZLocationConverter wgs84ToBd09:location.coordinate];
    if (_checkEnd) {
        _checkEnd(true, [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude]);
    }
}

+ (void)showOpenSettingUp:(UIViewController *)vc {
    float sysVersion = [[UIDevice currentDevice].systemVersion floatValue];
    if (sysVersion > 8.0) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您拒绝了定位权限，将无法上传定位信息，是否马上开启?" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
        }]];
        [vc presentViewController:alert animated:true completion:nil];
        
    } else {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请在 '系统设置|隐私|定位' 中开启定位访问权限" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [vc presentViewController:alert animated:true completion:nil];
    }
}

@end
