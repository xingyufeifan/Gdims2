//
//  NDQCQFHistoryViewController.m
//  Gdims2
//
//  Created by apple on 2018/3/9.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDQCQFHistoryViewController.h"
#import "NDQCQFDetailModel.h"
#import "NSDate+ND.h"
#import "NDQCQFHistoryCell.h"
#import "NDDateCheckViewController.h"
#import "NDMacroDetailViewController.h"
#import "NDMonitorDetailViewController.h"
@interface NDQCQFHistoryViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@property (weak, nonatomic) IBOutlet UIButton *btnStartTime;
@property (weak, nonatomic) IBOutlet UIButton *btnEndTime;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (nonatomic, strong) NSDate * startDate;
@property (nonatomic, strong) NSDate * endDate;

@property (nonatomic, strong) NSArray<NDQCQFDetailModel *> * dataList;

@end

@implementation NDQCQFHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.onceLoad = false;
    if (self.type == NDQCQFDetailTypeMacro) {
        self.title = @"宏观巡查记录";
    } else {
        self.title = @"定量监测记录";
    }
    self.startDate = nil;
    self.endDate = nil;
    self.dataList = @[];
    
    self.headerView.layer.shadowOffset = CGSizeMake(0, 2);
    self.headerView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.headerView.layer.shadowRadius = 2;
    self.headerView.layer.shadowOpacity = 0.35;
    [self.tableView registerNib:[UINib nibWithNibName:@"NDQCQFHistoryCell" bundle:nil] forCellReuseIdentifier:@"NDQCQFHistoryCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 90;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.onceLoad) {
        self.onceLoad = true;
        [self fetchDataWithStartDate:[self lastMonthDateString] endDate:[self currentDateString]];
    }
}

- (void)fetchDataWithStartDate:(NSString *)start endDate:(NSString *)endDate {
    [NDHUD MBShowLoadingInView:self.view text:@"正在获取数据..." delay:0];
    [NDRequestApi qcqfHistoryListType:self.type
                               mobile:[NDUserInfo sharedInstance].mobile
                            startTime:[NSString stringWithFormat:@"%@ 00:00:00",start]
                              endTime:[NSString stringWithFormat:@"%@ 24:00:00",endDate]
                                disNo:self.disNo
                            monitorNo:self.monitorNo
                           completion:^(BOOL success, NSArray<NDQCQFDetailModel *> *list, NSString *errorMsg) {
                               [NDHUD MBHideForView:self.view animate:true];
                               if (success) {
                                   self.dataList = list;
                                   if (self.dataList.count == 0) {
                                       [NDHUD MBShowFailureInView:self.view text:@"无相关历史记录" delay:NDHUD_DELAY_TIME];
                                   }
                                   [self.tableView reloadData];
                               } else {
                                   [NDHUD MBShowFailureInView:self.view text:errorMsg delay:NDHUD_DELAY_TIME];
                               }
                           }];
}
- (NSString *)lastMonthDateString {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"yyyy"];
    NSInteger currentYear=[[formatter stringFromDate:date] integerValue];
    [formatter setDateFormat:@"MM"];
    NSInteger currentMonth=[[formatter stringFromDate:date]integerValue];
    [formatter setDateFormat:@"dd"];
    NSInteger lastMonth = currentMonth - 1;
    NSInteger lastMonthYear = currentYear;
    if (lastMonth <= 0) {
        lastMonth = 12;
        lastMonthYear -= 1;
    }
    NSString * lastMonthDateString = [NSString stringWithFormat:@"%ld-%02ld-01",(long)lastMonthYear,(long)lastMonth];
    return lastMonthDateString;
}

- (NSString *)currentDateString {
    return [[NSDate date] dateStringWithFormate:@"YYYY-MM-dd"];
}
- (NSString *)startDateString {
    if (self.startDate) {
        return [self.startDate dateStringWithFormate:@"YYYY-MM-dd"];
    }
    return nil;
}

- (NSString *)endDateString {
    if (self.endDate) {
        return [self.endDate dateStringWithFormate:@"YYYY-MM-dd"];
    }
    return nil;
}
- (void)setStartDate:(NSDate *)startDate{
    _startDate = startDate;
    if (_startDate) {
        [self.btnStartTime setTitle:[self startDateString] forState:UIControlStateNormal];
    } else {
        [self.btnStartTime setTitle:@"开始时间" forState:UIControlStateNormal];
    }
}

- (void)setEndDate:(NSDate *)endDate{
    _endDate = endDate;
    if (_endDate) {
        [self.btnEndTime setTitle:[self endDateString] forState:UIControlStateNormal];
    } else {
        [self.btnEndTime setTitle:@"结束时间" forState:UIControlStateNormal];
    }
}
- (IBAction)btnSearchClick {
    if (!self.disNo) {
        [NDHUD MBShowFailureInView:self.view text:@"灾害点编号不存在" delay:NDHUD_DELAY_TIME];
        return;
    }
    if (!self.monitorNo) {
        [NDHUD MBShowFailureInView:self.view text:@"监测点编号不存在" delay:NDHUD_DELAY_TIME];
        return;
    }
    if (!self.startDate) {
        [NDHUD MBShowFailureInView:self.view text:@"请选择开始时间" delay:NDHUD_DELAY_TIME];
        return;
    }
    if (!self.endDate) {
        [NDHUD MBShowFailureInView:self.view text:@"请选择结束时间" delay:NDHUD_DELAY_TIME];
        return;
    }
    [self fetchDataWithStartDate:[self startDateString] endDate:[self endDateString]];
}
- (IBAction)btnStartTimeClick {
    NDDateCheckViewController * dateUtils = [[NDDateCheckViewController alloc] init];
    dateUtils.titleInfo = @"开始时间";
    dateUtils.justDate = true;
    dateUtils.callBack = ^(NSDate * date,NSString *strDate) {
        self.startDate = date;
    };
    if (self.endDate) {
        dateUtils.maxDate = self.endDate;
    }
    [self presentViewController:dateUtils animated:true completion:nil];
}
- (IBAction)btnEndTimeClick {
    NDDateCheckViewController * dateUtils = [[NDDateCheckViewController alloc] init];
    dateUtils.titleInfo = @"结束时间";
    dateUtils.justDate = true;
    dateUtils.callBack = ^(NSDate * date,NSString *strDate) {
        self.endDate = date;
    };
    if (self.startDate) {
        dateUtils.minDate = self.startDate;
    }
    [self presentViewController:dateUtils animated:true completion:nil];
}

#pragma mark tableView代理方法和数据源方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == NDQCQFDetailTypeMacro) {
        NDMacroDetailViewController * macroDetail = [[NDMacroDetailViewController alloc] init];
        macroDetail.detailModel = self.dataList[indexPath.section];
        macroDetail.disNumber = self.disNo;
        [self.navigationController pushViewController:macroDetail animated:true];
    } else if (self.type == NDQCQFDetailTypeMonitor) {
        NDMonitorDetailViewController * monitorDetail = [[NDMonitorDetailViewController alloc] init];
        monitorDetail.detailModel = self.dataList[indexPath.section];
        [self.navigationController pushViewController:monitorDetail animated:true];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NDQCQFHistoryCell * cell = [tableView dequeueReusableCellWithIdentifier:@"NDQCQFHistoryCell" forIndexPath:indexPath];
    [cell reloadData:self.dataList[indexPath.section] type:self.type];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.dataList && self.dataList.count) {
        return self.dataList.count;
    }
    return  0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15;
}


@end
