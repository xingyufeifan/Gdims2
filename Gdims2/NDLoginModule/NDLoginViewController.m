//
//  NDLoginViewController.m
//  Gdims2
//
//  Created by apple on 2018/3/2.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDLoginViewController.h"

@interface NDLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtMobile;
@property (weak, nonatomic) IBOutlet UISegmentedControl *scLoginType;
- (IBAction)btnLoginClick;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;

@end

@implementation NDLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.txtMobile.layer.cornerRadius = 5;
    self.txtMobile.layer.borderWidth = 1.0;
    self.txtMobile.attributedPlaceholder = [[NSAttributedString alloc]
                                            initWithString:@"请输入手机号"
                                            attributes:
                                            @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.txtMobile.layer.borderColor = [UIColor whiteColor].CGColor;
    self.btnLogin.layer.cornerRadius = 10;
    self.btnLogin.layer.borderWidth = 1;
    self.btnLogin.layer.masksToBounds = YES;
    self.btnLogin.backgroundColor = [UIColor nd_buttonColor];
    self.scLoginType.tintColor = [UIColor nd_tintColor];
    [self.scLoginType setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateNormal];
    [self.scLoginType setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateSelected];
    [self.txtMobile becomeFirstResponder];
    id mobile = [[NSUserDefaults standardUserDefaults] objectForKey:NDMOBILE_KEY];
    if ([mobile isKindOfClass:[NSString class]] && [mobile length] > 0) {
        self.txtMobile.text = mobile;
    }
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnLoginClick {
    [self checkLogin];
}
- (void)checkLogin{
    [self.txtMobile endEditing:YES];
    NSString *mobile = self.txtMobile.text;
    NDUserType type = [self typeFromSegmentControl];
    if (mobile != nil && mobile.length == 11 ) {
        [NDHUD MBShowLoadingInView:self.view text:@"正在登录..." delay:0];
        [NDRequestApi loginWithMobile:mobile userType:type completion:^(BOOL success, NSString * msg) {
            [NDHUD MBHideForView:self.view animate:YES];
            if(success){
                [NDHUD MBShowSuccessInView:self.view text:msg delay:NDHUD_DELAY_TIME];
                [[NDUserInfo sharedInstance] setType:type];
                [[NDUserInfo sharedInstance] setMobile:mobile];
                //跳转
                [NDRouter setRootViewWithType:[[NDUserInfo sharedInstance] routerType]];
            }else{
                [NDHUD MBShowFailureInView:self.view text:msg delay:NDHUD_DELAY_TIME];
            }
        }];
    }else{
        [NDHUD MBShowFailureInView:self.view text:@"请将手机号填写完整" delay:NDHUD_DELAY_TIME];
    }
}
- (NDUserType)typeFromSegmentControl {
    switch (self.scLoginType.selectedSegmentIndex) {
        case 0:
            return NDUserTypeQCQF;
            break;
        case 1:
            return NDUserTypeZS;
            break;
        case 2:
            return NDUserTypePQ;
            break;
        default:
            break;
    }
    return -1;
}
@end
