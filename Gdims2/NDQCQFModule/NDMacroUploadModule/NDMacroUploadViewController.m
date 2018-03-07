//
//  NDMacroUploadViewController.m
//  Gdims2
//
//  Created by apple on 2018/3/7.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDMacroUploadViewController.h"
#import "NDMacroListModel.h"
@interface NDMacroUploadViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UIButton *btnUpload;
@property (weak, nonatomic) IBOutlet UILabel *lblLon;
@property (weak, nonatomic) IBOutlet UILabel *lblLat;

@property (nonatomic,strong) NSMutableArray<NDMacroModel *> * arrMacroModelList;
@property (nonatomic,strong) NDMacroModel * otherMacroModel;
@property (nonatomic, assign) NSInteger imageIndex;
@end

@implementation NDMacroUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"宏观观测";
    [self showHotLineButton];
    self.btnSave.backgroundColor = [UIColor nd_buttonColor];
    self.btnSave.layer.cornerRadius = 5;
    self.btnSave.layer.masksToBounds = YES;
    self.btnUpload.backgroundColor = [UIColor nd_buttonColor];
    self.btnUpload.layer.cornerRadius = 5;
    self.btnUpload.layer.masksToBounds = YES;
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)btnSaveClick {
}

- (IBAction)btnUploadClick {
}


@end
