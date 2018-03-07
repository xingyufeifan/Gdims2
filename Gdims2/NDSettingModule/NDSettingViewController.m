//
//  NDSettingViewController.m
//  Gdims2
//
//  Created by apple on 2018/3/5.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDSettingViewController.h"
#import "NDSettingCell.h"
#import "NDSettingHeaderCell.h"
#import "NDSlideInAnimationController.h"
#import "NDSlideOutAnimationController.h"
#import "NDDimmingPresentaionController.h"
#import "NDLocationSettingViewController.h"
@interface NDSettingViewController ()<UIViewControllerTransitioningDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *lblAccount;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *lblTile;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (nonatomic, strong) NSArray * iconList;
@property (nonatomic, strong) NSArray * titleList;
@end

@implementation NDSettingViewController
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self setModalPresentationStyle:UIModalPresentationCustom];
        self.transitioningDelegate = self;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _iconList = @[@"zx_st_update",@"zx_st_set",@"zx_st_location",@"zx_st_clear",@"zx_st_logout"];
    _titleList = @[@"检查更新",@"参数设置",@"定位设置",@"清除缓存",@"注销登录"];
    [self.tableView registerNib:[UINib nibWithNibName:@"NDSettingCell" bundle:nil] forCellReuseIdentifier:@"NDSettingCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"NDSettingHeaderCell" bundle:nil] forHeaderFooterViewReuseIdentifier:@"NDSettingHeaderCell"];
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0 );
    self.tableView.backgroundColor = [UIColor nd_backgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.lblTile.textColor = [UIColor nd_tintColor];
    self.lblAccount.text = [[NDUserInfo sharedInstance] mobile];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.contentView];
    if (!CGRectContainsPoint(self.contentView.frame, point)) {
        [self dismissViewControllerAnimated:true completion:^{
            if (_delegate && [_delegate respondsToSelector:@selector(ndSettingViewControllerDismissed)]) {
                [_delegate ndSettingViewControllerDismissed];
            }
        }];
    }
}



#pragma mark - 数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else{
        return 2;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NDSettingCell * cell = [tableView dequeueReusableCellWithIdentifier:@"NDSettingCell" forIndexPath:indexPath];
    NSInteger index = indexPath.section * 3 + indexPath.row;
    cell.image.image = [UIImage imageNamed:_iconList[index]];
    cell.lblTitle.text = _titleList[index];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView * header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"NDSettingHeaderCell"];
        return header;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 40;
    }
    return  CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
#pragma mark -   动画代理方法
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [[NDSlideInAnimationController alloc] init];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[NDSlideOutAnimationController alloc] init];
}

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source{
    return [[NDDimmingPresentaionController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
}

#pragma mark - 代理方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (indexPath.section) {
            case 0:
            {
                switch (indexPath.row) {
                    case 0://检查更新
                        
                        break;
                    case 1://参数设置
                        
                        break;
                    case 2://定位设置
                    {
                        NDLocationSettingViewController *locationController = [[NDLocationSettingViewController alloc] init];
                        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:locationController];
                        [self presentViewController:nvc animated:YES completion:nil];
                    }
                        break;
                    default:
                        break;
                }
            }
                break;
            case 1:
            {
                switch (indexPath.row) {
                    case 0://清除缓存
                        
                        break;
                    case 1://注销登录
                    {//todo
                        [[NDUserInfo sharedInstance] loginOut:^{
                            [NDRouter setRootViewWithType:NDRouterTypeLogin];
                        }];
                    }
                        break;
                    default:
                        break;
                }
            }
                break;
            default:
                break;
        }
    });
}


@end
