//
//  NDSlideOutAnimationController.m
//  Gdims2
//
//  Created by apple on 2018/3/6.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDSlideOutAnimationController.h"

@implementation NDSlideOutAnimationController
- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    UIView * fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView * containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration animations:^{
        fromView.center = CGPointMake(-containerView.bounds.size.width, fromView.center.y);
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:finished];
    }];
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}
@end
