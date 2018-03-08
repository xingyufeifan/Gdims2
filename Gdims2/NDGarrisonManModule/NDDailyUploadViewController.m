//
//  NDDailyUploadViewController.m
//  Gdims2
//
//  Created by 李青松 on 2018/3/6.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDDailyUploadViewController.h"
#import "NDGarrisonModel.h"
#import "NDSingleTextHeader.h"
#import "NDMonitorCell.h"
#import "NDRemarkInputCell.h"

@interface NDDailyUploadViewController ()
<UITableViewDelegate,UITableViewDataSource,NDMonitorCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tblList;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomOffset;
@property (weak, nonatomic) IBOutlet UIView *bottomControlView;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
@property (weak, nonatomic) IBOutlet UIButton *btnUpload;
@property (nonatomic, strong) NDGarrisonMember * memberInfo;
@end

@implementation NDDailyUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"工作日志";
    self.memberInfo = [NDGarrisonMember cacheMember];
    self.btnUpload.backgroundColor = [UIColor nd_tintColor];
    self.btnUpload.layer.cornerRadius = 5;
    self.btnDelete.backgroundColor = [UIColor nd_tintColor];
    self.btnDelete.layer.cornerRadius = 5;
    self.btnSave.backgroundColor = [UIColor nd_tintColor];
    self.btnSave.layer.cornerRadius = 5;
    
    [self.tblList setBackgroundColor:[UIColor nd_backgroundColor]];
    [self.tblList registerNib:[UINib nibWithNibName:@"NDMonitorCell" bundle:nil] forCellReuseIdentifier:@"NDMonitorCell"];
    [self.tblList registerNib:[UINib nibWithNibName:@"NDRemarkInputCell" bundle:nil] forCellReuseIdentifier:@"NDRemarkInputCell"];
    [self.tblList registerNib:[UINib nibWithNibName:@"NDSingleTextHeader" bundle:nil] forHeaderFooterViewReuseIdentifier:@"NDSingleTextHeader"];
    
    [self.btnDelete setHidden:true];
    if (self.type == NDDailyVCTypeNativeReview) {
        [self.btnSave setHidden:true];
        [self.btnDelete setHidden:false];
        UIBarButtonItem  * itemT=[[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveAction:)];
        [self.navigationItem setRightBarButtonItem:itemT];
        
    } else if (self.type == NDDailyVCTypeRemoteReview) {
        self.bottomOffset.constant = 0;
        [self.bottomControlView setHidden:true];
    }
    
    if (_model == nil && self.type == NDDailyVCTypeUpload) {
        _model = [[NDGarrisonDailyModel alloc] init];
        self.model.user_name = self.memberInfo.user_name;
        self.model.work_type = self.memberInfo.work_type;
        self.model.situation = self.memberInfo.situation;
    }
}

/**
 保存
 
 @param sender -
 */
- (IBAction)saveAction:(id)sender {
    [self.view endEditing:true];
    if (self.model) {
        NSLog(@"model = %@",self.model);
        NSString * str = [self.model un_inputMsg];
        if (str) {
            [NDHUD MBShowFailureInView:self.view text:str delay:NDHUD_DELAY_TIME];
            return;
        } else {
            [self.memberInfo save];
            [self.model saveAction];
            [NDHUD MBShowSuccessInView:[NDRouter window] text:@"已保存" delay:NDHUD_DELAY_TIME];
        }
    } else {
        [NDHUD MBShowFailureInView:self.view text:@"数据为空" delay:NDHUD_DELAY_TIME];
    }
}

- (IBAction)deleteAction:(id)sender {
    [self.view endEditing:true];
    if (self.model) {
        [NDAlertUtils showAAlertMessage:@"提示" title:@"确定删除该条日志？" buttonTexts:@[@"确定",@"取消"] buttonAction:^(int buttonIndex) {
            if (buttonIndex == 0) {
                [self.model clearCache];
                [NDHUD MBShowSuccessInView:[NDRouter window] text:@"已删除" delay:NDHUD_DELAY_TIME];
                [self.navigationController popViewControllerAnimated:true];
            }
        }];
    } else {
        [NDHUD MBShowFailureInView:self.view text:@"数据为空" delay:NDHUD_DELAY_TIME];
    }
}

- (IBAction)uploadAction:(id)sender {
    [self.view endEditing:true];
    if (self.model) {
        NSString * str = [self.model un_inputMsg];
        if (str) {
            [NDHUD MBShowFailureInView:self.view text:str delay:NDHUD_DELAY_TIME];
            return;
        } else {
            [NDHUD MBShowLoadingInView:[NDRouter window] text:@"上传中..." delay:0];
            [NDRequestApi garrison_SaveDailyByName:self.model.user_name workType:self.model.work_type situation:self.model.situation logContent:self.model.log_content remark:self.model.remarks recordTime:self.model.record_time phoneNum:[NDUserInfo sharedInstance].mobile completion:^(NSInteger status, BOOL success, NSString *errorMsg) {
                [NDHUD MBHideForView:[NDRouter window] animate:true];
                if (success) {
                    [self.memberInfo save];
                    [self.model clearCache];
                    [NDHUD MBShowSuccessInView:[NDRouter window] text:@"日报已上传" delay:NDHUD_DELAY_TIME];
                    [self.navigationController popViewControllerAnimated:true];
                    
                } else {
                    [NDHUD MBShowFailureInView:self.view text:errorMsg delay:NDHUD_DELAY_TIME];
                    
                }
            }];
        }
    } else {
        [NDHUD MBShowFailureInView:self.view text:@"数据为空" delay:NDHUD_DELAY_TIME];
    }
}

