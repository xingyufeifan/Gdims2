//
//  NDDateCheckViewController.h
//  Gdims2
//
//  Created by 李青松 on 2018/3/8.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDViewController.h"

typedef void(^NDDateCallBack)(NSDate * date,NSString * strDate);

@interface NDDateCheckViewController : NDViewController


@property (nonatomic,assign) BOOL justDate;

@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (nonatomic,copy) NDDateCallBack callBack;
@property (nonatomic,strong) NSDate * minDate;
@property (nonatomic,strong) NSDate * maxDate;
@property (nonatomic,strong) NSString * titleInfo;
@end
