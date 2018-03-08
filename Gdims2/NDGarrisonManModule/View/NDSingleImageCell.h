//
//  NDSingleImageCell.h
//  Gdims2
//
//  Created by 李青松 on 2018/3/8.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDTableViewCell.h"

@class NDSingleImageCell;

@protocol NDImageCheckDelegate <NSObject>

- (void)ndImageCheckDelegateTakePhotoAction:(NDSingleImageCell *)cell;
- (void)ndImageCheckCell:(NDSingleImageCell *)cell delegateAt:(NSInteger)index;

@end
@interface NDSingleImageCell : NDTableViewCell

@property (weak, nonatomic) IBOutlet UICollectionView *ccvList;

@property (nonatomic,weak) id<NDImageCheckDelegate> delegate;
@property (nonatomic,strong) NSArray<NSString *> * imgPaths;


+ (CGFloat)height;

@end
