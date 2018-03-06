//
//  NDRouter.h
//  Gdims2
//
//  Created by apple on 2018/3/2.
//  Copyright © 2018年 name. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum : NSUInteger{
    NDRouterTypeLogin = 1,
    NDRouterTypeQCQF = 2,
    NDRouterTypeZS = 3,
    NDRouterTypePQ = 4
} NDRouterType;
@interface NDNavigationController:UINavigationController
@end
@interface NDRouter : NSObject
+ (UIWindow *)window;
+ (void) setRootViewWithType:(NDRouterType)type;
+ (void) changeVC:(UIViewController *)viewController;
+ (UINavigationController *)nav;
@end
