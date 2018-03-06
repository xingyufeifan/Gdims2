//
//  NDHomeListHeader.m
//  Gdims2
//
//  Created by apple on 2018/3/6.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDHomeListHeader.h"
#import "NDMacroListModel.h"
@interface NDHomeListHeader ()

@property (nonatomic, strong) NDMacroListModel * model;

@end
@implementation NDHomeListHeader
- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    _backContent.layer.cornerRadius = 5;
    _backContent.layer.shadowOffset = CGSizeMake(0, 2);
    _backContent.layer.shadowColor = [UIColor blackColor].CGColor;
    _backContent.layer.shadowRadius = 2;
    _backContent.layer.shadowOpacity = 0.5;
    _model = nil;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_backContent addGestureRecognizer:tap];
    
    self.lblDisName.textColor = [UIColor nd_textColor];
    self.lblDisType.textColor = [UIColor nd_textMarkColor];
    self.lblLatitude.textColor = [UIColor nd_textMarkColor];
    self.lblLongitude.textColor = [UIColor nd_textMarkColor];
    
    self.lblDisName.text = @"";
    self.lblDisType.text = @"";
    self.lblLatitude.text = @"";
    self.lblLongitude.text = @"";
    
}

- (void)reloadData:(NDMacroListModel *)model sectionIndex:(NSInteger)index{
    model.zxIndex = index;
    self.model = model;
    [self.imgArrow setHighlighted:self.model.zxExand];
    self.lblDisName.text = model.name;
    self.lblDisType.text = model.disasterType;
    self.lblLatitude.text = [NSString stringWithFormat:@"%@",model.latitude];
    self.lblLongitude.text = [NSString stringWithFormat:@"%@",model.longitude];
}

- (void)tapAction:(id)sender {
    if (self.model != nil) {
        self.model.zxExand = !self.model.zxExand;
        [self.imgArrow setHighlighted:self.model.zxExand];
        if (_delegate && [_delegate respondsToSelector:@selector(ndHomeListHeader:tappedAt:)]) {
            [_delegate ndHomeListHeader:self tappedAt:self.model.zxIndex];
        }
    }
}

@end
