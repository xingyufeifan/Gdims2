//
//  NDAlertUtils.m
//  Gdims2
//
//  Created by 李青松 on 2018/3/7.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDAlertUtils.h"

@implementation NDAlertUtils

+ (void)showAAlertMessage:(NSString *)msg title:(NSString *)title{
    NSString * strT = title;
    if (!title) {
        strT = @"提示";
    }
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:strT message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
    [[self keyController] presentViewController:alert animated:true completion:nil];
}

+ (UIViewController *)keyController{
    UIViewController * keyController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    do{
        if (keyController.presentedViewController) {
            keyController = keyController.presentedViewController;
        }else{
            break;
        }
    }while(keyController.presentedViewController);
    return keyController;
}

+ (void)showAAlertMessage:(NSString *)msg title:(NSString *)title buttonText:(NSString *)buttonText buttonAction:(void (^)(void))buttonAction{
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title ? title : @"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:buttonText ? buttonText :@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (buttonAction) {
            buttonAction();
        }
    }]];
    [[self keyController] presentViewController:alert animated:true completion:nil];
}

+ (void)showAAlertMessage:(NSString *)msg title:(NSString *)title buttonTexts:(NSArray *)arrTexts buttonAction:(void (^)(int buttonIndex))buttonAction{
    
    if (arrTexts && arrTexts.count) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:title ? title : @"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
        int index = 0;
        for (NSString * strText in arrTexts) {
            [alert addAction:[UIAlertAction actionWithTitle:strText ? strText :@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (buttonAction) {
                    buttonAction(index);
                }
            }]];
            index++;
        }
        [[self keyController] presentViewController:alert animated:true completion:nil];
    }
}

+ (void)showActionSheetMsg:(NSString *)msg title:(NSString *)title buttonTexts:(NSArray *)arrTexts buttonAction:(void (^)(int))buttonAction {
    if (arrTexts && arrTexts.count) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleActionSheet];
        int index = 0;
        for (NSString * strText in arrTexts) {
            [alert addAction:[UIAlertAction actionWithTitle:strText ? strText :@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (buttonAction) {
                    buttonAction(index);
                }
            }]];
            index++;
        }
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (buttonAction) {
                buttonAction(arrTexts.count);
            }
        }]];
        [[self keyController] presentViewController:alert animated:true completion:nil];
    }
    
}
@end
