//
//  NDImageCheckCollectionViewCell.h
//  Gdims2
//
//  Created by 李青松 on 2018/3/8.
//  Copyright © 2018年 name. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NDImageCheckCollectionViewCell;
@protocol NDImageDeleteDelegate <NSObject>
- (void)ndImageCheckCollectionViewCellDeleteAction:(NDImageCheckCollectionViewCell *)cell;
@end
@interface NDImageCheckCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;

@property (weak, nonatomic) id<NDImageDeleteDelegate> delegate;

@end
