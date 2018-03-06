//
//  NDViewController.h
//  Gdims2
//
//  Created by apple on 2018/3/5.
//  Copyright © 2018年 name. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NDViewController : UIViewController
@property (nonatomic, assign) BOOL onceLoad;
- (void)nd_refreshAction;
- (void)configNavBarLeftMenuWithImage:(NSString *)imgName;
- (void)leftMenuButtonAction;
- (void)rightMenuButtonAction;
- (void)showHotLineButton;
@end
