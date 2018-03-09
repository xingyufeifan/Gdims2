//
//  NDMacroUploadViewController.m
//  Gdims2
//
//  Created by apple on 2018/3/7.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDMacroUploadViewController.h"
#import "NDMacroListModel.h"
#import "NDMacroCell.h"
#import "NDMonitorCell.h"
#import "NDSingleTextHeader.h"
#import "NDRemarkInputCell.h"
#import "UIImage+ND.h"
@interface NDMacroUploadViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,NDMacroCellDelegate,NDMonitorCellDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UIButton *btnUpload;
@property (weak, nonatomic) IBOutlet UILabel *lblLon;
@property (weak, nonatomic) IBOutlet UILabel *lblLat;

@property (nonatomic,strong) NSMutableArray<NDMacroModel *> * arrMacroModelList;
@property (nonatomic,strong) NDMacroModel * otherMacroModel;
@property (nonatomic, assign) NSInteger imageIndex;
@property (nonatomic, strong) NDImagePickerUtils *imagePicker;
@property (nonatomic, assign) BOOL saved;
@property (nonatomic,strong) NSMutableArray<NDMacroModel *> * arrNeedUpload;
@property (nonatomic, assign) NSInteger successCount;
@property (nonatomic, strong) NSString * strRemark;

@property (nonatomic, strong) MBProgressHUD * hud;

@end

@implementation NDMacroUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hud = nil;
    self.saved = NO;
    self.arrNeedUpload = [NSMutableArray array];
    self.strRemark = [self remarkCache];
    self.arrMacroModelList = [NSMutableArray array];
    self.otherMacroModel = nil;
    self.title = @"宏观观测";
    [self showHotLineButton];
    [self.tableView registerNib:[UINib nibWithNibName:@"NDMacroCell" bundle:nil] forCellReuseIdentifier:@"NDMacroCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"NDRemarkInputCell" bundle:nil] forCellReuseIdentifier:@"NDRemarkInputCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"NDSingleTextHeader" bundle:nil] forHeaderFooterViewReuseIdentifier:@"NDSingleTextHeader"];
    //iOS 11.1 TableView刷新问题
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.btnSave.backgroundColor = [UIColor nd_buttonColor];
    self.btnSave.layer.cornerRadius = 5;
    self.btnSave.layer.masksToBounds = YES;
    self.btnUpload.backgroundColor = [UIColor nd_buttonColor];
    self.btnUpload.layer.cornerRadius = 5;
    self.btnUpload.layer.masksToBounds = YES;
    if (self.listModel) {
        for (NSString * name in [self.listModel zx_macroList]) {
            NDMacroModel *model = [[NDMacroModel alloc] init];
            model.name = name;
            model.imageFileName = nil;
            model.unifiedNumber = self.listModel.unifiedNumber;
            model.checked = NO;
            [model loadCache];
            if (model.imageFileName || model.zx_otherData || model.checked) {//之前保存过数据
                self.saved = YES;
            }
            if (model.zx_isOther) {
                self.otherMacroModel = model;
            }
            [self.arrMacroModelList addObject:model];
        }
    }
    if (self.strRemark && ![self.strRemark zx_isEmpty]) {
        self.saved = YES;
    }
    if (_location) {
        self.lblLon.text = [NSString stringWithFormat:@"%f",_location.coordinate.longitude];
        self.lblLat.text = [NSString stringWithFormat:@"%f",_location.coordinate.latitude];
    }
    [self configNavBarLeftMenuWithImage:@"zx_navback"];
}

