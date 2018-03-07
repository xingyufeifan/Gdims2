//
//  NDDailyUploadViewController.m
//  Gdims2
//
//  Created by 李青松 on 2018/3/6.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDDailyUploadViewController.h"
#import "NDGarrisonModel.h"

@interface NDDailyUploadViewController ()
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
    [self.tblList registerNib:[UINib nibWithNibName:@"ZXRemarkInputCell" bundle:nil] forCellReuseIdentifier:@"ZXRemarkInputCell"];
    [self.tblList registerNib:[UINib nibWithNibName:@"ZXSingleTextHeader" bundle:nil] forHeaderFooterViewReuseIdentifier:@"ZXSingleTextHeader"];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
