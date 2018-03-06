//
//  NDGarrisonManViewController.m
//  Gdims2
//
//  Created by 李青松 on 2018/3/6.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDGarrisonManViewController.h"
#import "NDMenuCell.h"

@interface NDGarrisonManViewController ()
        <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tblList;
@property (weak, nonatomic) IBOutlet UIButton *btnVideoUpload;
@end

@implementation NDGarrisonManViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btnVideoUpload.backgroundColor = [UIColor nd_tintColor];
    self.btnVideoUpload.layer.cornerRadius = 5;
    self.tblList.backgroundColor = [UIColor clearColor];
    [self.tblList registerNib:[UINib nibWithNibName:@"NDMenuCell" bundle:nil] forCellReuseIdentifier:@"NDMenuCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)videoUpload:(id)sender {
    NSLog(@"视频录制上传");
}

@end
