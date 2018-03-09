//
//  NDMacrHistoryImageCell.h
//  Gdims2
//
//  Created by apple on 2018/3/9.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDTableViewCell.h"

@interface NDMacrHistoryImageCell : NDTableViewCell<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSArray<NSString *> * imgList;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
