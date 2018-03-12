//
//  NDMonitorUploadViewController.m
//  Gdims2
//
//  Created by apple on 2018/3/7.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDMonitorUploadViewController.h"
#import "NDMonitorCell.h"
#import "NDMonitorModel.h"
#import "UIImage+ND.h"
#import "NDMacroListModel.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
@interface NDMonitorUploadViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,NDMonitorCellDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UIButton *btnUpload;
@property (nonatomic, strong) UIView * footerView;
@property (nonatomic, strong) UIImageView * imgPhoto;
@property (nonatomic, strong) UIButton * btnTakePhoto;

@property (nonatomic, strong) NDImagePickerUtils * imagePicker;
@property (nonatomic, strong) NSString * strDate;
@property (nonatomic, assign) BOOL resetRailfall;
@property (nonatomic, assign) BOOL saved;
@end

@implementation NDMonitorUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.resetRailfall = false;
    self.strDate = [NSString zx_currentDateString];
    self.title = @"定量监测";
    [self showHotLineButton];
    [self.tableView setBackgroundColor:[UIColor nd_backgroundColor]];
    [self.tableView registerNib:[UINib nibWithNibName:@"NDMonitorCell" bundle:nil] forCellReuseIdentifier:@"NDMonitorCell"];
    self.btnSave.backgroundColor = [UIColor nd_buttonColor];
    self.btnSave.layer.cornerRadius = 5;
    self.btnSave.layer.masksToBounds = YES;
    self.btnUpload.backgroundColor = [UIColor nd_buttonColor];
    self.btnUpload.layer.cornerRadius = 5;
    self.btnUpload.layer.masksToBounds = YES;
    CGFloat zxWidth = [UIScreen mainScreen].bounds.size.width;
    //CGFloat zxHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat imageWdth = zxWidth - 120;
    _footerView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, zxWidth, imageWdth)];
    _footerView.backgroundColor = [UIColor nd_backgroundColor];
    _imgPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(60, 0, imageWdth, imageWdth)];
    _imgPhoto.backgroundColor = [UIColor clearColor];
    _imgPhoto.contentMode = UIViewContentModeScaleAspectFit;
    _imgPhoto.clipsToBounds = true;
    [_footerView addSubview:_imgPhoto];
    
    _btnTakePhoto = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnTakePhoto.backgroundColor = [UIColor clearColor];
    _btnTakePhoto.frame = CGRectMake(60, 0, imageWdth, imageWdth);
    [_btnTakePhoto setBackgroundImage:[UIImage imageNamed:@"zx-img-add"] forState:UIControlStateNormal];
    [_btnTakePhoto addTarget:self action:@selector(takePhotoAciton) forControlEvents:UIControlEventTouchUpInside];
    [_footerView addSubview:_btnTakePhoto];
    
    [self.tableView setTableFooterView:_footerView];
    self.saved = false;
    if (self.monitorModel) {
        [self.monitorModel loadCache];
        if (self.monitorModel.imageFileName || self.monitorModel.zx_inputData) {//之前保存过数据
            self.saved = true;
        }
        if (self.monitorModel.imageFileName) {
            [self.imgPhoto setImageWithURL:self.monitorModel.imageUrl];
            [self.btnTakePhoto setBackgroundImage:nil forState:UIControlStateNormal];
        }
    }
    [self configNavBarLeftMenuWithImage:@"zx_navback"];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)leftMenuButtonAction {
    if (self.monitorModel) {
        if (!self.saved) {
            [self.monitorModel clearCache];
        } else {
            [self.monitorModel save];
        }
    }
    [self.navigationController popViewControllerAnimated:true];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    [self.navigationController.interactivePopGestureRecognizer setEnabled:true];
    [NDLocationUtils checkService:^(BOOL success, NSString *errorMsg) {
        if (success) {
            [[NDLocationUtils shareInstance] checkCurrentLocation:^(BOOL success, CLLocation *location) {
                if (success) {
                    self.location = location;
                    NSLog(@"%@",self.location);
                }
            }];
        } else {
            [NDLocationUtils showOpenSettingUp:self];
        }
    }];
}
- (void)takePhotoAciton {
    
    if (self.monitorModel.imageFileName) {
        NSLog(@"开始拍照imageFileName不为空");
        [NDAlertUtils showActionSheetMsg:nil title:@"获取照片" buttonTexts:@[@"拍照",@"删除"] buttonAction:^(int buttonIndex) {
            if (buttonIndex == 0) {
                [self takePhoto];
            }
            //else if (buttonIndex == 1) {
            //    [self choosePhoto];
            //}
            else if (buttonIndex == 1) {
                [NDFileUtils deleteFileWithPath:self.monitorModel.zx_imageAbsolutePath];
                self.monitorModel.imageFileName = nil;
                [self.monitorModel save];
                [self.btnTakePhoto setBackgroundImage:[UIImage imageNamed:@"zx-img-add"] forState:UIControlStateNormal];
                [self.imgPhoto setImage:nil];
                
            }
        }];
    } else {
        [self takePhoto];//不允许相册取
        
        /*
         [ZXAlertUtils showActionSheetMsg:nil title:@"获取照片" buttonTexts:@[@"拍照",@"从相册取"] buttonAction:^(int buttonIndex) {
         if (buttonIndex == 0) {
         [self takePhoto];
         } else if (buttonIndex == 1) {
         [self choosePhoto];
         }
         }];
         */
    }
    
}

