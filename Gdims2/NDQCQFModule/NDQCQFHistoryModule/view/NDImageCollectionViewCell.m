//
//  NDImageCollectionViewCell.m
//  Gdims2
//
//  Created by apple on 2018/3/9.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDImageCollectionViewCell.h"

@implementation NDImageCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
}

+ (CGFloat)width {
    return floor((ND_BOUNDS_WIDTH - 30) / 3.0);
}
@end
