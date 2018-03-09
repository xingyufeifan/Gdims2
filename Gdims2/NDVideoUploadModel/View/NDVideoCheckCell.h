//
//  ZXVideoCheckCell.h
//  QCQF
//
//  Created by screson on 2017/12/1.
//  Copyright © 2017年 screson. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NDVideoModel;
@class NDVideoCheckCell;

@protocol NDVideoCheckCellDelegate <NSObject>
- (void)zxVideoCheckCell:(NDVideoCheckCell *)cell checked:(BOOL)checked;
@end

@interface NDVideoCheckCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbName;

@property (weak, nonatomic) IBOutlet UIButton *btnCheckBox;


@property (nonatomic,weak) id<NDVideoCheckCellDelegate> delegate;

- (void)reloadData:(NDVideoModel *)model;

@end
