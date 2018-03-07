//
//  NDAreaOfficerViewController.m
//  Gdims2
//
//  Created by 包宏燕 on 2018/3/6.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDAreaOfficerViewController.h"

@interface NDAreaOfficerViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tabList;
@property (weak, nonatomic) IBOutlet UIButton *btnVideoUpload;

@end

@implementation NDAreaOfficerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.btnVideoUpload.backgroundColor = [UIColor nd_tintColor];
    self.btnVideoUpload.layer.cornerRadius = 5;
    
    self.tabList.backgroundColor = [UIColor clearColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

/*
 * 应急视频按钮点击事件
 */
- (IBAction)videoUploadAction:(id)sender {
    
}

#pragma mark - UITableView




@end
