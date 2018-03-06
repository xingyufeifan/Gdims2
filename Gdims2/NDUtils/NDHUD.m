//
//  NDHUD.m
//  Gdims2
//
//  Created by 李青松 on 2018/3/1.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDHUD.h"
#import <MBProgressHUD/MBProgressHUD.h>

@implementation NDHUD

//MARK: - MB
+ (MBProgressHUD *)MBShowSuccessInView:(UIView *)view text:(NSString *)text delay:(NSTimeInterval)delay{
    MBProgressHUD * mbp = [MBProgressHUD showHUDAddedTo:view animated:true];
    mbp.mode = MBProgressHUDModeCustomView;
    mbp.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Ltrue"]];
    mbp.label.text = text;
    mbp.label.font = [UIFont systemFontOfSize:15];
    mbp.minSize = CGSizeMake(100, 100);
    mbp.label.textColor = [UIColor whiteColor];
    mbp.bezelView.layer.cornerRadius = 10.0;
    mbp.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    mbp.bezelView.color = NDCOLOR_RGB(0, 0, 0, 0.7);
    if (delay > 0) {
        [mbp hideAnimated:true afterDelay:delay];
    }
    mbp.removeFromSuperViewOnHide = true;
    return mbp;
}

+ (MBProgressHUD *)MBShowFailureInView:(UIView *)view text:(NSString *)text delay:(NSTimeInterval)delay{
    MBProgressHUD * mbp = [MBProgressHUD showHUDAddedTo:view animated:true];
    mbp.mode = MBProgressHUDModeCustomView;
    mbp.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Lmistake"]];
    mbp.label.text = text;
    mbp.label.font = [UIFont systemFontOfSize:15];
    mbp.minSize = CGSizeMake(100, 100);
    mbp.label.textColor = [UIColor whiteColor];
    mbp.bezelView.layer.cornerRadius = 10.0;
    mbp.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    mbp.bezelView.color = NDCOLOR_RGB(0, 0, 0, 0.7);
    if (delay > 0) {
        [mbp hideAnimated:true afterDelay:delay];
    }
    mbp.removeFromSuperViewOnHide = true;
    return mbp;
}

+ (MBProgressHUD *)MBShowLoadingInView:(UIView *)view text:(NSString *)text delay:(NSTimeInterval)delay{
    MBProgressHUD * mbp = [MBProgressHUD showHUDAddedTo:view animated:true];
    mbp.mode = MBProgressHUDModeCustomView;
    UIImageView * customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Loading"]];
    CABasicAnimation * anima = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    anima.toValue = @(M_PI*2);
    anima.duration = 1.0f;
    anima.repeatCount = NSUIntegerMax;
    anima.removedOnCompletion = false;
    [customView.layer addAnimation:anima forKey:nil];
    mbp.customView = customView;
    mbp.label.text = text;
    mbp.label.font = [UIFont systemFontOfSize:15];
    mbp.minSize = CGSizeMake(100, 100);
    mbp.label.textColor = [UIColor whiteColor];
    mbp.bezelView.layer.cornerRadius = 10.0;
    mbp.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    mbp.bezelView.color = NDCOLOR_RGB(0, 0, 0, 0.7);
    if (delay > 0) {
        [mbp hideAnimated:true afterDelay:delay];
    }
    mbp.removeFromSuperViewOnHide = true;
    return mbp;
}

+ (void)MBHideForView:(UIView *)view animate:(BOOL)animate{
    [MBProgressHUD hideHUDForView:view animated:animate];
}

@end
