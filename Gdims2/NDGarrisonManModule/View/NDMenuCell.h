//
//  NDMenuCell.h
//  Gdims2
//
//  Created by 李青松 on 2018/3/7.
//  Copyright © 2018年 name. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NDMenuCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;

@property (weak, nonatomic) IBOutlet UIView *ndContentView;
@property (weak, nonatomic) IBOutlet UIImageView *icImage;

@end
