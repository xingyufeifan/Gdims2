//
//  NDQCQFHistoryCell.m
//  Gdims2
//
//  Created by apple on 2018/3/9.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDQCQFHistoryCell.h"
#import "NDQCQFDetailModel.h"
@implementation NDQCQFHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.ndContentView.layer.cornerRadius = 5;
    self.ndContentView.layer.masksToBounds = YES;
    self.ndContentView.layer.shadowOffset = CGSizeMake(0, 2);
    self.ndContentView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.ndContentView.layer.shadowRadius = 2;
    self.ndContentView.layer.shadowOpacity = 0.5;
}


- (void)reloadData:(NDQCQFDetailModel *)model type:(NDQCQFDetailType)type{
    self.lblName.text = model.dis_name;
    self.lblTime.text = model.u_time;
    
    if (type == NDQCQFDetailTypeMacro) {
        self.lblType.text = @"异常类型:";
        self.lblValue.text = model.macro_data;
    }else{
        self.lblType.text = @"监测数据:";
        self.lblValue.text = model.monitor_data;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
