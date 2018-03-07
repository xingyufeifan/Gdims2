//
//  NDGarrisonManViewController.m
//  Gdims2
//
//  Created by 李青松 on 2018/3/6.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDGarrisonManViewController.h"
#import "NDDailyUploadViewController.h"
#import "NDDisasterUploadViewController.h"
#import "NDDailyListViewController.h"
#import "NDMenuCell.h"

@interface NDGarrisonManViewController ()
<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tblList;
@property (weak, nonatomic) IBOutlet UIButton *btnVideoUpload;

@end

@implementation NDGarrisonManViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btnVideoUpload.backgroundColor = [UIColor nd_tintColor];
    self.btnVideoUpload.layer.cornerRadius = 5;
    self.tblList.backgroundColor = [UIColor clearColor];
    [self.tblList registerNib:[UINib nibWithNibName:@"NDMenuCell" bundle:nil] forCellReuseIdentifier:@"NDMenuCell"];
}
- (IBAction)videoUpload:(id)sender {
    
}
#pragma mark - UITableView
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            NDDailyUploadViewController * dailyUploadVC = [[NDDailyUploadViewController alloc] init];
            dailyUploadVC.model = nil;
            dailyUploadVC.type = NDDailyVCTypeUpload;
            [self.navigationController pushViewController:dailyUploadVC animated:true];
        }
            break;
        case 1:
        {
            NDDisasterUploadViewController * disasterUploadVC = [[NDDisasterUploadViewController alloc] init];
            [self.navigationController pushViewController:disasterUploadVC animated:true];
            
        }
            break;
        case 2:
        {
            NDDailyListViewController * dailyListVC = [[NDDailyListViewController alloc] init];
            [self.navigationController pushViewController:dailyListVC animated:true];
            
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
            cell.lbTitle.text = @"日志填报";
            cell.icImage.image = [UIImage imageNamed:@"zx-daily-icon"];
            break;
        case 1:
            cell.lbTitle.text = @"灾情速报";
            cell.icImage.image = [UIImage imageNamed:@"zx-log-input"];
            break;
        case 2:
            cell.lbTitle.text = @"日志上报情况";
            cell.icImage.image = [UIImage imageNamed:@"zx-log-list"];
            break;
        default:
            break;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}





@end
