//
//  NDSettingHeaderCell.m
//  Gdims2
//
//  Created by apple on 2018/3/5.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDSettingHeaderCell.h"

@implementation NDSettingHeaderCell
-(void)awakeFromNib{
    [super awakeFromNib];
    [self.lblText setTextColor:[UIColor nd_textColor]];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
