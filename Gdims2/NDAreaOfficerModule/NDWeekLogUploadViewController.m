//
//  NDWeekLogUploadViewController.m
//  Gdims2
//
//  Created by 包宏燕 on 2018/3/7.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDWeekLogUploadViewController.h"
#import "NDAreaWeekModel.h"
#import "NDMonitorCell.h"

@interface NDWeekLogUploadViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,NDMonitorCellDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnUpload;
@property (weak, nonatomic) IBOutlet UITableView *tabList;

@property (nonatomic, strong) UITextView * textLog;
@property (nonatomic, strong) NDAreaWeekMember * memberInfo;

@end

@implementation NDWeekLogUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"工作周报";
    
    self.btnUpload.backgroundColor = [UIColor nd_tintColor];
    self.btnUpload.layer.cornerRadius = 5;
    
    self.tabList.backgroundColor = [UIColor clearColor];
    [self.tabList registerNib:[UINib nibWithNibName:@"NDMonitorCell" bundle:nil] forCellReuseIdentifier:@"NDMonitorCell"];
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ND_BOUNDS_WIDTH, 165)];
    footerView.backgroundColor = [UIColor clearColor];
    [footerView addSubview:self.textLog];
    self.textLog.delegate = self;
    self.tabList.tableFooterView = footerView;
    
    self.memberInfo = [NDAreaWeekMember cacheMember];
    if (_model == nil && self.type == NDWeekLogVCTypeUpload) {
        _model = [[NDAreaWeekModel alloc] init];
        self.model.user_name = self.memberInfo.user_name;
        self.model.units = self.memberInfo.township;
    }
    if (self.type == NDWeekLogVCTypeReview) {
        [self.textLog setEditable:false];
        [self.btnUpload setHidden:true];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 * 工作周报编辑框
 */
- (UITextView *)textLog {
    if (_textLog == nil) {
        _textLog = [[UITextView alloc] init];
        _textLog.backgroundColor = [UIColor whiteColor];
        _textLog.textColor = [UIColor nd_textColor];
        _textLog.frame = CGRectMake(14, 0, ND_BOUNDS_WIDTH-28, 165);
        _textLog.font = [UIFont systemFontOfSize:15];
        _textLog.contentInset = UIEdgeInsetsMake(5, 5, 0, 0);
        _textLog.layer.cornerRadius = 5;
        _textLog.layer.borderWidth = 1;
        _textLog.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    return _textLog;
}

- (IBAction)uploadAction:(id)sender {
    [self.view endEditing:true];
    if (self.model) {
        NSString * errorMsg = [self.model un_inputMsg];
        if (errorMsg) {
            [NDHUD MBShowFailureInView:self.view text:errorMsg delay:NDHUD_DELAY_TIME];
        } else {
            [NDHUD MBShowLoadingInView:[NDRouter window] text:@"上传中..." delay:0];
            [NDRequestApi areaOfficer_SaveWeekLogByName:self.model.user_name
                                                 member:@""
                                               phoneNum:[NDUserInfo sharedInstance].mobile
                                                  units:self.model.units
                                             jobContent:self.model.jobContent
                                             recordTime:self.model.record_time
            completion:^(NSInteger status, BOOL success, NSString *errorMsg) {
               [NDHUD MBHideForView:[NDRouter window] animate:true];
               if (success) {
                   [self.memberInfo save];
                   [NDHUD MBShowSuccessInView:[NDRouter window] text:@"周报上报成功" delay:NDHUD_DELAY_TIME];
                   [self.navigationController popViewControllerAnimated:true];
               } else {
                   [NDHUD MBShowFailureInView:self.view text:errorMsg delay:NDHUD_DELAY_TIME];
               }
           }];
        }
    }
}

#pragma mark - UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == 3) {
//        return 40;
//    }
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NDMonitorCell * cell = [tableView dequeueReusableCellWithIdentifier:@"NDMonitorCell" forIndexPath:indexPath];
    cell.delegate = self;
    [cell.lineView setHidden:false];
    switch (indexPath.row) {
        case 0:
            if (self.type == NDWeekLogVCTypeReview) {
                [cell reloadLeftText:@"乡 镇 名 称:" rightText:self.model.units type:NDMonitorCellTypeLRLabel];
            } else {
                [cell reloadLeftText:@"乡 镇 名 称:" rightText:self.model.units type:NDMonitorCellTypeTextField];
            }
            break;
        case 1:
            [cell reloadLeftText:@"上 报 时 间:" rightText:self.model.record_time type:NDMonitorCellTypeLRLabel];
            break;
        case 2:
            if (self.type == NDWeekLogVCTypeReview) {
                [cell reloadLeftText:@"片区负责人:" rightText:self.model.user_name type:NDMonitorCellTypeLRLabel];
            } else {
                [cell reloadLeftText:@"片区负责人:" rightText:self.model.user_name type:NDMonitorCellTypeTextField];
            }
            break;
        case 3:
            [cell reloadLeftText:@"本周工作情况" rightText:@"" type:NDMonitorCellTypeLLabel];
            self.textLog.text = self.model.jobContent;
            [cell.lineView setHidden:true];
            break;
        default:
            break;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

#pragma mark - cell delegate

- (void)ndMonitorCell:(UITableViewCell *)cell inputDoneWtih:(NSString *)text {
    NSIndexPath * indexPath = [self.tabList indexPathForCell:cell];
    switch (indexPath.row) {
        case 0:
        {
            self.model.units = text;
            self.memberInfo.township = text;
        }
            break;
        case 2:
        {
            self.model.user_name = text;
            self.memberInfo.user_name = text;
        }
            break;
        default:
            break;
    }
}

#pragma mark - UITextViewDelegate

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.model.jobContent = textView.text;
}

@end
