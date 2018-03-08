//
//  NDHomePageViewController.m
//  Gdims2
//
//  Created by apple on 2018/3/5.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDHomePageViewController.h"
#import "NDQCQFViewController.h"
#import "NDAreaOfficerViewController.h"
#import "NDGarrisonManViewController.h"
#import "NDSettingViewController.h"
#import "NDLocationSettingViewController.h"

@interface NDHomePageViewController ()<NDSettingDelegate>
@property (nonatomic, strong) CLLocation * location;
@property (nonatomic, strong) NSTimer * timer;
@property(nonatomic,strong) NDQCQFViewController *qcqfModule;
@property(nonatomic,strong) NDAreaOfficerViewController *areaOfficeModule;
@property(nonatomic,strong) NDGarrisonManViewController *garrisonManModule;
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
        case NDRouterTypePQ:
            self.title =@"片区专管员";
            [self addChildViewController:self.areaOfficeModule];
            [self.view addSubview:self.areaOfficeModule.view];
            break;
        case NDRouterTypeZS:
            self.title =@"驻守人员";
            [self addChildViewController:self.garrisonManModule];
            [self.view addSubview:self.garrisonManModule.view];
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
    if (_garrisonManModule) {
        _garrisonManModule.view.frame = oFrame;
    }
    if (_areaOfficeModule) {
        _areaOfficeModule.view.frame = oFrame;
    }
    
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
-(NDGarrisonManViewController *)garrisonManModule{
    if (_garrisonManModule == nil) {
        _garrisonManModule = [[NDGarrisonManViewController alloc] init];
    }
    return _garrisonManModule;
}

- (NDAreaOfficerViewController *)areaOfficeModule {
    if (_areaOfficeModule == nil) {
        _areaOfficeModule = [[NDAreaOfficerViewController alloc] init];
    }
    return _areaOfficeModule;
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
//    if (_garrisonManModule) {
//        _garrisonManModule.location = self.location;
//    }
//    if (_areaOfficerModule) {
//        _areaOfficerModule.location = self.location;
//    }
//    if (_groundStationModule) {
//        _groundStationModule.location = self.location;
//    }
}

@end
