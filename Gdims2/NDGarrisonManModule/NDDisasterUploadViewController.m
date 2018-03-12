//
//  NDDisasterUploadViewController.m
//  Gdims2
//
//  Created by 李青松 on 2018/3/6.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDDisasterUploadViewController.h"
#import "NDGarrisonModel.h"
#import "NDMonitorCell.h"
#import "NDRemarkInputCell.h"
#import "NDSingleTextHeader.h"
#import "NDSingleImageCell.h"
#import "UIImage+ND.h"
#import "NDUnSafeHouseNumCell.h"
#import "NDDateCheckViewController.h"
#import <AFNetworking/UIButton+AFNetworking.h>
@interface NDDisasterUploadViewController ()
<UITableViewDelegate,UITableViewDataSource,NDMonitorCellDelegate,NDUnSafeHouseNumCellDelegate,NDImageCheckDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tblList;
@property (weak, nonatomic) IBOutlet UIButton *btnUpload;

@property (nonatomic, strong) NDImagePickerUtils * imagePicker;
@property (nonatomic, strong) NDDateCheckViewController * dateUtils;
@end

@implementation NDDisasterUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"灾情速报";
    if (_model == nil) {
        _model = [[NDDisasterModel alloc] init];
    }
    
    NDGarrisonMember * member = [NDGarrisonMember cacheMember];
    _model.userName = member.user_name;
    
    [self.tblList setBackgroundColor:[UIColor nd_backgroundColor]];
    [self.tblList registerNib:[UINib nibWithNibName:@"NDMonitorCell" bundle:nil] forCellReuseIdentifier:@"NDMonitorCell"];
    [self.tblList registerNib:[UINib nibWithNibName:@"NDSingleImageCell" bundle:nil] forCellReuseIdentifier:@"NDSingleImageCell"];
    [self.tblList registerNib:[UINib nibWithNibName:@"NDUnSafeHouseNumCell" bundle:nil] forCellReuseIdentifier:@"NDUnSafeHouseNumCell"];
    [self.tblList registerNib:[UINib nibWithNibName:@"NDRemarkInputCell" bundle:nil] forCellReuseIdentifier:@"NDRemarkInputCell"];
    [self.tblList registerNib:[UINib nibWithNibName:@"NDSingleTextHeader" bundle:nil] forHeaderFooterViewReuseIdentifier:@"NDSingleTextHeader"];
    [self.btnUpload setBackgroundColor:[UIColor nd_tintColor]];
    self.btnUpload.layer.cornerRadius = 5;
}

- (IBAction)uploadAction:(id)sender {
    [self.view endEditing:true];
    if (self.model) {
        NSString * str = [self.model un_inputMsg];
        if (str) {
            [NDHUD MBShowFailureInView:self.view text:str delay:NDHUD_DELAY_TIME];
            return;
        } else {
            [NDHUD MBShowLoadingInView:[NDRouter window] text:@"上传中" delay:0];
            NSArray * arrPaths = self.model.nd_imagePaths;
            NSMutableArray<UIImage *> * imgs = nil;
            if (arrPaths && arrPaths.count > 0) {
                imgs = [NSMutableArray array];
                for (NSString * path in arrPaths) {
                    UIImage * image = [UIImage imageWithContentsOfFile:path];
                    if (image) {
                        [imgs addObject:image];
                    }
                }
            }
            [NDRequestApi garrison_SaveDisaterByName:self.model.userName
                                             userType:[NDUserInfo sharedInstance].type
                                             phoneNum:[NDUserInfo sharedInstance].mobile
                                           happenTime:self.model.happenTime
                                             township:self.model.township
                                              village:self.model.village
                                                group:self.model.group
                                          disasterNum:self.model.disasterNum
                                               dieNum:self.model.dieNum
                                           missingNum:self.model.missingNum
                                           injuredNum:self.model.injuredNum
                                             houseNum:self.model.houseNum
                                            peopleNum:self.model.peopleNum
                                                notes:self.model.notes
                                               images:imgs
                                            fileNames:self.model.imageNames
                                           completion:^(NSInteger status, BOOL success, NSString *errorMsg) {
                                               [NDHUD MBHideForView:[NDRouter window] animate:true];
                                               if (success) {
                                                   [NDHUD MBShowSuccessInView:[NDRouter window] text:@"上传成功" delay:NDHUD_DELAY_TIME];
                                                   [self.model clearCache];
                                                   [self.navigationController popViewControllerAnimated:true];
                                               } else {
                                                   [NDHUD MBShowFailureInView:self.view text:errorMsg delay:NDHUD_DELAY_TIME];
                                               }
                                           }];
        }
    } else {
        [NDHUD MBShowFailureInView:self.view text:@"信息为空" delay:NDHUD_DELAY_TIME];
    }
}

