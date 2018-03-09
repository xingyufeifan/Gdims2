//
//  ZXVideoCheckCell.m
//  QCQF
//
//  Created by screson on 2017/12/1.
//  Copyright © 2017年 screson. All rights reserved.
//

#import "NDVideoCheckCell.h"
#import "NDVideoModel.h"

@implementation NDVideoCheckCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.btnCheckBox setImage:[UIImage imageNamed:@"zx-uncheck-square"] forState:UIControlStateNormal];
    [self.btnCheckBox setImage:[UIImage imageNamed:@"zx-check-square"] forState:UIControlStateSelected];
    [self.btnCheckBox setImage:[UIImage imageNamed:@"zx-check-square"] forState:UIControlStateHighlighted];
}



- (void)reloadData:(NDVideoModel *)model {
    [self.btnCheckBox setSelected:model.zx_checked];
    self.lbName.text = model.name;
}

- (IBAction)checkBoxAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (_delegate && [_delegate respondsToSelector:@selector(zxVideoCheckCell:checked:)]) {
        [_delegate zxVideoCheckCell:self checked:sender.selected];
    }
}


@end
