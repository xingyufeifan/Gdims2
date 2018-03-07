//
//  NDRouter.m
//  Gdims2
//
//  Created by apple on 2018/3/2.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDRouter.h"
#import "NDLoginViewController.h"
#import "NDHomePageViewController.h"
@implementation NDNavigationController
- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    return self.topViewController;
}
@end
@implementation NDRouter
+ (UIWindow *)window{
    return [UIApplication sharedApplication].delegate.window;
}
+ (void)setRootViewWithType:(NDRouterType)type{
    UIViewController *rootVC = nil;
    switch (type) {
        case NDRouterTypeLogin:
            rootVC = [[NDLoginViewController alloc] init];
            break;
        case NDRouterTypeQCQF:
        {
            [[NDUserInfo sharedInstance] setType:NDUserTypeQCQF];
            NDHomePageViewController *home = [[NDHomePageViewController alloc] init];
            home.routerType = type;
            rootVC = [[NDNavigationController alloc] initWithRootViewController:home];
        }
            break;
        case NDRouterTypePQ:
        {
            [[NDUserInfo sharedInstance] setType:NDUserTypePQ];
            NDHomePageViewController *home = [[NDHomePageViewController alloc] init];
            home.routerType = type;
            rootVC = [[NDNavigationController alloc] initWithRootViewController:home];
        }
            break;
        case NDRouterTypeZS:
        {
            [[NDUserInfo sharedInstance] setType:NDUserTypeZS];
            NDHomePageViewController *home = [[NDHomePageViewController alloc] init];
            home.routerType = type;
            rootVC = [[NDNavigationController alloc] initWithRootViewController:home];
        }
            break;
        default:
            break;
    }
    [[self window]setRootViewController:rootVC];
}
+ (void)changeVC:(UIViewController *)viewController{
    [[self window] setRootViewController:viewController];
}
+ (UINavigationController *)nav{
    UINavigationController * nav = nil;
    UIViewController * rootVC = [self window].rootViewController;
    if ([rootVC isKindOfClass:[UINavigationController class]]) {
        nav = (UINavigationController *)rootVC;
    } else {
        nav = rootVC.navigationController;
    }
    
    return nav;
}
@end
