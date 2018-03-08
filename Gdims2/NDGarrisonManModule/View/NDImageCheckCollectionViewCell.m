//
//  NDImageCheckCollectionViewCell.m
//  Gdims2
//
//  Created by 李青松 on 2018/3/8.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDImageCheckCollectionViewCell.h"

@implementation NDImageCheckCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
}

- (IBAction)deleteAction:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(ndImageCheckCollectionViewCellDeleteAction:)]) {
        [_delegate ndImageCheckCollectionViewCellDeleteAction:self];
    }
}
@end
