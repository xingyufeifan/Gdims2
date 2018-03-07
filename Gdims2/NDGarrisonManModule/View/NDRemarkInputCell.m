//
//  NDRemarkInputCell.m
//  Gdims2
//
//  Created by 李青松 on 2018/3/7.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDRemarkInputCell.h"

@implementation NDRemarkInputCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.clipsToBounds = true;
    self.txtContent.text = @"";
    self.txtContent.delegate = self;
    self.txtContent.textColor = [UIColor nd_textColor];
    self.txtContent.layer.cornerRadius = 5;
    self.txtContent.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.txtContent.layer.borderWidth = 1;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (_delegate && [_delegate respondsToSelector:@selector(ndMonitorCell:inputDoneWtih:)]) {
        [_delegate ndMonitorCell:self inputDoneWtih:textView.text];
    }
}
@end
