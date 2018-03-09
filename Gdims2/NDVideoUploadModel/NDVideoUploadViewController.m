//
//  ZXVideoUploadViewController.m
//  QCQF
//
//  Created by screson on 2017/12/1.
//  Copyright © 2017年 screson. All rights reserved.
//

#import "NDVideoUploadViewController.h"
#import "KZVideoViewController.h"
#import "KZVideoPlayer.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

#import "NDVideoCheckCell.h"
#import "NDVideoModel.h"
@interface NDVideoUploadViewController () <NDVideoCheckCellDelegate,UITableViewDelegate, UITableViewDataSource,KZVideoViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tblList;
@property (weak, nonatomic) IBOutlet UIButton *btnRecord;
@property (weak, nonatomic) IBOutlet UIButton *btnUpload;

@property (nonatomic,strong) NSMutableArray<NDVideoModel *> * arrVideoList;

@end

@implementation NDVideoUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"视频列表";
    self.btnRecord.backgroundColor = [UIColor nd_tintColor];
    self.btnRecord.layer.cornerRadius = 5;
    
    self.btnUpload.backgroundColor = [UIColor nd_tintColor];
    self.btnUpload.layer.cornerRadius = 5;
    
    
    [self.tblList registerNib:[UINib nibWithNibName:@"NDVideoCheckCell" bundle:nil] forCellReuseIdentifier:@"NDVideoCheckCell"];
    self.arrVideoList = [NDVideoModel cacheList];
}

- (IBAction)recordAction:(id)sender {
    if (self.arrVideoList.count < 5) {
        KZVideoViewController *videoVC = [[KZVideoViewController alloc] init];
        videoVC.delegate = self;
        [videoVC startAnimationWithType:KZVideoViewShowTypeSingle];
    } else {
        [NDHUD MBShowFailureInView:self.view text:@"最多只能录制5段视频" delay:NDHUD_DELAY_TIME];
    }
}

- (NSArray<NDVideoModel *> *)zx_selected {
    NSMutableArray * arrSelected = [NSMutableArray array];
    if (self.arrVideoList && self.arrVideoList.count) {
        for (NDVideoModel * model in self.arrVideoList) {
            if (model.zx_checked) {
                [arrSelected addObject:model];
            }
        }
    }
    return arrSelected;
}

- (IBAction)uploadAction:(id)sender {
    NSArray * arrSelected = [self zx_selected];
    if (arrSelected.count > 0) {
        [NDHUD MBShowLoadingInView:[NDRouter window] text:@"上传中" delay:0];
        NSMutableArray<NSData *> * videoDatas = [NSMutableArray array];
        NSMutableArray<NSString *> * videoNames = [NSMutableArray array];
        for (NDVideoModel * model in arrSelected) {
            NSData * data = [NSData dataWithContentsOfURL:model.zx_videoUrl];
            if (data) {
                [videoDatas addObject:data];
                [videoNames addObject:model.name];
            }
        }
        [NDRequestApi uploadVideo:videoDatas fileNames:videoNames mobile:[NDUserInfo sharedInstance].mobile userType:[NDUserInfo sharedInstance].type completion:^(NSInteger status, BOOL success, NSString *errorMsg) {
            [NDHUD MBHideForView:[NDRouter window] animate:true];
            if (success) {
                [NDHUD MBShowSuccessInView:self.view text:@"上传成功" delay:NDHUD_DELAY_TIME];
                for (NDVideoModel * model in arrSelected) {
                    [model clearCache];
                    [self.arrVideoList removeObject:model];
                }
                [self.tblList reloadData];
            } else {
                [NDHUD MBShowFailureInView:self.view text:errorMsg delay:NDHUD_DELAY_TIME];
            }
        }];
    } else {
        [NDHUD MBShowFailureInView:self.view text:@"请选择需要上传的视频" delay:NDHUD_DELAY_TIME];
    }
}

#pragma mark - KZVideoViewControllerDelegate
- (void)videoViewController:(KZVideoViewController *)videoController didRecordVideo:(KZVideoModel *)videoModel {
    NDVideoModel * vModel = [[NDVideoModel alloc] init];
    vModel.name = [NSString stringWithFormat:@"%@.mp4",videoModel.zxVideoName];
    [vModel save];
    [self.arrVideoList addObject:vModel];
    [self.tblList reloadData];
}

- (void)videoViewControllerDidCancel:(KZVideoViewController *)videoController {
    NSLog(@"没有录到视频");
}

#pragma mark -
- (void)zxVideoCheckCell:(NDVideoCheckCell *)cell checked:(BOOL)checked {
    NSIndexPath * indexPath = [self.tblList indexPathForCell:cell];
    NDVideoModel * model = self.arrVideoList[indexPath.row];
    model.zx_checked = checked;
}

#pragma mark UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NDVideoModel * model = self.arrVideoList[indexPath.row];
    [self playVideoWithURL:model.zx_videoUrl];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NDVideoCheckCell * cell = [self.tblList dequeueReusableCellWithIdentifier:@"NDVideoCheckCell" forIndexPath:indexPath];
    cell.delegate = self;
    NDVideoModel * model = self.arrVideoList[indexPath.row];
    [cell reloadData:model];
    return  cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.arrVideoList && self.arrVideoList.count) {
        return self.arrVideoList.count;
    }
    return 0;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return true;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [NDAlertUtils showAAlertMessage:@"确定删除该段视频" title:@"提示" buttonTexts:@[@"删除", @"取消"] buttonAction:^(int buttonIndex) {
            if (buttonIndex == 0) {
                NDVideoModel * model = self.arrVideoList[indexPath.row];
                [model clearCache];
                [self.arrVideoList removeObjectAtIndex:indexPath.row];
                [self.tblList deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }];
    }
}

- (void)playVideoWithURL:(NSURL *)url {
    AVPlayer *player1 = [AVPlayer playerWithURL:url];
    AVPlayerViewController *playerVC = [[AVPlayerViewController alloc]init];
    playerVC.player = player1;
    //4、跳转到控制器播放
    [self presentViewController:playerVC animated:YES completion:nil];
    [playerVC.player play];
}


@end
