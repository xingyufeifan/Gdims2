//
//  NDDailyUploadViewController.m
//  Gdims2
//
//  Created by 李青松 on 2018/3/6.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDDailyUploadViewController.h"
#import "NDGarrisonModel.h"
#import "NDRemarkInputCell.h"
#import "NDSingleTextHeader.h"

@interface NDDailyUploadViewController ()
<UITableViewDelegate,UITableViewDataSource>
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
    [self.tblList registerNib:[UINib nibWithNibName:@"ZXMonitorCell" bundle:nil] forCellReuseIdentifier:@"ZXMonitorCell"];
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




@end
