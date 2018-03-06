//
//  NDHomeCheckItemCell.m
//  Gdims2
//
//  Created by apple on 2018/3/6.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDHomeCheckItemCell.h"

@implementation NDHomeCheckItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.btnReport setTitleColor:[UIColor nd_textColor] forState:UIControlStateNormal];
    self.btnReport.layer.cornerRadius = 5;
    self.btnReport.layer.masksToBounds = YES;
    self.btnReport.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.btnReport.layer.borderWidth = 1.0;
    
    [self.btnReview setTitleColor:[UIColor nd_textColor] forState:UIControlStateNormal];
    self.btnReview.layer.cornerRadius = 5;
    self.btnReview.layer.masksToBounds = YES;
    self.btnReview.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.btnReview.layer.borderWidth = 1.0;
}
- (IBAction)btnReportClick {
    if (_delegate && [_delegate respondsToSelector:@selector(ndHomeCheckItemCellReportAction:)]) {
        [_delegate ndHomeCheckItemCellReportAction:self];
    }
}
- (IBAction)btnReviewClick {
    if (_delegate && [_delegate respondsToSelector:@selector(ndHomeCheckItemCellReviewAction:)]) {
        [_delegate ndHomeCheckItemCellReviewAction:self];
    }
}



@end
