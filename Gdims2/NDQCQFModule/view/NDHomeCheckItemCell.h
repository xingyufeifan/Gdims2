//
//  NDHomeCheckItemCell.h
//  Gdims2
//
//  Created by apple on 2018/3/6.
//  Copyright © 2018年 name. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NDHomeCheckItemCell;
@protocol NDHomeCheckItemCellDelegate <NSObject>

- (void)ndHomeCheckItemCellReportAction:(NDHomeCheckItemCell *)cell;
- (void)ndHomeCheckItemCellReviewAction:(NDHomeCheckItemCell *)cell;

@end
@interface NDHomeCheckItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnReport;
@property (weak, nonatomic) IBOutlet UIButton *btnReview;

@property(nonatomic,weak) id<NDHomeCheckItemCellDelegate> delegate;
@end