- (void)takePhoto {
    __weak typeof(self) weakSelf = self;
    [self.imagePicker takePhotoUponVC:self callBack:^(UIImage *image, ZXTakePhotoStatus status, NSString *errorMsg) {
        [weakSelf setNeedsStatusBarAppearanceUpdate];
        if (status == ZXPSuccess) {
            [weakSelf setImageAction:image];
        } else {
            if (status != ZXPCanceled) {
                [NDHUD MBShowFailureInView:[NDRouter window] text:errorMsg delay:NDHUD_DELAY_TIME];
            }
        }
    }];
    
}

- (void)choosePhoto {
    __weak typeof(self) weakSelf = self;
    [self.imagePicker choosePhotoUponVC:self callBack:^(UIImage *image, ZXTakePhotoStatus status, NSString *errorMsg) {
        [weakSelf setNeedsStatusBarAppearanceUpdate];
        if (status == ZXPSuccess) {
            [weakSelf setImageAction:image];
        } else {
            if (status != ZXPCanceled) {
                [NDHUD MBShowFailureInView:[NDRouter window] text:errorMsg delay:NDHUD_DELAY_TIME];
            }
        }
    }];
}

- (void)setImageAction:(UIImage *)image1 {
    [NDHUD MBShowLoadingInView:[NDRouter window] text:@"图片处理中..." delay:0];
    UIImage * zxImage = [UIImage fixOrientation:image1];
    [NDFileUtils saveImage:zxImage completion:^(BOOL success, NSString *fileName) {
        [NDHUD MBHideForView:[NDRouter window] animate:true];
        if (success) {
            if (self.monitorModel.imageFileName) {
                [NDFileUtils deleteFileWithPath:self.monitorModel.zx_imageAbsolutePath];
            }
            self.monitorModel.imageFileName = fileName;
            [self.imgPhoto setImageWithURL:self.monitorModel.imageUrl];
            [self.btnTakePhoto setBackgroundImage:nil forState:UIControlStateNormal];
        } else {
            [NDHUD MBShowFailureInView:[NDRouter window] text:@"图片处理失败,请重拍照" delay:NDHUD_DELAY_TIME];
        }
    }];
}
- (NDImagePickerUtils *)imagePicker{
    if (_imagePicker == nil) {
        _imagePicker = [[NDImagePickerUtils alloc] init];
    }
    return _imagePicker;
}
- (IBAction)btnSaveClick {
    [self.view endEditing:true];
    self.saved = false;
    if (self.monitorModel) {
        if (self.monitorModel.zx_isMonitorRainValue) {//雨量监测
            UITableViewCell * rainfallCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];//雨量监测
            if (rainfallCell && [rainfallCell isKindOfClass:[NDMonitorCell class]]) {
                self.resetRailfall = [(NDMonitorCell *)rainfallCell zx_isResetRainFall];
            }
            self.monitorModel.zx_resetRainFall = self.resetRailfall;
        }
        UITableViewCell * inputCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];//输入值
        NSString * inputValue = nil;
        if (inputCell && [inputCell isKindOfClass:[NDMonitorCell class]]) {
            inputValue = [(NDMonitorCell *)inputCell zx_inputValue];
        }
        if (self.monitorModel.imageFileName == nil && inputValue == nil) {
            [NDHUD MBShowFailureInView:[NDRouter window] text:@"请添加数据" delay:NDHUD_DELAY_TIME];
            return;
        }
        //if (inputValue == nil) {
        //    [ZXHUD MBShowFailureInView:[ZXRouter window] text:[NSString stringWithFormat:@"请输入%@值",self.monitorModel.monType] delay:ZXHUD_DELAY_TIME];
        //    return;
        //}
        self.monitorModel.zx_inputData = inputValue;
        [self.monitorModel save];
        [NDHUD MBShowSuccessInView:[NDRouter window] text:@"保存成功" delay:NDHUD_DELAY_TIME];
        self.saved = true;
    } else {
        [NDHUD MBShowFailureInView:[NDRouter window] text:@"监测点数据不存在" delay:NDHUD_DELAY_TIME];
    }
}
#pragma  上传功能
- (IBAction)btnUploadClick {
    [self.view endEditing:YES];
    if (self.monitorModel) {
        if (self.monitorModel.zx_isMonitorRainValue) {//雨量监测
            UITableViewCell * rainfallCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];//雨量监测
            if (rainfallCell && [rainfallCell isKindOfClass:[NDMonitorCell class]]) {
                self.resetRailfall = [(NDMonitorCell *)rainfallCell zx_isResetRainFall];
            }
            self.monitorModel.zx_resetRainFall = self.resetRailfall;
        }
        UITableViewCell * inputCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];//输入值
        NSString * inputValue = nil;
        if (inputCell && [inputCell isKindOfClass:[NDMonitorCell class]]) {
            inputValue = [(NDMonitorCell *)inputCell zx_inputValue];
        }
        if (inputValue == nil) {
            [NDHUD MBShowFailureInView:[NDRouter window] text:@"信息填写不完整" delay:NDHUD_DELAY_TIME];
            return;
        }
        self.monitorModel.zx_inputData = inputValue;
        if (!self.saved) {
            [NDHUD MBShowFailureInView:[NDRouter window] text:@"上传前,请先保存数据" delay:NDHUD_DELAY_TIME];
            return;
        }
        NSString * latitude = nil;
        NSString * longitude = nil;
        if (self.location != nil) {
            latitude = [NSString stringWithFormat:@"%f",self.location.coordinate.latitude];
            longitude = [NSString stringWithFormat:@"%f",self.location.coordinate.longitude];
        }
        [NDHUD MBShowLoadingInView:[NDRouter window] text:@"正在上传数据..." delay:0];
        [NDRequestApi uploadMonitorDataWithMobile:[NDUserInfo sharedInstance].mobile
                                             type:self.monitorModel.zx_isMonitorRainValue ? NDDataUploadRainFallMonitor : NDDataUploadQuantiativeMonitor
                                        serialNum:[NSString zx_serialNumber]
                                        longitude:longitude
                                         latitude:latitude
                                    unifiedNumber:self.monitorModel.unifiedNumber
                                   monPointNumber:self.monitorModel.monPointNumber
                                     monPointDate:self.strDate
                                    resetRailfall:self.resetRailfall
                                     measuredData:inputValue
                                            image:self.imgPhoto.image
                                         fileName:self.monitorModel.imageFileName
                                       completion:^(NSInteger status, BOOL success, NSString *errorMsg) {
                                           [NDHUD MBHideForView:[NDRouter window] animate:false];
                                           if (success) {
                                               [NDHUD MBShowSuccessInView:[NDRouter window] text:@"数据上传成功" delay:NDHUD_DELAY_TIME];
                                               [self.monitorModel clearCache];
                                               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                   [self.navigationController popViewControllerAnimated:true];
                                               });
                                           } else {
                                               [NDHUD MBShowFailureInView:[NDRouter window] text:errorMsg delay:NDHUD_DELAY_TIME];
                                           }
                                       }];
    }else{
         [NDHUD MBShowFailureInView:[NDRouter window] text:@"监测点数据不存在" delay:NDHUD_DELAY_TIME];
    }
}
#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 5) {
        return 30;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return  CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NDMonitorCell * cell = [tableView dequeueReusableCellWithIdentifier:@"NDMonitorCell" forIndexPath:indexPath];
    cell.delegate = self;
    [cell.lineView setHidden:false];
    switch (indexPath.section) {
        case 0:
            [cell reloadLeftText:@"灾害点名称:" rightText:self.macroModel.name type:NDMonitorCellTypeLRLabel];
            break;
        case 1:
            [cell reloadLeftText:@"监测点名称:" rightText:self.monitorModel.monPointName type:NDMonitorCellTypeLRLabel];
            break;
        case 2:
            [cell reloadLeftText:@"清空雨量筒:" rightText:@"" type:NDMonitorCellTypeRainFall];
            cell.btnResetRainfall.selected  = [self.monitorModel zx_resetRainFall];
            break;
        case 3:
        {
            NSString * text = [NSString stringWithFormat:@"%@ (%@):",self.monitorModel.monType,self.monitorModel.dimension];
            cell.textType = NDInputTextTypeDecimal;
            [cell reloadLeftText:text rightText:[self.monitorModel zx_inputData] type:NDMonitorCellTypeTextField];
        }
            break;
        case 4:
            [cell reloadLeftText:@"发 生 日 期:" rightText:self.strDate type:NDMonitorCellTypeLRLabel];
            break;
        case 5:
            [cell reloadLeftText:@"最 新 情 况:" rightText:@"" type:NDMonitorCellTypeLLabel];
            [cell.lineView setHidden:true];
            break;
        default:
            break;
    }
    return  cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {//清空雨量筒
        if (self.monitorModel.zx_isMonitorRainValue) {
            return 1;
        } else {
            return 0;
        }
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

#pragma mark - ZXMonitorCellDelegate
-(void)ndMonitorCell:(UITableViewCell *)cell inputDoneWtih:(NSString *)text {
    self.monitorModel.zx_inputData = text;
}

- (void)ndMonitorCell:(UITableViewCell *)cell rainFallChecked:(BOOL)checked {
    self.monitorModel.zx_resetRainFall = checked;
}

@end