- (void)leftMenuButtonAction {
    if (self.arrMacroModelList.count > 0) {
        if (!self.saved) {//返回时未点击保存，删除缓存图片。
            for (NDMacroModel * model in self.arrMacroModelList) {
                [model clearCache];
            }
            [self clearRemark];
        } else {//返回时之前保存过，再次自动保存
            for (NDMacroModel * model in self.arrMacroModelList) {
                if ([model.name isEqualToString:@"其他现象"]) {
                    if ([model zx_otherData]) {
                        [model save];
                    }
                } else if (model.imageFileName) {
                    [model save];
                }
            }
            [self saveRemark];
        }
    }
    [self.navigationController popViewControllerAnimated:true];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
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
        }else{
            [NDLocationUtils showOpenSettingUp:self];
        }
    }];
}
- (void)setLocation:(CLLocation *)location{
    _location = location;
    if (_location) {
        self.lblLon.text = [NSString stringWithFormat:@"%f",_location.coordinate.longitude];
        self.lblLat.text = [NSString stringWithFormat:@"%f",_location.coordinate.latitude];
    }
}
- (NSString *)remarkKey{
    return [NSString stringWithFormat:@"NDMacro%@_Remark",[NDUserInfo sharedInstance].mobile];
}
- (NSString *)remarkCache{
    id remark = [[NSUserDefaults standardUserDefaults] objectForKey:[self remarkKey]];
    if (remark && [remark isKindOfClass:[NSString class]]) {
        return remark;
    }
    return  nil;
}
- (void)saveRemark{
    if (self.strRemark && ![self.strRemark zx_isEmpty]) {
        [[NSUserDefaults standardUserDefaults] setObject:self.strRemark forKey:[self remarkKey]];
    }else{
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:[self remarkKey]];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)clearRemark{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[self remarkKey]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
#warning 保存信息
- (IBAction)btnSaveClick {
    [self.view endEditing:true];
    [self setNeedsStatusBarAppearanceUpdate];
    self.saved = false;
    if (self.listModel && self.arrMacroModelList.count > 0) {
        NSMutableArray<NDMacroModel *> * arrCheckedModel = [NSMutableArray array];
        for (NDMacroModel * model in self.arrMacroModelList) {
            if (model.zx_hasValue){
                [arrCheckedModel addObject:model];
            }
        }
        if (arrCheckedModel.count) {//宏观现象、其他现象 有值
            for (NDMacroModel * model in arrCheckedModel) {
                if (model.zx_hasValue) {//图片改为选填
                    [model save];
                }
            }
            [self saveRemark];
            [NDHUD MBShowSuccessInView:[NDRouter window] text:@"保存成功" delay:NDHUD_DELAY_TIME];
            self.saved = true;
        } else {
            if (self.strRemark && ![self.strRemark zx_isEmpty]) {//备注有值
                [self saveRemark];
                [NDHUD MBShowSuccessInView:[NDRouter window] text:@"保存成功" delay:NDHUD_DELAY_TIME];
                self.saved = true;
            } else {
                [NDHUD MBShowFailureInView:[NDRouter window] text:@"请选择需要保存的数据或图片" delay:NDHUD_DELAY_TIME];
            }
        }
    } else {
        [NDHUD MBShowFailureInView:[NDRouter window] text:@"观测数据不存在" delay:NDHUD_DELAY_TIME];
    }
}
#warning 上传信息
- (IBAction)btnUploadClick {
    [self setNeedsStatusBarAppearanceUpdate];
    [self.view endEditing:true];
    if (self.listModel == nil) {
        [NDHUD MBShowFailureInView:[NDRouter window] text:@"宏观数据不存在" delay:NDHUD_DELAY_TIME];
        return;
    }
    [_arrNeedUpload removeAllObjects];
    self.successCount = 0;
    //搜集填写了值的Model
    for (NDMacroModel * model in self.arrMacroModelList) {
        if (model.zx_hasValue){//if (model.imageFileName && model.checked) 修改无无图也可以上传
            [_arrNeedUpload addObject:model];
        }
    }
    NSInteger totalCount = [_arrNeedUpload count];
    if (totalCount > 0) {
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
        NSString * date = [NSString zx_currentDateString];
        NSString * serialNo = [NSString zx_serialNumber];
        //[ZXHUD MBShowLoadingInView:[ZXRouter window] text:@"数据上传中..." delay:0];
        self.hud = [NDHUD MBShowLoadingInView:[NDRouter window] text:@"数据上传中..." delay:0];
        [self startLoadWithIndex:0 totalCount:totalCount serialNo:serialNo latitude:latitude longitude:longitude date:date];//逐条
    }else{
        if (self.strRemark && ![self.strRemark zx_isEmpty] && !self.saved) {//有备注
            [NDHUD MBShowFailureInView:[NDRouter window] text:@"上传前,请先保存数据" delay:NDHUD_DELAY_TIME];
            return;
        }
        NSString * latitude = nil;
        NSString * longitude = nil;
        if (self.location != nil) {
            latitude = [NSString stringWithFormat:@"%f",self.location.coordinate.latitude];
            longitude = [NSString stringWithFormat:@"%f",self.location.coordinate.longitude];
        }
        [NDHUD MBShowLoadingInView:[NDRouter window] text:@"数据上传中..." delay:0];
        [NDRequestApi uploadMacroMoDataWithRIndex:-1
                                           mobile:[NDUserInfo sharedInstance].mobile
                                         serialNo:[NSString zx_serialNumber]
                                        longitude:longitude
                                         latitude:latitude
                            macroscopicPhenomenon:@"无异常"
                                    unifiedNumber:self.listModel.unifiedNumber
                                     monPointDate:[NSString zx_currentDateString]
                                       totalCount:@"0"
                                            image:nil
                                         fileName:nil
                                   otherPhenomena:nil
                                          remarks:self.strRemark
                                       completion:^(NSInteger status, BOOL success, NSString *errorMsg, NSInteger requestIndex) {
                                           [NDHUD MBHideForView:[NDRouter window] animate:false];
                                           if (success) {
                                               [self clearRemark];
                                               [NDHUD MBShowSuccessInView:[NDRouter window] text:@"数据上传成功" delay:NDHUD_DELAY_TIME];
                                               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                   [self.navigationController popViewControllerAnimated:true];
                                               });
                                           } else {
                                               [NDHUD MBShowFailureInView:[NDRouter window] text:@"数据上传失败,请重试" delay:2.0];
                                           }
                                       }];
    }
}
- (void)startLoadWithIndex:(NSInteger)index
                totalCount:(NSInteger)totalCount
                  serialNo:(NSString *)serialNo
                  latitude:(NSString *)latitude
                 longitude:(NSString *)longitude
                      date:(NSString *)date{
    if (index < totalCount && index >= 0 ) {
        if (self.hud) {
            self.hud.label.text = [NSString stringWithFormat:@"数据上传中:%ld/%ld",(long)index,(long)totalCount];
        }
        NDMacroModel * model = [_arrNeedUpload objectAtIndex:index];
        UIImage * image = [UIImage imageWithContentsOfFile:model.zx_imageAbsolutePath];
        
        [NDRequestApi uploadMacroMoDataWithRIndex:index
                                            mobile:[NDUserInfo sharedInstance].mobile
                                          serialNo:serialNo
                                         longitude:longitude
                                          latitude:latitude
                             macroscopicPhenomenon:model.name
                                     unifiedNumber:model.unifiedNumber
                                      monPointDate:date
                                        totalCount:[NSString stringWithFormat:@"%ld",(long)totalCount]
                                            image:image
                                          fileName:model.imageFileName
                                    otherPhenomena:self.otherMacroModel.zx_otherData
                                           remarks:self.strRemark
                                        completion:^(NSInteger status, BOOL success, NSString *errorMsg, NSInteger requestIndex) {
                                            if (success) {
                                                [self uploadSuccessWithIndex:requestIndex];
                                                if ((requestIndex + 1) < totalCount) {
                                                    [self startLoadWithIndex:(requestIndex + 1) totalCount:totalCount serialNo:serialNo latitude:latitude longitude:longitude date:date];
                                                }
                                            } else {
                                                //必须保证全部成功
                                                [NDHUD MBHideForView:[NDRouter window] animate:true];
                                                self.successCount = 0;
                                                [NDHUD MBShowFailureInView:[NDRouter window] text: @"上传失败,请重新上传" delay:NDHUD_DELAY_TIME];
                                            }
                                        }];
    } else {
        [NDHUD MBHideForView:[NDRouter window] animate:YES];
    }
}


