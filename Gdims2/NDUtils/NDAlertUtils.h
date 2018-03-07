//
//  NDAlertUtils.h
//  Gdims2
//
//  Created by 李青松 on 2018/3/7.
//  Copyright © 2018年 name. All rights reserved.
//

#import <Foundation/Foundation.h>

/**警告框工具类*/
@interface NDAlertUtils : NSObject

/**无事件处理*/
+ (void)showAAlertMessage:(NSString *)msg
                    title:(NSString *)title;
/**单个按钮+事件处理*/
+ (void)showAAlertMessage:(NSString *)msg
                    title:(NSString *)title
               buttonText:(NSString *)buttonText
             buttonAction:(void (^)(void))buttonAction;
/**多个按钮+事件处理*/
+ (void)showAAlertMessage:(NSString *)msg
                    title:(NSString *)title
              buttonTexts:(NSArray *)arrTexts
             buttonAction:(void (^)(int buttonIndex))buttonAction;

+ (void)showActionSheetMsg:(NSString *)msg
                     title:(NSString *)title
               buttonTexts:(NSArray *)arrTexts
              buttonAction:(void (^)(int buttonIndex))buttonAction;

+ (UIViewController *)keyController;

@end
