//
//  NDDailyListViewController.m
//  Gdims2
//
//  Created by 李青松 on 2018/3/6.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDDailyListViewController.h"
#import "NDDailyUploadViewController.h"
#import "NDGarrisonModel.h"
#import "NDDailyListCell.h"

@interface NDDailyListViewController ()
 <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *topMenuView;
@property (weak, nonatomic) IBOutlet UIView *vHUD;
@property (weak, nonatomic) IBOutlet UIButton *btnUnUpload;
@property (weak, nonatomic) IBOutlet UIButton *btnUploaded;
@property (weak, nonatomic) IBOutlet UITableView *tblList;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hudLeftOffset;

@property (nonatomic, assign) BOOL isAnimating;

@property (nonatomic,strong) NSArray<NDGarrisonDailyModel *> * arrNativeList;
@property (nonatomic,strong) NSArray<NDGarrisonDailyModel *> * arrRemoteList;

@property (nonatomic,assign) NSInteger segIndex;
@end

@implementation NDDailyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"日志情况";
    
    self.hudLeftOffset.constant = 0;
    [self.btnUnUpload setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnUnUpload setTitleColor:[UIColor nd_tintColor] forState:UIControlStateHighlighted];
    [self.btnUnUpload setTitleColor:[UIColor nd_tintColor] forState:UIControlStateSelected];
    
    [self.btnUploaded setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnUploaded setTitleColor:[UIColor nd_tintColor] forState:UIControlStateHighlighted];
    [self.btnUploaded setTitleColor:[UIColor nd_tintColor] forState:UIControlStateSelected];
    self.segIndex = 0;
    self.btnUnUpload.selected = true;
    self.isAnimating = false;
    
    [self.tblList registerNib:[UINib nibWithNibName:@"NDDailyListCell" bundle:nil] forCellReuseIdentifier:@"NDDailyListCell"];
    
    self.tblList.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(nd_refreshAction)];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.segIndex == 0) {
        self.arrNativeList = [NDGarrisonDailyModel cacheList];
        if (self.arrNativeList.count == 0) {
            [NDHUD MBShowFailureInView:self.view text:@"无相关保存记录" delay:NDHUD_DELAY_TIME];
        }
        [self.tblList reloadData];
    }
}

- (void)nd_refreshAction {
    if (self.segIndex == 1) {
        [NDRequestApi garrison_DaliyListByMobile:[NDUserInfo sharedInstance].mobile completion:^(BOOL success, NSArray<NDGarrisonDailyModel *> *list, NSString *errorMsg) {
            [self.tblList.mj_header endRefreshing];
            if (success) {
                self.arrRemoteList = list;
                if (self.arrRemoteList == nil || self.arrRemoteList.count == 0) {
                    [NDHUD MBShowFailureInView:self.view text:@"无相关数据" delay:NDHUD_DELAY_TIME];
                }
                [self.tblList reloadData];
            } else {
                [NDHUD MBShowFailureInView:self.view text:errorMsg delay:NDHUD_DELAY_TIME];
            }
        }];
    } else {
        [self.tblList.mj_header endRefreshing];
        self.arrNativeList = [NDGarrisonDailyModel cacheList];
        if (self.arrNativeList.count == 0) {
            [NDHUD MBShowFailureInView:self.view text:@"无相关保存记录" delay:NDHUD_DELAY_TIME];
        }
        [self.tblList reloadData];
    }
}

- (IBAction)unUploadAction:(id)sender {
    if (_isAnimating || self.btnUnUpload.selected) {
        return;
    }
    _isAnimating = true;
    self.btnUnUpload.selected = true;
    self.btnUploaded.selected = false;
    self.segIndex = 0;
    self.hudLeftOffset.constant = 0;
    [UIView animateWithDuration:0.35 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        _isAnimating = false;
    }];
    [self.tblList reloadData];
    
}

- (IBAction)uploadedAction:(id)sender {
    if (_isAnimating || self.btnUploaded.selected) {
        return;
    }
    _isAnimating = true;
    if (!self.onceLoad) {
        self.onceLoad = true;
        [self.tblList.mj_header beginRefreshing];
    }
    self.btnUnUpload.selected = false;
    self.btnUploaded.selected = true;
    self.segIndex = 1;
    self.hudLeftOffset.constant = [UIScreen mainScreen].bounds.size.width / 2.0;
    [UIView animateWithDuration:0.35 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        _isAnimating = false;
    }];
    [self.tblList reloadData];
    
}

#pragma mark - UITableView

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.segIndex) {
        case 0://未上报
        {
            NDDailyUploadViewController * dailyUpload = [[NDDailyUploadViewController alloc] init];
            dailyUpload.model = self.arrNativeList[indexPath.row];
            dailyUpload.type = NDDailyVCTypeNativeReview;
            [self.navigationController pushViewController:dailyUpload animated:true];
        }
            break;
        case 1://已上报
        {
            NDDailyUploadViewController * dailyUpload = [[NDDailyUploadViewController alloc] init];
            dailyUpload.model = self.arrRemoteList[indexPath.row];
            dailyUpload.type = NDDailyVCTypeRemoteReview;
            [self.navigationController pushViewController:dailyUpload animated:true];
        }
            break;
        default:
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NDDailyListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"NDDailyListCell" forIndexPath:indexPath];
    cell.lbIndex.text = @"";
    cell.lbUserName.text = @"";
    cell.lbUploadTime.text = @"";
    
    switch (self.segIndex) {
        case 0://未上报
        {
            NDGarrisonDailyModel * model = self.arrNativeList[indexPath.row];
            cell.lbIndex.text = [NSString stringWithFormat:@"%ld",(long)(indexPath.row + 1)];
            cell.lbUserName.text = model.user_name;
            cell.lbUploadTime.text = model.record_time;
        }
            break;
        case 1://已上报
        {
            NDGarrisonDailyModel * model = self.arrRemoteList[indexPath.row];
            cell.lbIndex.text = model.id;
            cell.lbUserName.text = model.user_name;
            cell.lbUploadTime.text = model.record_time;
        }
            break;
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (self.segIndex) {
        case 0://未上报
        {
            if (self.arrNativeList && self.arrNativeList.count) {
                return self.arrNativeList.count;
            }
        }
            break;
        case 1://已上报
        {
            if (self.arrRemoteList && self.arrRemoteList.count) {
                return self.arrRemoteList.count;
            }
        }
            break;
        default:
            break;
    }
    return 0;
}
@end