#pragma mark - NDMonitorCellDelegate
- (void)ndMonitorCell:(UITableViewCell *)cell inputDoneWtih:(NSString *)text {
    NSIndexPath * indexPath = [self.tblList indexPathForCell:cell];
    switch (indexPath.section) {
        case 0://基础
        {
            switch (indexPath.row) {
                case 0://姓名
                {
                    self.model.userName = text;
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1://地点
        {
            switch (indexPath.row) {
                case 0://乡/镇
                    self.model.township = text;
                    break;
                case 1://村
                    self.model.village = text;
                    break;
                case 2://组
                    self.model.group = text;
                    break;
                default:
                    break;
            }
        }
            break;
        case 2://灾情
        {
            switch (indexPath.row) {
                case 0://受灾人数
                    self.model.disasterNum = text;
                    break;
                case 1://死亡人数
                    self.model.dieNum = text;
                    break;
                case 2://失踪人数
                    self.model.missingNum = text;
                    break;
                case 3://受伤人数
                    self.model.injuredNum = text;
                    break;
                default:
                    break;
            }
        }
            break;
        case 4://备注
        {
            self.model.notes = text;
        }
            break;
        default:
            break;
    }
}

#pragma mark - NDUnsafeHouseCellDelegate
- (void)ndUnSafeHouseNumCell:(UITableViewCell *)cell houseNum:(NSString *)houseNum {
    self.model.houseNum = houseNum;
}

- (void)ndUnSafeHouseNumCell:(UITableViewCell *)cell peopleNum:(NSString *)peopleNum {
    self.model.peopleNum = peopleNum;
}

#pragma mark - NDImageCheckDelegate
- (void)ndImageCheckDelegateTakePhotoAction:(NDSingleImageCell *)cell {
    __weak typeof(self) weakSelf = self;
    [NDAlertUtils showActionSheetMsg:@"照片获取" title:nil buttonTexts:@[@"拍照",@"从相册取"] buttonAction:^(int buttonIndex) {
        __strong typeof(self) self = weakSelf;
        if (buttonIndex == 0) {
            [self takePhotoAction];
        } else if (buttonIndex == 1) {
            [self choosePhotoAction];
            
        }
    }];
}

- (void)ndImageCheckCell:(NDSingleImageCell *)cell delegateAt:(NSInteger)index {
    if (self.model.imageNames && self.model.imageNames.count > 0) {
        [NDFileUtils deleteFileWithPath:self.model.nd_imagePaths[index]];
        [self.model.imageNames removeObjectAtIndex:index];
        [self.tblList reloadData];
    }
}

- (void)takePhotoAction {
    __weak typeof(self) weakSelf = self;
    [self.imagePicker takePhotoUponVC:self callBack:^(UIImage *image, ZXTakePhotoStatus status, NSString *errorMsg) {
        __strong typeof(self) self = weakSelf;
        [self setNeedsStatusBarAppearanceUpdate];
        if (status == ZXPSuccess) {
            [self setImageAction:image];
        } else {
            if (status != ZXPCanceled) {
                [NDHUD MBShowFailureInView:[NDRouter window] text:errorMsg delay:NDHUD_DELAY_TIME];
            }
        }
    }];
}

- (void)choosePhotoAction {
    __weak typeof(self) weakSelf = self;
    [weakSelf.imagePicker choosePhotoUponVC:self callBack:^(UIImage *image, ZXTakePhotoStatus status, NSString *errorMsg) {
        __strong typeof(self) self = weakSelf;
        
        [self setNeedsStatusBarAppearanceUpdate];
        if (status == ZXPSuccess) {
            [self setImageAction:image];
        } else {
            if (status != ZXPCanceled) {
                [NDHUD MBShowFailureInView:[NDRouter window] text:errorMsg delay:NDHUD_DELAY_TIME];
            }
        }
    }];
}

- (void)setImageAction:(UIImage *)image1 {
    [NDHUD MBShowLoadingInView:[NDRouter window] text:@"图片处理中..." delay:0];
    UIImage * NDImage = [UIImage fixOrientation:image1];
    [NDFileUtils saveImage:NDImage completion:^(BOOL success, NSString *fileName) {
        [NDHUD MBHideForView:[NDRouter window] animate:true];
        if (success) {
            [self.model.imageNames addObject:fileName];
            [self.tblList reloadData];
        } else {
            [NDHUD MBShowFailureInView:[NDRouter window] text:@"图片处理失败,请重拍照/获取" delay:NDHUD_DELAY_TIME];
        }
    }];
}

#pragma mark - UITableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0://基础
        {
            switch (indexPath.row) {
                case 0://姓名
                {
                    NDMonitorCell * cell = [self.tblList dequeueReusableCellWithIdentifier:@"NDMonitorCell" forIndexPath:indexPath];
                    cell.textType = NDInputTextTypeText;
                    cell.contentView.backgroundColor = [UIColor whiteColor];
                    cell.delegate = self;
                    [cell reloadLeftText:@"姓    名:" rightText:self.model.userName type:NDMonitorCellTypeTextField];
                    return cell;
                }
                    break;
                case 1://日期
                {
                    NDMonitorCell * cell = [self.tblList dequeueReusableCellWithIdentifier:@"NDMonitorCell" forIndexPath:indexPath];
                    cell.contentView.backgroundColor = [UIColor whiteColor];
                    NSString * text = self.model.happenTime;
                    if (text == nil || [text zx_isEmpty]) {
                        text = @"请选择";
                    }
                    [cell reloadLeftText:@"发生日期:" rightText:text type:NDMonitorCellTypeLRLabel];
                    return cell;
                }
                    break;
                case 2://照片
                {
                    NDSingleImageCell * cell = [self.tblList dequeueReusableCellWithIdentifier:@"NDSingleImageCell" forIndexPath:indexPath];
                    cell.delegate = self;
                    cell.contentView.backgroundColor = [UIColor whiteColor];
                    cell.imgPaths = self.model.nd_imagePaths;
                    return cell;
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 1://地点
        {
            NDMonitorCell * cell = [self.tblList dequeueReusableCellWithIdentifier:@"NDMonitorCell" forIndexPath:indexPath];
            cell.textType = NDInputTextTypeText;
            cell.contentView.backgroundColor = [UIColor whiteColor];
            cell.delegate = self;
            switch (indexPath.row) {
                case 0:
                    [cell reloadLeftText:@"乡/镇  :" rightText:self.model.township type:NDMonitorCellTypeTextField];
                    break;
                case 1:
                    [cell reloadLeftText:@"村        :" rightText:self.model.village type:NDMonitorCellTypeTextField];
                    break;
                case 2:
                    [cell reloadLeftText:@"组        :" rightText:self.model.group type:NDMonitorCellTypeTextField];
                    break;
                default:
                    break;
            }
            return cell;
            
        }
            break;
        case 2://灾情
        {
            NDMonitorCell * cell = [self.tblList dequeueReusableCellWithIdentifier:@"NDMonitorCell" forIndexPath:indexPath];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            cell.textType = NDInputTextTypeInteger;
            cell.delegate = self;
            switch (indexPath.row) {
                case 0:
                    [cell reloadLeftText:@"受灾人数:" rightText:self.model.disasterNum type:NDMonitorCellTypeTextField];
                    break;
                case 1:
                    [cell reloadLeftText:@"死亡人数:" rightText:self.model.dieNum type:NDMonitorCellTypeTextField];
                    break;
                case 2:
                    [cell reloadLeftText:@"失踪人数:" rightText:self.model.missingNum type:NDMonitorCellTypeTextField];
                    break;
                case 3:
                    [cell reloadLeftText:@"受伤人数:" rightText:self.model.injuredNum type:NDMonitorCellTypeTextField];
                    break;
                default:
                    break;
            }
            return cell;
            
        }
            break;
        case 3://险情
        {
            NDUnSafeHouseNumCell * cell = [self.tblList dequeueReusableCellWithIdentifier:@"NDUnSafeHouseNumCell" forIndexPath:indexPath];
            cell.delegate = self;
            cell.txtHouseNum.text = self.model.houseNum;
            cell.txtPeopleNum.text = self.model.peopleNum;
            cell.contentView.backgroundColor = [UIColor whiteColor];
            return cell;
            
        }
            break;
        case 4://备注
        {
            NDRemarkInputCell * cell = [tableView dequeueReusableCellWithIdentifier:@"NDRemarkInputCell" forIndexPath:indexPath];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            cell.delegate = self;
            cell.txtContent.text = self.model.notes;
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
    [header.lbLine setHidden:true];
    header.lbText.textColor = [UIColor nd_tintColor];
    switch (section) {
        case 0:
            header.lbText.text = @"基础";
            break;
        case 1:
            header.lbText.text = @"地点";
            break;
            
        case 2:
            header.lbText.text = @"灾情";
            break;
        case 3:
            header.lbText.text = @"险情";
            break;
        case 4:
            header.lbText.text = @"备注";
            break;
        default:
            break;
    }
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 1) {//日期选择
        [self presentViewController:self.dateUtils animated:true completion:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 2) {//照片
                return [NDSingleImageCell height] + 20;
            }
        }
            break;
        case 4:
            return 120;
            break;
        default:
            break;
    }
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
        case 1:
            return 3;
            break;
            return 3;
            break;
        case 2:
            return 4;
            break;
        case 3:
        case 4:
            return 1;
            break;
        default:
            break;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}


- (NDImagePickerUtils *)imagePicker {
    if (_imagePicker == nil) {
        _imagePicker = [[NDImagePickerUtils alloc] init];
    }
    return _imagePicker;
}

- (NDDateCheckViewController *)dateUtils {
    if (_dateUtils == nil) {
        _dateUtils = [[NDDateCheckViewController alloc] init];
        
        __weak typeof(self) weakSelf = self;
        _dateUtils.callBack = ^(NSDate * date,NSString *strDate) {
            weakSelf.model.happenTime = strDate;
            [weakSelf.tblList reloadData];
        };
    }
    return _dateUtils;
}

@end