- (void)uploadSuccessWithIndex:(NSInteger)index {
    if (_arrNeedUpload.count > 0) {
        self.successCount += 1;
    }
    [self checkEndAction];
}

- (void)checkEndAction {
    NSInteger totalCount = _arrNeedUpload.count;
    if (totalCount > 0) {
        if (self.successCount == totalCount) {
            [NDHUD MBHideForView:[NDRouter window] animate:NO];
            [NDHUD MBShowSuccessInView:[NDRouter window] text:@"数据上传成功" delay:NDHUD_DELAY_TIME];
            for (NDMacroModel * model in _arrNeedUpload) {
                [model clearCache];
            }
            [self clearRemark];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.45 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    } else {
        [NDHUD MBHideForView:[NDRouter window] animate:YES];
    }
}

#pragma mark tableView数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {//现象展示
        NSInteger count = self.arrMacroModelList.count;
        if (count > 0) {
            return count;
        }
    }else if(section == 1){//其他现象
        if (self.otherMacroModel && self.otherMacroModel.checked) {
            return 1;
        } else {
            return 0;
        }
    }else if(section == 2){//备注
        return 1;
    }
    return  0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {//其他现象
        if (self.otherMacroModel && self.otherMacroModel.checked) {
            NDSingleTextHeader * header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"NDSingleTextHeader"];
            [header.lbLine setHidden:true];
            header.contentView.backgroundColor = NDCOLOR_RGB(235, 237, 236, 1);
            header.lbText.textColor = [UIColor nd_tintColor];
            header.lbText.text = @"其他现象";
            return header;
        } else {
            return nil;
        }
    } else if (section == 2) {
        NDSingleTextHeader * header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"NDSingleTextHeader"];
        header.contentView.backgroundColor = NDCOLOR_RGB(235, 237, 236, 1);
        [header.lbLine setHidden:true];
        header.lbText.textColor = [UIColor nd_tintColor];
        header.lbText.text = @"备注";
        return header;
    }
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NDMacroCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NDMacroCell" forIndexPath:indexPath];
        cell.contentView.backgroundColor = [UIColor nd_whiteColor];
        cell.delegate = self;
        [cell reloadData:self.arrMacroModelList[indexPath.row]];
        return cell;
    }else{
        NDRemarkInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NDRemarkInputCell" forIndexPath:indexPath];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.txtContent.text = nil;
        cell.delegate = self;
        if (indexPath.section == 1) {//其他现象
            cell.txtContent.text = self.otherMacroModel.zx_otherData;
        } else if (indexPath.section == 2) {//备注
            cell.txtContent.text = self.strRemark;
        }
        return cell;
    }
    return [[UITableViewCell alloc] init];
}
#pragma mark tableView代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 120;
    } else if (indexPath.section == 1) {
        if (self.otherMacroModel && self.otherMacroModel.checked) {
            return 60;
        }
    } else if (indexPath.section == 2) {
        return 180;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {//其他现象
        if (self.otherMacroModel && self.otherMacroModel.checked) {
            return 40;
        }
        return CGFLOAT_MIN;
    } else if (section == 2) {//备注
        return 40;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark monitorCell代理方法
- (void)ndMonitorCell:(UITableViewCell *)cell inputDoneWtih:(NSString *)text{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.section == 1) {//其他现象
        if (self.otherMacroModel) {
            if (text && ![text zx_isEmpty]) {
                self.otherMacroModel.zx_otherData = text;
            } else {
                self.otherMacroModel.zx_otherData = nil;
            }
        }
    } else if (indexPath.section == 2) {//备注
        self.strRemark = text;
        if (self.strRemark == nil || [self.strRemark zx_isEmpty]) {
            [self clearRemark];
        }
    }
}
#pragma mark macroCell代理方法
//是否选中
- (void)ndMacroCell:(NDMacroCell *)cell checked:(BOOL)checked{

    NSIndexPath *indexpath = [self.tableView indexPathForCell:cell];
    if (indexpath) {
        NDMacroModel *model = self.arrMacroModelList[indexpath.row];
        model.checked = checked;
        if (checked == false) {//取消选中时，删除已选择的图片和缓存
            if (model.zx_isOther) {
                [model otherUnCheckAction];
                self.otherMacroModel.zx_otherData = nil;
            } else {
                [model clearCache];
            }
            [cell.imgView setImage:[UIImage imageNamed:@"zx-img-default"]];
            
        }
        if (model.zx_isOther) {//控制其他现象输入框显示
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}
//拍照
- (void)ndMacroCellTakePhoto:(NDMacroCell *)cell{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    self.imageIndex = indexPath.row;
    [self takePhotoAciton];
}
- (void)takePhotoAciton {
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
- (void)setImageAction:(UIImage *)image1 {
    [NDHUD MBShowLoadingInView:[NDRouter window] text:@"图片处理中..." delay:0];
    UIImage * zxImage = [UIImage fixOrientation:image1];
    [NDFileUtils saveImage:zxImage completion:^(BOOL success, NSString *fileName) {
        [NDHUD MBHideForView:[NDRouter window] animate:true];
        if (success) {
            NDMacroModel * model = self.arrMacroModelList[_imageIndex];
            model.checked = true;
            if (model.imageFileName) {
                [NDFileUtils deleteFileWithPath:model.zx_imageAbsolutePath];
            }
            model.imageFileName = fileName;
            [self.tableView reloadData];
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
@end
