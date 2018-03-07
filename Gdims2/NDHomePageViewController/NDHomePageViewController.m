//
//  NDHomePageViewController.m
//  Gdims2
//
//  Created by apple on 2018/3/5.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDHomePageViewController.h"
#import "NDQCQFViewController.h"
#import "NDSettingViewController.h"
#import "NDLocationSettingViewController.h"
@interface NDHomePageViewController ()<NDSettingDelegate>
@property (nonatomic, strong) CLLocation * location;
@property (nonatomic, strong) NSTimer * timer;
@property(nonatomic,strong) NDQCQFViewController *qcqfModule;
@property(nonatomic,strong) NDSettingViewController *settingVC;
@end

@implementation NDHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.location = nil;
    //创建缓存路径
    [NDFileUtils loadPath];
    //定位时间间隔修改
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loactionTimeUpdated) name:@"NDLocationTimeUpdate" object:nil];
    NSInteger minute = [NDLocationSettingViewController cacheMinuteTime];
    _timer = [NSTimer scheduledTimerWithTimeInterval: minute * 60 target:self selector:@selector(uploadLocationInbackground) userInfo:nil repeats:true];
    [self configNavBarLeftMenuWithImage:@"zx_menu"];
    [self showHotLineButton];
    switch (self.routerType) {
        case NDRouterTypeQCQF:
            self.title =@"灾害点列表";
            [self addChildViewController:self.qcqfModule];
            [self.view addSubview:self.qcqfModule.view];
            break;
            
        default:
            break;
    }
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!self.onceLoad) {
        self.onceLoad = true;
        [self preLoad];
        [_timer setFireDate:[NSDate date]];
//        [ZXRouter checkVideoCallAction];
//        [CloudPushSDK bindAccount:[ZXUserInfo shareInstance].mobile withCallback:^(CloudPushCallbackResult *res) {
//            if (res.success) {
//                NSLog(@"绑定推送成功");
//            } else {
//                NSLog(@"绑定推送失败");
//            }
//        }];
    }
}
- (void)preLoad{
    //定位信息检测
    [NDLocationUtils checkService:^(BOOL success, NSString *errorMsg) {
        if (success) {
            [[NDLocationUtils shareInstance] checkCurrentLocation:^(BOOL success, CLLocation *location) {
                if (success) {
                    self.location = location;
                    [self updateSubVCLocations];
                }
            }];
        } else {
            [NDLocationUtils showOpenSettingUp:self];
        }
    }];
}
/**
 定位时间周期变化
 */
- (void)loactionTimeUpdated {
    NSInteger minute = [NDLocationSettingViewController cacheMinuteTime];
    [_timer invalidate];
    _timer = nil;
    _timer = [NSTimer scheduledTimerWithTimeInterval: minute * 60 target:self selector:@selector(uploadLocationInbackground) userInfo:nil repeats:true];
    [_timer setFireDate:[NSDate date]];
}
/**
 后台上传定位数据
 */
- (void)uploadLocationInbackground{
    [NDLocationUtils checkService:^(BOOL success, NSString *errorMsg) {
        if (success) {
            [[NDLocationUtils shareInstance] checkCurrentLocation:^(BOOL success, CLLocation *location) {
                self.location = location;
                [NDRequestApi uploadLoactionWithLatitude:[NSString stringWithFormat:@"%f",location.coordinate.latitude] longitude:[NSString stringWithFormat:@"%f",location.coordinate.longitude] phone:[NDUserInfo sharedInstance].mobile userType:[NDUserInfo sharedInstance].type  completion:^(NSInteger status, BOOL success, NSString *errorMsg) {
                    if (success) {
                        NSLog(@"定位上传成功");
                    }
                }];
            }];
        }
    }];
}

- (void)viewDidLayoutSubviews{
    CGRect oFrame = self.view.frame;
    oFrame.origin.x = 0;
    oFrame.origin.y = 0;
    if (_qcqfModule) {
        _qcqfModule.view.frame = oFrame;
    }
//    if (_garrisonModule) {
//        _garrisonModule.view.frame = oFrame;
//    }
//    if (_areaOfficerModule) {
//        _areaOfficerModule.view.frame = oFrame;
//    }
//    if (_groundStationModule) {
//        _groundStationModule.view.frame = oFrame;
//    }
}

-(NDQCQFViewController *)qcqfModule{
    if (_qcqfModule == nil) {
        _qcqfModule = [[NDQCQFViewController alloc] init];
    }
    return _qcqfModule;
}
-(NDSettingViewController *)settingVC{
    if (_settingVC == nil) {
        _settingVC = [[NDSettingViewController alloc] init];
        _settingVC.delegate = self;
    }
    return _settingVC;
}
-(void)leftMenuButtonAction{
    [self presentViewController:self.settingVC animated:YES completion:nil];
}
-(void)ndSettingViewControllerDismissed{
    
}
- (void)updateSubVCLocations {
    if (_qcqfModule) {
        _qcqfModule.location = self.location;
    }
//    if (_garrisonModule) {
//        _garrisonModule.location = self.location;
//    }
//    if (_areaOfficerModule) {
//        _areaOfficerModule.location = self.location;
//    }
//    if (_groundStationModule) {
//        _groundStationModule.location = self.location;
//    }
}

@end
