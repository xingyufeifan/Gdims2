//
//  NDMacroCell.m
//  Gdims2
//
//  Created by apple on 2018/3/7.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDMacroCell.h"
#import "NDMacroListModel.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
@implementation NDMacroCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [_btnCheckBox setTitleColor:[UIColor nd_textMarkColor] forState:UIControlStateNormal];
    [_btnCheckBox setTitleColor:[UIColor nd_textColor] forState:UIControlStateSelected];
    [_btnCheckBox setTitleColor:[UIColor nd_textColor] forState:UIControlStateHighlighted];
    [_btnCheckBox setImage:[UIImage imageNamed:@"zx-uncheck-square"] forState:UIControlStateNormal];
    [_btnCheckBox setImage:[UIImage imageNamed:@"zx-check-square"] forState:UIControlStateSelected];
    [_btnCheckBox setImage:[UIImage imageNamed:@"zx-check-square"] forState:UIControlStateHighlighted];
    [_lblTitle setTextColor:[UIColor nd_textColor]];
}

- (void)reloadData:(NDMacroModel *)model{
    if (model) {
        _lblTitle.text = model.name;
        [_btnCheckBox setSelected:model.checked];
        [_imgView setImageWithURL:model.imageUrl placeholderImage:[UIImage imageNamed:@"zx-img-default"]];
    } else {
        _lblTitle.text = @"";
        _imgView.image = nil;
        [_btnCheckBox setSelected:false];
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)btnCheckBoxClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(ndMacroCell:checked:)]) {
        [_delegate ndMacroCell:self checked:sender.selected];
    }
}
- (IBAction)tbnTakePhotoClick {
    if (_delegate && [_delegate respondsToSelector:@selector(ndMacroCellTakePhoto:)]) {
        [_delegate ndMacroCellTakePhoto:self];
    }
}

@end
