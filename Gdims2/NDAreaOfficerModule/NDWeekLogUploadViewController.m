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

@property (weak, nonatomic) IBOutlet UIButton *btnUpload;
@property (weak, nonatomic) IBOutlet UITableView *tabList;

@property (nonatomic, strong) UITextView * textLog;
@property (nonatomic, strong) NDAreaWeekModel * memberInfo;

@end

@implementation NDWeekLogUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)uploadAction:(id)sender {
    
    
    
}

#pragma mark - Navigation


@end
