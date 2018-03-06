//
//  NDDimmingPresentaionController.m
//  Gdims2
//
//  Created by apple on 2018/3/6.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDDimmingPresentaionController.h"
@interface NDDimmingPresentaionController()
@property (nonatomic,strong) UIView * maskView;
@end

@implementation NDDimmingPresentaionController
- (UIView *)maskView{
    if (_maskView == nil) {
        _maskView = [[UIView alloc] initWithFrame:CGRectZero];
        [_maskView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]];
    }
    
    return _maskView;
}

-(void)presentationTransitionWillBegin{
    self.maskView.frame = self.containerView.bounds;
    [self.containerView insertSubview:self.maskView atIndex:0];
    
    self.maskView.alpha = 0;
    if (self.presentedViewController.transitionCoordinator) {
        [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            self.maskView.alpha = 1.0;
            
        } completion:nil];
    }
}

-(void)dismissalTransitionWillBegin{
    if (self.presentedViewController.transitionCoordinator) {
        [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            self.maskView.alpha = 0;
            
        } completion:nil];
    }
}

-(BOOL)shouldRemovePresentersView{
    return false;
}
@end
