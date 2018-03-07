//
//  NDQCQFViewController.m
//  Gdims2
//
//  Created by apple on 2018/3/5.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDQCQFViewController.h"
#import "NDHomeListHeader.h"
#import "NDHomeCheckItemCell.h"
#import "NDMacroListModel.h"
#import "NDMonitorModel.h"
#import <MJRefresh/MJRefresh.h>
@interface NDQCQFViewController ()<UITableViewDelegate,UITableViewDataSource,NDHomeListHeaderDelegate,NDHomeCheckItemCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btnRecord;

@property (assign, nonatomic) NSInteger tapIndex;
@property (nonatomic,strong) NSArray<NDMacroListModel *> * arrMacroList;
@property (nonatomic,strong) NSArray<NDMonitorModel *> * allMonitorList;
@end

@implementation NDQCQFViewController
- (IBAction)btnRecordClick {
    //todo
}
/**
 灾害点-定量检测数据分组
 
 @param unifiedNumber —
 @return -
 */
- (NSArray<NDMonitorModel *> *)monitorListUnderMacroNumber:(NSString *)unifiedNumber {
    if (self.allMonitorList.count > 0) {
        NSMutableArray<NDMonitorModel *> * monitorList = [NSMutableArray array];
        for (NDMonitorModel * model in self.allMonitorList) {
            if ([model.unifiedNumber isEqualToString:unifiedNumber]) {
                [monitorList addObject:model];
            }
        }
        return  monitorList;
    }
    return nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"灾害点列表";
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.estimatedSectionHeaderHeight = 120;
    self.btnRecord.backgroundColor = [UIColor nd_tintColor];
    self.btnRecord.layer.cornerRadius = 5;
    self.btnRecord.layer.masksToBounds = YES;
    [self.tableView registerNib:[UINib nibWithNibName:@"NDHomeListHeader" bundle:nil] forHeaderFooterViewReuseIdentifier:@"NDHomeListHeader"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"NDHomeCheckItemCell" bundle:nil] forCellReuseIdentifier:@"NDHomeCheckItemCell"];
    self.tapIndex = -1;
    self.arrMacroList = [NSArray array];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
}

- (void)viewDidAppear:(BOOL)animated{
    if (!self.onceLoad) {
        self.onceLoad = true;
        [self loadMacroList];
    }
}
- (void)refreshAction {
    [self.tableView.mj_header endRefreshing];
    [self loadMacroList];
}
- (void)loadMacroList{
    [NDHUD MBShowLoadingInView:self.view text:@"正在查询灾害点数据" delay:0];
    [NDRequestApi getMacroListByMobile:[NDUserInfo sharedInstance].mobile userType:NDUserTypeQCQF completion:^(BOOL success, NSArray<NDMacroListModel *> *list, NSString *errorMsg) {
        [NDHUD MBHideForView:self.view animate:YES];
        if (success) {
            if (list && [list count]) {
                self.arrMacroList = list;
                [self loadMonitorList];
                [self reloadTableAction];
            } else {
                [NDHUD MBShowFailureInView:self.view text:@"无相关灾害点数据" delay:NDHUD_DELAY_TIME];
            }
        } else {
            [NDHUD MBShowFailureInView:self.view text:errorMsg delay:NDHUD_DELAY_TIME];
        }
    }];
}
- (void)loadMonitorList{
    [NDHUD MBShowLoadingInView:self.view text:@"正在查询监测点数据" delay:0];
    [NDRequestApi getMonitorListByMobile:[NDUserInfo sharedInstance].mobile userType:NDUserTypeQCQF completion:^(BOOL success, NSArray<NDMonitorModel *> *list, NSString *errorMsg) {
        [NDHUD MBHideForView:self.view animate:YES];
        if (success) {
            if (list && [list count]) {
                self.allMonitorList = list;
                [self reloadTableAction];
            } else {
                [NDHUD MBShowFailureInView:self.view text:@"无相关监测点数据" delay:NDHUD_DELAY_TIME];
            }
        } else {
            [NDHUD MBShowFailureInView:self.view text:errorMsg delay:NDHUD_DELAY_TIME];
        }
    }];
}
- (void)reloadTableAction{
    for (NDMacroListModel * macroModel in self.arrMacroList) {
        if (self.allMonitorList.count > 0) {
            macroModel.monitorList = [self monitorListUnderMacroNumber:macroModel.unifiedNumber];
        }
    }
    [self.tableView reloadData];
}
#pragma mark tableView数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.arrMacroList && self.arrMacroList.count > 0) {
        return self.arrMacroList.count;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.tapIndex == section) {
        NDMacroListModel * model = self.arrMacroList[section];
        if (model.zxExand) {
            NDMacroListModel * macroListModel = self.arrMacroList[section];
            return 1 + [macroListModel.monitorList count];
        }
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NDHomeListHeader * header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"NDHomeListHeader"];
    header.delegate = self;
    [header reloadData:self.arrMacroList[section] sectionIndex:section];
    return header;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NDHomeCheckItemCell * cell = [tableView dequeueReusableCellWithIdentifier:@"NDHomeCheckItemCell" forIndexPath:indexPath];
    cell.lblTitle.text = @"";
    cell.delegate = self;
    if (indexPath.row == 0) {
        cell.lblTitle.text = @"宏观观测";
    } else {
        NSInteger index = indexPath.row - 1;
        if (index >=0 ) {
            NDMacroListModel * macroListModel = self.arrMacroList[indexPath.section];
            NDMonitorModel * model = macroListModel.monitorList[index];
            cell.lblTitle.text = [NSString stringWithFormat:@"定量监测-%@",model.monPointName];
        }
        
    }
    return cell;
}
#pragma mark tableView代理方法

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
#pragma mark - NDHeaderDelegate
- (void)ndHomeListHeader:(NDHomeListHeader *)header tappedAt:(NSInteger)index {
    if (self.tapIndex == -1) {
        self.tapIndex = index;
    } else {
        if (self.tapIndex != index) {
            NDMacroListModel * model = self.arrMacroList[self.tapIndex];
            model.zxExand = false;
        }
        self.tapIndex = index;
    }
    [self.tableView reloadData];
    
}
#pragma mark - NDHomeCheckHeaderDelegate填报
- (void)ndHomeCheckItemCellReportAction:(NDHomeCheckItemCell *)cell{
    
}
#pragma mark - NDHomeCheckHeaderDelegate查看
- (void)ndHomeCheckItemCellReviewAction:(NDHomeCheckItemCell *)cell{
    
}
//#pragma mark - ZXSettingDelegate
//
//- (void)zxSettingViewControllerDismissed {
//    [self setNeedsStatusBarAppearanceUpdate];
//}



@end
