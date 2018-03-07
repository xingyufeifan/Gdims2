//
//  NDAreaOfficerViewController.m
//  Gdims2
//
//  Created by 包宏燕 on 2018/3/6.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDAreaOfficerViewController.h"
#import "NDWeekLogUploadViewController.h"
#import "NDWeekLogListViewController.h"
#import "NDMenuCell.h"

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
    [self.tabList registerNib:[UINib nibWithNibName:@"NDMenuCell" bundle:nil] forCellReuseIdentifier:@"NDMenuCell"];
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: //工作周报填报
        {
            NDWeekLogUploadViewController * weekLogUploadVC = [[NDWeekLogUploadViewController alloc] init];
            weekLogUploadVC.model = nil;
            weekLogUploadVC.type = NDWeekLogVCTypeUpload;
            
            [self.navigationController pushViewController:weekLogUploadVC animated:true];
        }
            break;
        case 1: //周报上报情况
        {
            NDWeekLogListViewController * weekLogListVC = [[NDWeekLogListViewController alloc] init];
            [self.navigationController pushViewController:weekLogListVC animated:true];
        }
            break;
        default:
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NDMenuCell * cell = [tableView dequeueReusableCellWithIdentifier:@"NDMenuCell" forIndexPath:indexPath];
    switch (indexPath.row) {
        case 0:
            cell.lbTitle.text = @"工作周报填报";
            cell.icImage.image = [UIImage imageNamed:@"zx-log-input"];
            break;
        case 1:
            cell.lbTitle.text = @"周报上报情况";
            cell.icImage.image = [UIImage imageNamed:@"zx-log-list"];
            break;
        default:
            break;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

@end
