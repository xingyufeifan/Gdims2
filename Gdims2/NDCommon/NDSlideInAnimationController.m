//
//  NDSlideInAnimationController.m
//  Gdims2
//
//  Created by apple on 2018/3/6.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDSlideInAnimationController.h"

@implementation NDSlideInAnimationController
- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController * toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView * toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView * containerView = [transitionContext containerView];
    toView.frame = [transitionContext finalFrameForViewController:toViewController];
    toView.center = CGPointMake(- containerView.center.x, containerView.center.y);
    [containerView addSubview:toView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration animations:^{
        toView.center = containerView.center;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:finished];
    }];
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}
@end
