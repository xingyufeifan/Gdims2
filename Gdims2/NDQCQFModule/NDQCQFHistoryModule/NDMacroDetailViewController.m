//
//  NDMacroDetailViewController.m
//  Gdims2
//
//  Created by apple on 2018/3/9.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDMacroDetailViewController.h"
#import "NDQCQFDetailModel.h"
#import "NDImageCollectionViewCell.h"
#import "NDRemarkInputCell.h"
#import "NDMonitorCell.h"
#import "NDMacrHistoryImageCell.h"
#import "NDSingleTextHeader.h"
@interface NDMacroDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray<NSString *> * imageList;
@end

@implementation NDMacroDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"NDMonitorCell" bundle:nil] forCellReuseIdentifier:@"NDMonitorCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"NDRemarkInputCell" bundle:nil] forCellReuseIdentifier:@"NDRemarkInputCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"NDMacrHistoryImageCell" bundle:nil] forCellReuseIdentifier:@"NDMacrHistoryImageCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"NDSingleTextHeader" bundle:nil] forHeaderFooterViewReuseIdentifier:@"NDSingleTextHeader"];
    self.imageList = nil;
    if (!self.detailModel) {
        [NDHUD MBShowFailureInView:self.view text:@"无相关数据" delay:NDHUD_DELAY_TIME];
    } else {
        self.imageList = self.detailModel.zx_imgList;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 9://备注标题
            case 11://宏观标题
                return 30;
                break;
            case 10://备注类容
            case 12://宏观类容
                return 120;
                break;
            default:
                return 50;
                break;
        }
    } else if (indexPath.section == 1 ) {
        if (self.detailModel) {
            NSInteger count = self.imageList.count;
            if (count > 0) {
                NSInteger row = ceil(count / 3.0);
                return row * (NDImageCollectionViewCell.width + 10);
            }
        }
        return 160;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - UITabelViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 10 || indexPath.row == 12) {
            NDRemarkInputCell * cell = [tableView dequeueReusableCellWithIdentifier:@"NDRemarkInputCell" forIndexPath:indexPath];
            [cell.contentView setBackgroundColor:[UIColor nd_whiteColor]];
            [cell.txtContent setEditable:false];
            if (indexPath.row == 10) {
                cell.txtContent.text = self.detailModel.remarks;
            } else {
                cell.txtContent.text = self.detailModel.macro_data;
            }
            return cell;
        } else {
            NDMonitorCell * cell = [tableView dequeueReusableCellWithIdentifier:@"NDMonitorCell" forIndexPath:indexPath];
            [cell.contentView setBackgroundColor:[UIColor nd_whiteColor]];
            [cell.lineView setHidden:false];
            [cell.lblValue setTextColor:[UIColor nd_textColor]];
            switch (indexPath.row) {
                case 0:
                    [cell reloadLeftText:@"灾害点编号:" rightText:self.disNumber type:NDMonitorCellTypeLRLabel];
                    break;
                case 1:
                    [cell reloadLeftText:@"灾害点名称:" rightText:self.detailModel.dis_name type:NDMonitorCellTypeLRLabel];
                    
                    break;
                case 2:
                    [cell reloadLeftText:@"监 测 时 间:" rightText:self.detailModel.u_time type:NDMonitorCellTypeLRLabel];
                    
                    break;
                case 3:
                    [cell reloadLeftText:@"是 否 合 法:" rightText:self.detailModel.zx_validString type:NDMonitorCellTypeLRLabel];
                    
                    break;
                case 4:
                    [cell reloadLeftText:@"数据有效性:" rightText:self.detailModel.zx_stateString type:NDMonitorCellTypeLRLabel];
                    
                    break;
                case 5:
                    [cell reloadLeftText:@"告 警 等 级:" rightText:self.detailModel.zx_warnString type:NDMonitorCellTypeLRLabel];
                    
                    [cell.lblValue setTextColor:self.detailModel.zx_warnColor];
                    break;
                case 6:
                    [cell reloadLeftText:@"其 他 现 象:" rightText:self.detailModel.otherPhenomena type:NDMonitorCellTypeLRLabel];
                    break;
                case 7:
                    [cell reloadLeftText:@"经        度:" rightText:self.detailModel.lon type:NDMonitorCellTypeLRLabel];
                    
                    break;
                case 8:
                    [cell reloadLeftText:@"纬        度:" rightText:self.detailModel.lat type:NDMonitorCellTypeLRLabel];
                    
                    break;
                case 9://备注标题
                    [cell reloadLeftText:@"备 注 信 息:" rightText:nil type:NDMonitorCellTypeLLabel];
                    [cell.lineView setHidden:YES];
                    break;
                case 11://宏观标题
                    [cell reloadLeftText:@"宏 观 现 象:" rightText:nil type:NDMonitorCellTypeLLabel];
                    [cell.lineView setHidden:YES];
                    break;
                default:
                    break;
            }
            return cell;
        }
    } else if (indexPath.section == 1) {//图片
        NDMacrHistoryImageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"NDMacrHistoryImageCell" forIndexPath:indexPath];
        cell.imgList = self.imageList;
        return cell;
    }
    return [[UITableViewCell alloc]  init];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NDSingleTextHeader * header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"NDSingleTextHeader"];
    header.contentView.backgroundColor = [UIColor colorWithRed:232 / 255.0 green:237 / 255.0 blue:237 / 255.0 alpha:1.0];
    [header.lbLine setHidden:true];
    header.lbText.textColor = [UIColor nd_tintColor];
    header.lbText.text = @"";
    if (section == 0) {
        header.lbText.text = @"基础";
    } else if (section == 1) {
        header.lbText.text = @"图片";
    }
    return header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 13;
    } else if (section == 1) {
        return 1;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
@end
