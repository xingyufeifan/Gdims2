//
//  NDRemarkInputCell.h
//  Gdims2
//
//  Created by 李青松 on 2018/3/7.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDTableViewCell.h"
#import "NDMonitorCell.h"
@interface NDRemarkInputCell : NDTableViewCell  <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *txtContent;
@property (weak,nonatomic) id<NDMonitorCellDelegate> delegate;

@end
