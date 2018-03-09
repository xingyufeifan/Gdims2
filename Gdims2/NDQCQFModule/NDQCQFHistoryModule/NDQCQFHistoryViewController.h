//
//  NDQCQFHistoryViewController.h
//  Gdims2
//
//  Created by apple on 2018/3/9.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDViewController.h"

@interface NDQCQFHistoryViewController : NDViewController
@property (nonatomic,assign) NDQCQFDetailType type;
@property (nonatomic,strong) NSString * disNo;      //灾害点编号
@property (nonatomic,strong) NSString * monitorNo;  //监测点编号
@end
