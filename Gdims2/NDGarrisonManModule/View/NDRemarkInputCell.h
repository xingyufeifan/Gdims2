//
//  NDRemarkInputCell.h
//  Gdims2
//
//  Created by 李青松 on 2018/3/7.
//  Copyright © 2018年 name. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "NDTableViewCell.h"
#import "NDMonitorCell.h"


@interface NDRemarkInputCell : NDTableViewCell
<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *txtContent;
@property (nonatomic,weak) id<NDMonitorCellDelegate> delegate;
@end
