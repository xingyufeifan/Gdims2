//
//  NDMonitorCell.h
//  Gdims2
//
//  Created by apple on 2018/3/7.
//  Copyright © 2018年 name. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NDMonitorCell;
typedef enum : NSUInteger {
    NDMonitorCellTypeLRLabel,   //左右 Label
    NDMonitorCellTypeTextField, //Label + TextField
    NDMonitorCellTypeLLabel,    //左边单个Label
    NDMonitorCellTypeRainFall   //
} NDMonitorCellType;

typedef enum : NSUInteger {
    NDInputTextTypeText,
    NDInputTextTypeInteger,
    NDInputTextTypeDecimal
} NDInputTextType;

@protocol NDMonitorCellDelegate <NSObject>
- (void)ndMonitorCell:(UITableViewCell *)cell inputDoneWtih:(NSString *)text;
@optional
- (void)ndMonitorCell:(UITableViewCell *)cell rainFallChecked:(BOOL)checked;
@end
@interface NDMonitorCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UITextField *txtDetail;
@property (weak, nonatomic) IBOutlet UILabel *lblValue;
@property (weak, nonatomic) IBOutlet UIButton *btnResetRainfall;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (nonatomic,assign) NDInputTextType textType;
@property (nonatomic,weak) id<NDMonitorCellDelegate> delegate;

- (void)reloadLeftText:(NSString *)lText rightText:(NSString *)rText type:(NDMonitorCellType)type;
- (BOOL)zx_isResetRainFall;
- (NSString *)zx_inputValue;

@end
