//
//  NDHUD.h
//  Gdims2
//
//  Created by 李青松 on 2018/3/1.
//  Copyright © 2018年 name. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>

#define ND_LOADING_TEXT     @"加载中..."
#define NDHUD_DELAY_TIME    1.6
@interface NDHUD : NSObject
//MBProgressHUD
/**正确 [delay>0 自动移除,否则需要手动移除]*/
+ (MBProgressHUD *)MBShowSuccessInView:(UIView *)view text:(NSString *)text delay:(NSTimeInterval)delay;
/**错误 [delay>0 自动移除,否则需要手动移除]*/
+ (MBProgressHUD *)MBShowFailureInView:(UIView *)view text:(NSString *)text delay:(NSTimeInterval)delay;
/**加载 [delay>0 自动移除,否则需要手动移除]*/
+ (MBProgressHUD *)MBShowLoadingInView:(UIView *)view text:(NSString *)text delay:(NSTimeInterval)delay;
+ (void)MBHideForView:(UIView *)view animate:(BOOL)animate;
@end
