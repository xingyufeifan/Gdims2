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
@interface NDHomePageViewController ()<NDSettingDelegate>
@property(nonatomic,strong) NDQCQFViewController *qcqfModule;
@property(nonatomic,strong) NDSettingViewController *settingVC;
@end

@implementation NDHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
-(void)viewDidLayoutSubviews{
    CGRect oFrame = self.view.frame;
    oFrame.origin.x = 0;
    oFrame.origin.y = 0;
    if (_qcqfModule) {
        _qcqfModule.view.frame = oFrame;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
