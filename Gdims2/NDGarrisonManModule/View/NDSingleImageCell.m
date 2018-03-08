//
//  NDSingleImageCell.m
//  Gdims2
//
//  Created by 李青松 on 2018/3/8.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDSingleImageCell.h"

#import "NDImageCheckCollectionViewCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface NDSingleImageCell () <NDImageDeleteDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end
@implementation NDSingleImageCell

+ (CGFloat)height {
    return 100;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.ccvList.delegate = self;
    self.ccvList.dataSource = self;
    [self.ccvList registerNib:[UINib nibWithNibName:@"NDImageCheckCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"NDImageCheckCollectionViewCell"];
}

- (void)setImgPaths:(NSArray<NSString *> *)imgPaths {
    _imgPaths = imgPaths;
    [self.ccvList reloadData];
    
}

- (void)takePhotoAction {
    if (_delegate && [_delegate respondsToSelector:@selector(ndImageCheckDelegateTakePhotoAction:)]) {
        [_delegate ndImageCheckDelegateTakePhotoAction:self];
    }
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.imgPaths && self.imgPaths.count > 0) {
        NSInteger count = self.imgPaths.count;
        if (count < 4 && indexPath.row == count) {//添加照片
            [self takePhotoAction];
        }
    } else {//添加照片
        [self takePhotoAction];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NDImageCheckCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NDImageCheckCollectionViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    if (self.imgPaths && self.imgPaths.count > 0) {
        NSInteger count = self.imgPaths.count;
        if (count < 4 && indexPath.row == count) {//添加照片
            cell.imgIcon.image = [UIImage imageNamed:@"zx-img-add"];
            [cell.btnDelete setHidden:true];
        } else {
            [cell.btnDelete setHidden:false];
            [cell.imgIcon setImageWithURL:[NSURL fileURLWithPath:self.imgPaths[indexPath.row]] placeholderImage:[UIImage imageNamed:@"zx-img-default"]];
        }
    } else {//添加照片
        cell.imgIcon.image = [UIImage imageNamed:@"zx-img-add"];
        [cell.btnDelete setHidden:true];
    }
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.imgPaths && self.imgPaths.count > 0) {
        if (self.imgPaths.count == 4) {//最多四张图片
            return 4;
        }
        return self.imgPaths.count + 1;
    }
    return 1;//添加图片
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = floor(((ND_BOUNDS_WIDTH - 28) - 3 * 5) / 4);
    return CGSizeMake(width, NDSingleImageCell.height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

#pragma mark -
- (void)ndImageCheckCollectionViewCellDeleteAction:(NDImageCheckCollectionViewCell *)cell {
    NSIndexPath * indexPath = [self.ccvList indexPathForCell:cell];
    if (_delegate && [_delegate respondsToSelector:@selector(ndImageCheckCell:delegateAt:)]) {
        [_delegate ndImageCheckCell:self delegateAt:indexPath.row];
    }
}


@end
