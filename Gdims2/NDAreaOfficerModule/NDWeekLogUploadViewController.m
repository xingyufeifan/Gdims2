//
//  NDWeekLogUploadViewController.m
//  Gdims2
//
//  Created by 包宏燕 on 2018/3/7.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDWeekLogUploadViewController.h"
#import "NDAreaWeekModel.h"

@interface NDWeekLogUploadViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

@property (nonatomic, strong) UITextView * textLog;
@property (nonatomic, strong) NDAreaWeekModel * memberInfo;

@end

@implementation NDWeekLogUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

@end
