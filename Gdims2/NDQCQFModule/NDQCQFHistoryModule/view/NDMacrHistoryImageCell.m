//
//  NDMacrHistoryImageCell.m
//  Gdims2
//
//  Created by apple on 2018/3/9.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDMacrHistoryImageCell.h"
#import "NDImageCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@implementation NDMacrHistoryImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"NDImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"NDImageCollectionViewCell"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setImgList:(NSArray<NSString *> *)imgList{
    _imgList = imgList;
    [self.collectionView reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imgList.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(NDImageCollectionViewCell.width, NDImageCollectionViewCell.width);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NDImageCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NDImageCollectionViewCell" forIndexPath:indexPath];
    [cell.imgIcon sd_setImageWithURL:[NSURL URLWithString:self.imgList[indexPath.row]] placeholderImage:[UIImage imageNamed:@"zx-img-default"]];
    //AFNetworking 加载失败
    //[cell.imgIcon setImageWithURL:[NSURL URLWithString:self.imgList[indexPath.row]] placeholderImage:[UIImage imageNamed:@"zx-img-default"]];
    return cell;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
@end
