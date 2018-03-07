//
//  NDMonitorUploadViewController.h
//  Gdims2
//
//  Created by apple on 2018/3/7.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDViewController.h"
@class NDMacroListModel;
@class NDMonitorModel;
@interface NDMonitorUploadViewController : NDViewController
@property (nonatomic, strong) CLLocation * location;
@property (nonatomic, strong) NDMacroListModel * macroModel;
@property (nonatomic, strong) NDMonitorModel * monitorModel;
@end
