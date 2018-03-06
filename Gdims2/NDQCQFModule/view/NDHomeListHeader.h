//
//  NDHomeListHeader.h
//  Gdims2
//
//  Created by apple on 2018/3/6.
//  Copyright © 2018年 name. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NDHomeListHeader;
@class NDMacroListModel;
@protocol NDHomeListHeaderDelegate<NSObject>
@optional
- (void)ndHomeListHeader:(NDHomeListHeader *)header tappedAt:(NSInteger)index;
@end
@interface NDHomeListHeader : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UILabel *lblDisName;
@property (weak, nonatomic) IBOutlet UILabel *lblDisType;
@property (weak, nonatomic) IBOutlet UILabel *lblLongitude;
@property (weak, nonatomic) IBOutlet UILabel *lblLatitude;
@property (weak, nonatomic) IBOutlet UIImageView *imgArrow;
@property (weak, nonatomic) IBOutlet UIView *backContent;

@property(nonatomic,weak) id<NDHomeListHeaderDelegate> delegate;
- (void)reloadData:(NDMacroListModel *)model sectionIndex:(NSInteger)index;
@end
