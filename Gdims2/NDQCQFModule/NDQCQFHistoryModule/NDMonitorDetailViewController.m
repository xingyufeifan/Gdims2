//
//  NDMonitorDetailViewController.m
//  Gdims2
//
//  Created by apple on 2018/3/9.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDMonitorDetailViewController.h"
#import "NDMonitorCell.h"
#import "NDQCQFDetailModel.h"
#import "NDMonitorHistoryImageCellTableViewCell.h"
#import "NDSingleTextHeader.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface NDMonitorDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation NDMonitorDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"已上报监测数据";
    [self.tableView registerNib:[UINib nibWithNibName:@"NDMonitorCell" bundle:nil] forCellReuseIdentifier:@"NDMonitorCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"NDMonitorHistoryImageCellTableViewCell" bundle:nil] forCellReuseIdentifier:@"NDMonitorHistoryImageCellTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"NDSingleTextHeader" bundle:nil] forHeaderFooterViewReuseIdentifier:@"NDSingleTextHeader"];
    if (!self.detailModel) {
        [NDHUD MBShowFailureInView:self.view text:@"无相关数据" delay:NDHUD_DELAY_TIME];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITabelViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NDMonitorCell * cell = [tableView dequeueReusableCellWithIdentifier:@"NDMonitorCell" forIndexPath:indexPath];
        [cell.contentView setBackgroundColor:[UIColor nd_whiteColor]];
        [cell.lineView setHidden:false];
        [cell.lblValue setTextColor:[UIColor nd_textColor]];
        switch (indexPath.row) {
            case 0:
                [cell reloadLeftText:@"灾害点名称:" rightText:self.detailModel.dis_name type:NDMonitorCellTypeLRLabel];
                
                break;
            case 1:
                [cell reloadLeftText:@"定 量 监 测:" rightText:self.detailModel.monitor_name type:NDMonitorCellTypeLRLabel];
                
                break;
            case 2:
                [cell reloadLeftText:@"监 测 时 间:" rightText:self.detailModel.u_time type:NDMonitorCellTypeLRLabel];
                
                break;
            case 3:
                [cell reloadLeftText:@"实 测 数 据:" rightText:self.detailModel.monitor_data type:NDMonitorCellTypeLRLabel];
                
                break;
            case 4:
                [cell reloadLeftText:@"是 否 合 法:" rightText:self.detailModel.zx_validString type:NDMonitorCellTypeLRLabel];
                
                break;
            case 5:
                [cell reloadLeftText:@"数据有效性:" rightText:self.detailModel.zx_stateString type:NDMonitorCellTypeLRLabel];
                
                break;
            case 6:
                [cell reloadLeftText:@"相 邻 告 警:" rightText:self.detailModel.zx_warnString type:NDMonitorCellTypeLRLabel];
                
                [cell.lblValue setTextColor:self.detailModel.zx_warnColor];
                break;
            case 7:
                [cell reloadLeftText:@"经        度:" rightText:self.detailModel.lon type:NDMonitorCellTypeLRLabel];
                break;
            case 8:
                [cell reloadLeftText:@"纬        度:" rightText:self.detailModel.lat type:NDMonitorCellTypeLRLabel];
                break;
            default:
                break;
        }
        return cell;
    } else if (indexPath.section == 1) {//图片
        NDMonitorHistoryImageCellTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"NDMonitorHistoryImageCellTableViewCell" forIndexPath:indexPath];
        cell.contentView.backgroundColor = [UIColor nd_whiteColor];
        if (self.detailModel.zx_imgList.count > 0) {
            [cell.imgIcon sd_setImageWithURL:[NSURL URLWithString:self.detailModel.zx_imgList.firstObject] placeholderImage:[UIImage imageNamed:@"zx-img-default"]];
        } else {
            cell.imgIcon.image = nil;
        }
        return cell;
    }
    return [[UITableViewCell alloc]  init];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        NDSingleTextHeader * header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"NDSingleTextHeader"];
        header.contentView.backgroundColor = [UIColor colorWithRed:232 / 255.0 green:237 / 255.0 blue:237 / 255.0 alpha:1.0];
        [header.lbLine setHidden:true];
        header.lbText.textColor = [UIColor nd_tintColor];
        header.lbText.text = @"图片";
        return header;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 9;
    } else if (section == 1) {
        return 1;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
@end
