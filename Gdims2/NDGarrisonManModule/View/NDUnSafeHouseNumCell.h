//
//  NDUnSafeHouseNumCell.h
//  Gdims2
//
//  Created by 李青松 on 2018/3/7.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDTableViewCell.h"

@protocol NDUnSafeHouseNumCellDelegate <NSObject>
- (void)ndUnSafeHouseNumCell:(UITableViewCell *)cell houseNum:(NSString *)houseNum;
- (void)ndUnSafeHouseNumCell:(UITableViewCell *)cell peopleNum:(NSString *)peopleNum;
@end
@interface NDUnSafeHouseNumCell : NDTableViewCell

<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lbTips1;
@property (weak, nonatomic) IBOutlet UILabel *lbTips2;
@property (weak, nonatomic) IBOutlet UILabel *lbTips;
@property (weak, nonatomic) IBOutlet UITextField *txtHouseNum;
@property (weak, nonatomic) IBOutlet UITextField *txtPeopleNum;

@property (nonatomic,weak) id<NDUnSafeHouseNumCellDelegate> delegate;

@end
