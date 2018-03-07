//
//  NDLocationSettingViewController.m
//  Gdims2
//
//  Created by apple on 2018/3/7.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDLocationSettingViewController.h"

@interface NDLocationSettingViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtTime;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;

@end

@implementation NDLocationSettingViewController
+(NSInteger)cacheMinuteTime{
    NSString * time = [[NSUserDefaults standardUserDefaults] objectForKey:@"NDLocationDt"];
    if (time && time.length > 0) {
        return  time.integerValue;
    }
    return  60;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"定位设置";
    self.btnSave.backgroundColor = [UIColor nd_tintColor];
    [self configNavBarLeftMenuWithImage:@"zx_navback"];
    [NDLocationSettingViewController cacheMinuteTime];
    self.txtTime.text = [NSString stringWithFormat:@"%ld",(long)[NDLocationSettingViewController cacheMinuteTime]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnSaveClick:(id)sender {
    [self.view endEditing:true];
    NSString * text = self.txtTime.text;
    if (text && text.length > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:text forKey:@"ZXLocationDt"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [NDHUD MBShowSuccessInView:self.view text:@"已保存" delay:NDHUD_DELAY_TIME];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NDLocationTimeUpdate" object:nil];
    } else {
        [NDHUD MBShowFailureInView:self.view text:@"时间不能为空" delay:NDHUD_DELAY_TIME];
    }
}

-(void)leftMenuButtonAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#define NUMBERS @"0123456789"
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (range.location == 0 && string.length && [[string substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"0"]) {
        return false;
    }
    if (range.location > 3) {
        return false;
    }
    NSCharacterSet * cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
    NSString * filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];
    if(!basicTest) {
        return false;
    }
    return YES;
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
