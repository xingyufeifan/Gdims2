//
//  NDQCQFHistoryCell.h
//  Gdims2
//
//  Created by apple on 2018/3/9.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDTableViewCell.h"
@class NDQCQFDetailModel;
@interface NDQCQFHistoryCell : NDTableViewCell
@property (weak, nonatomic) IBOutlet UIView *ndContentView;

@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblType;
@property (weak, nonatomic) IBOutlet UILabel *lblValue;

- (void)reloadData:(NDQCQFDetailModel *)model type:(NDQCQFDetailType)type;
@end
