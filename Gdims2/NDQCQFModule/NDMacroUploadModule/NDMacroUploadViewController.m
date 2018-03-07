//
//  NDMacroUploadViewController.m
//  Gdims2
//
//  Created by apple on 2018/3/7.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDMacroUploadViewController.h"

@interface NDMacroUploadViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UIButton *btnUpload;
@property (weak, nonatomic) IBOutlet UILabel *lblLon;
@property (weak, nonatomic) IBOutlet UILabel *lblLat;

@end

@implementation NDMacroUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)btnSaveClick {
}

- (IBAction)btnUploadClick {
}


@end
