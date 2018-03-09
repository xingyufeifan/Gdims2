//
//  NDImageCollectionViewCell.h
//  Gdims2
//
//  Created by apple on 2018/3/9.
//  Copyright © 2018年 name. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NDImageCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
+ (CGFloat)width;
@end
