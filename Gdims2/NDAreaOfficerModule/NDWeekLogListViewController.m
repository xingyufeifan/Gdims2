//
//  NDWeekLogListViewController.m
//  Gdims2
//
//  Created by 包宏燕 on 2018/3/7.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDWeekLogListViewController.h"
#import "NDWeekLogUploadViewController.h"
#import "NDAreaWeekModel.h"
#import "NDDailyListCell.h"

#import <MJRefresh/MJRefresh.h>

@interface NDWeekLogListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tabList;

@property (nonatomic, strong) NSArray<NDAreaWeekModel *> * arrWeekLogList;

@end

@implementation NDWeekLogListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"已上报周报";
    
    self.tabList.backgroundColor = [UIColor clearColor];
    [self.tabList registerNib:[UINib nibWithNibName:@"NDDailyListCell" bundle:nil] forCellReuseIdentifier:@"NDDailyListCell"];
    self.tabList.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(nd_refreshAction)];
    [self.tabList.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)nd_refreshAction {
    [NDRequestApi areaOfficer_WeekListByMobile:[NDUserInfo sharedInstance].mobile completion:^(BOOL success, NSArray<NDAreaWeekModel *> *list, NSString *errorMsg) {
        [self.tabList.mj_header endRefreshing];
        if (success) {
            self.arrWeekLogList = list;
            if (self.arrWeekLogList == nil || self.arrWeekLogList.count == 0) {
                [NDHUD MBShowFailureInView:self.view text:@"无相关周报" delay:NDHUD_DELAY_TIME];
            }
            [self.tabList reloadData];
        } else {
            [NDHUD MBShowFailureInView:self.view text:errorMsg delay:NDHUD_DELAY_TIME];
        }
    }];
}

#pragma mark - UITableView

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NDWeekLogUploadViewController * logUploadVC = [[NDWeekLogUploadViewController alloc] init];
    logUploadVC.model = self.arrWeekLogList[indexPath.row];
    logUploadVC.type = NDWeekLogVCTypeReview;
    [self.navigationController pushViewController:logUploadVC animated:true];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NDDailyListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"NDDailyListCell" forIndexPath:indexPath];
    NDAreaWeekModel * model = self.arrWeekLogList[indexPath.row];
    cell.lbIndex.text = model.id;
    cell.lbUserName.text = model.user_name;
    cell.lbUploadTime.text = model.record_time;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section  {
    if (self.arrWeekLogList && self.arrWeekLogList.count) {
        return self.arrWeekLogList.count;
    }
    return 0;
}

@end
