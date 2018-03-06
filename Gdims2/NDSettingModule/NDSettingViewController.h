//
//  NDSettingViewController.h
//  Gdims2
//
//  Created by apple on 2018/3/5.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDViewController.h"
@protocol NDSettingDelegate<NSObject>
@optional
- (void)ndSettingViewControllerDismissed;
@end
@interface NDSettingViewController : NDViewController
@property(nonatomic,weak) id<NDSettingDelegate> delegate;
@end
