//
//  NDDateCheckViewController.m
//  Gdims2
//
//  Created by 李青松 on 2018/3/8.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDDateCheckViewController.h"
#import "NDDimmingPresentaionController.h"
#import "NSDate+ND.h"

@interface NDDateCheckViewController ()
<UIViewControllerTransitioningDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnDone;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic,strong) NSDate * date;
@end

@implementation NDDateCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.minDate) {
        self.datePicker.minimumDate = self.minDate;
    }
    if (self.maxDate) {
        self.datePicker.maximumDate = self.maxDate;
    } else {
        self.datePicker.maximumDate = [NSDate date];
    }
    if (_justDate) {
        self.datePicker.datePickerMode = UIDatePickerModeDate;
    } else {
        self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    }
    if (self.titleInfo && ![self.titleInfo zx_isEmpty]) {
        self.lbTitle.text = self.titleInfo;
    } else {
        self.lbTitle.text = @"";
    }
    self.date = [NSDate date];
    self.view.backgroundColor = [UIColor clearColor];
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self setModalPresentationStyle:UIModalPresentationCustom];
        self.transitioningDelegate = self;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)doneAction:(id)sender {
    if (self.callBack) {
        self.callBack(self.date,[self.date dateStringWithFormate:nil]);
    }
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)dateValueChanged:(UIDatePicker *)sender {
    self.date = sender.date;
}

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source{
    return [[NDDimmingPresentaionController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
}




@end
