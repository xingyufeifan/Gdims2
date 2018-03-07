//
//  NDMenuCell.m
//  Gdims2
//
//  Created by 李青松 on 2018/3/7.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDMenuCell.h"

@implementation NDMenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    _ndContentView.layer.cornerRadius = 5;
    _ndContentView.layer.shadowOffset = CGSizeMake(0, 2);
    _ndContentView.layer.shadowColor = [UIColor blackColor].CGColor;
    _ndContentView.layer.shadowRadius = 2;
    _ndContentView.layer.shadowOpacity = 0.5;
    
    _lbTitle.textColor = [UIColor nd_tintColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