#pragma mark - UITabbleView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 50;
            break;
        case 1:
            return 130;
            break;
        case 2:
            return 70;
            break;
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 30;
            break;
        case 1:
            return 50;
            break;
        case 2:
            return 50;
            break;
        default:
            break;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 3;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 1;
            break;
        default:
            break;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            NDMonitorCell * cell = [self.tblList dequeueReusableCellWithIdentifier:@"NDMonitorCell" forIndexPath:indexPath];
            cell.delegate = self;
            switch (indexPath.row) {
                case 0:
                    if (self.type == NDDailyVCTypeRemoteReview) {
                        [cell reloadLeftText:@"记录人员:" rightText:self.model.user_name type:NDMonitorCellTypeLRLabel];
                        
                    } else {
                        [cell reloadLeftText:@"记录人员:" rightText:self.model.user_name type:NDMonitorCellTypeTextField];
                        
                    }
                    break;
                case 1:
                    if (self.type == NDDailyVCTypeRemoteReview) {
                        [cell reloadLeftText:@"工作类型:" rightText:self.model.work_type type:NDMonitorCellTypeLRLabel];
                    } else {
                        [cell reloadLeftText:@"工作类型:" rightText:self.model.work_type type:NDMonitorCellTypeTextField];
                    }
                    break;
                case 2:
                    if (self.type == NDDailyVCTypeRemoteReview) {
                        [cell reloadLeftText:@"在岗情况:" rightText:self.model.situation type:NDMonitorCellTypeLRLabel];
                    } else {
                        [cell reloadLeftText:@"在岗情况:" rightText:self.model.situation type:NDMonitorCellTypeTextField];
                    }
                    break;
                default:
                    break;
            }
            return cell;
        }
            break;
        case 1:
        {
            NDRemarkInputCell * cell = [self.tblList dequeueReusableCellWithIdentifier:@"NDRemarkInputCell" forIndexPath:indexPath];
            cell.delegate = self;
            cell.txtContent.text = self.model.log_content;
            if (self.type == NDDailyVCTypeRemoteReview) {
                [cell.txtContent setEditable:false];
            } else {
                [cell.txtContent setEditable:true];
            }
            return cell;
        }
            break;
            
        case 2:
        {
            NDRemarkInputCell * cell = [self.tblList dequeueReusableCellWithIdentifier:@"NDRemarkInputCell" forIndexPath:indexPath];
            cell.txtContent.text = self.model.remarks;
            cell.delegate = self;
            if (self.type == NDDailyVCTypeRemoteReview) {
                [cell.txtContent setEditable:false];
            } else {
                [cell.txtContent setEditable:true];
            }
            return cell;
        }
            break;
            
        default:
            break;
    }
    return [[UITableViewCell alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NDSingleTextHeader * header = [self.tblList dequeueReusableHeaderFooterViewWithIdentifier:@"NDSingleTextHeader"];
    header.lbText.textAlignment = NSTextAlignmentLeft;
    header.lbText.font = [UIFont systemFontOfSize:16];
    [header.lbLine setHidden:true];
    switch (section) {
        case 0:
            [header.lbLine setHidden:false];
            header.lbText.textAlignment = NSTextAlignmentRight;
            header.lbText.font = [UIFont systemFontOfSize:12];
            header.lbText.text = [NSString stringWithFormat:@"记录时间: %@",self.model.record_time];
            break;
        case 1:
            header.lbText.text = @"日志类容";
            break;
        case 2:
            header.lbText.text = @"备注";
            break;
        default:
            break;
    }
    return header;
}

#pragma mark -
- (void)ndMonitorCell:(UITableViewCell *)cell inputDoneWtih:(NSString *)text {
    NSIndexPath * indexPath = [self.tblList indexPathForCell:cell];
    if ([cell isKindOfClass:[NDMonitorCell class]]) {
        if (indexPath.section == 0) {
            switch (indexPath.row) {
                case 0://记录人员
                {
                    NSLog(@"user_name = %@",text);
                    self.model.user_name = text;
                    self.memberInfo.user_name = text;
                }
                    break;
                case 1://工作类型
                {
                        NSLog(@"work_type = %@",text);
                    self.model.work_type = text;
                    self.memberInfo.work_type = text;
                }
                    break;
                case 2://在岗情况
                {
                        NSLog(@"situation = %@",text);
                    self.model.situation = text;
                    self.memberInfo.situation = text;
                }
                    break;
                default:
                    break;
            }
        }
    } else if ([cell isKindOfClass:[NDRemarkInputCell class]]) {
        if (indexPath.section == 1) {//日报
            NSLog(@"logCOntent = %@",text);
            self.model.log_content = text;
        } else if (indexPath.section == 2) {//备注
             NSLog(@"remarks = %@",text);
            self.model.remarks = text;
        }
    }
}

@end
