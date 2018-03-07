//
//  NDMacroCell.h
//  Gdims2
//
//  Created by apple on 2018/3/7.
//  Copyright © 2018年 name. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NDMacroCell;
@class NDMacroModel;
@protocol NDMacroCellDlegate<NSObject>
@optional
- (void)ndMacroCell:(NDMacroCell *)cell checked:(BOOL)checked;
- (void)ndMacroCellTakePhoto:(NDMacroCell *)cell;
@end

@interface NDMacroCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnCheckBox;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (nonatomic, weak) id<NDMacroCellDlegate> delegate;

- (void) reloadData:(NDMacroModel *) model;
@end
