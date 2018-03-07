//
//  NDSingleTextHeader.m
//  Gdims2
//
//  Created by 李青松 on 2018/3/7.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDSingleTextHeader.h"

@implementation NDSingleTextHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    self.clipsToBounds = true;
    self.lbText.textColor = [UIColor nd_textColor];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
