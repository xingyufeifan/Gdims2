//
//  NDViewController.m
//  Gdims2
//
//  Created by apple on 2018/3/5.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDViewController.h"

@interface NDViewController ()

@end

@implementation NDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.onceLoad = NO;
    self.view.backgroundColor = [UIColor nd_backgroundColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)nd_refreshAction{
    
}
-(void)configNavBarLeftMenuWithImage:(NSString *)imgName{
    UIImage *image = [UIImage imageNamed:imgName];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(leftMenuButtonAction)];
    [self.navigationItem setLeftBarButtonItem:item];
}
-(void)showHotLineButton{
    UIImage *image = [UIImage imageNamed:@"zx_tel"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(rightMenuButtonAction)];
    [self.navigationItem setRightBarButtonItem:item];
}

- (void)leftMenuButtonAction{
    
}

- (void)rightMenuButtonAction{
    //todo 服务电话
    [NDHUD MBShowLoadingInView:self.view text:ND_LOADING_TEXT delay:0];
    [NDRequestApi getHotLine:^(BOOL success, NSString *message) {
        [NDHUD MBHideForView:self.view animate:YES];
        if (success) {
            [self showCallTel:message];
        } else {
            [NDHUD MBShowFailureInView:self.view text:message delay:NDHUD_DELAY_TIME];
        }
    }];
}
- (void)showCallTel:(NSString *)tel{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否发起电话帮助？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",tel]]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",tel]] options:@{} completionHandler:nil];
        [self setNeedsStatusBarAppearanceUpdate];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self setNeedsStatusBarAppearanceUpdate];
    }];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [self presentViewController:alertController animated:YES completion:nil];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
//是否隐藏状态栏
- (BOOL)prefersStatusBarHidden {
    return  false;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)shouldAutorotate {
    return false;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
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
