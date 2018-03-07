//
//  NDMonitorCell.m
//  Gdims2
//
//  Created by apple on 2018/3/7.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDMonitorCell.h"
@interface NDMonitorCell()<UITextFieldDelegate>
@property (nonatomic, assign) NDMonitorCellType type;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftLableWidth;

@end

@implementation NDMonitorCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.lblName setTextColor:[UIColor nd_textColor]];
    [self.lblValue setTextColor:[UIColor nd_textColor]];
    [self.txtDetail setTextColor:[UIColor nd_textColor]];
    self.txtDetail.delegate = self;
    self.txtDetail.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.txtDetail.returnKeyType = UIReturnKeyDone;
    self.type = NDMonitorCellTypeLRLabel;
    [_btnResetRainfall setTitleColor:[UIColor nd_textColor] forState:UIControlStateNormal];
    [_btnResetRainfall setImage:[UIImage imageNamed:@"zx-uncheck-circle"] forState:UIControlStateNormal];
    [_btnResetRainfall setImage:[UIImage imageNamed:@"zx-check-circle"] forState:UIControlStateSelected];
    [_btnResetRainfall setImage:[UIImage imageNamed:@"zx-check-circle"] forState:UIControlStateHighlighted];
    self.textType = NDInputTextTypeText;
}
-(void)setTextType:(NDInputTextType)textType{
    _textType = textType;
    if (_textType == NDInputTextTypeText) {
        self.txtDetail.keyboardType = UIKeyboardTypeDefault;
    } else {
        self.txtDetail.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }
}
-(void)reloadLeftText:(NSString *)lText rightText:(NSString *)rText type:(NDMonitorCellType)type{
    [self.lblValue setHidden:true];
    [self.txtDetail setHidden:true];
    [self.txtDetail setEnabled:false];
    [self.btnResetRainfall setHidden:true];
    self.lblName.text = lText;
    self.leftLableWidth.constant = 100;
    switch (type) {
        case NDMonitorCellTypeLRLabel:
            [self.lblValue setHidden:false];
            self.lblValue.text = rText;
            break;
        case NDMonitorCellTypeTextField:
            [self.txtDetail setHidden:false];
            [self.txtDetail setEnabled:true];
            self.txtDetail.text = rText;
            break;
        case NDMonitorCellTypeLLabel:
            self.leftLableWidth.constant = 200;
            self.lblValue.text = @"";
            break;
        case NDMonitorCellTypeRainFall:
            [self.btnResetRainfall setHidden:false];
            break;
        default:
            break;
    }
}
- (IBAction)btnResetRainfall:(UIButton *)sender {
    self.btnResetRainfall.selected = !self.btnResetRainfall.selected;
    if (_delegate && [_delegate respondsToSelector:@selector(ndMonitorCell:rainFallChecked:)]) {
        [_delegate ndMonitorCell:self rainFallChecked:self.btnResetRainfall.selected];
    }
}
- (BOOL)zx_isResetRainFall {
    return self.btnResetRainfall.selected;
}
- (NSString *)zx_inputValue {
    NSString * text = [self.txtDetail text];
    if (text && [text isKindOfClass:[NSString class]] && [text length] > 0) {
        return text;
    }
    return nil;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (self.textType == NDInputTextTypeText) {
        return true;
    } else if (self.textType == NDInputTextTypeDecimal) {
        BOOL isHaveDian = true;
        if ([textField.text rangeOfString:@"."].location==NSNotFound) {
            isHaveDian=NO;
        }
        if ([string length] > 0) {
            unichar single = [string characterAtIndex:0];//当前输入的字符
            if ((single >= '0' && single<= '9') || single=='.')//数据格式正确
            {
                if([textField.text length]==0){
                    if(single == '.'){
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                        
                    }
                } else {
                    if (single == '0') {
                        if (isHaveDian || [[textField.text substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"0"]) {
                            NSRange ran=[textField.text rangeOfString:@"."];
                            unsigned long tt=range.location-ran.location;
                            if (tt <= 3){
                                return true;
                            }else{
                                return false;
                            }
                        }
                    }else{
                        if ([textField.text length] == 1 && [textField.text isEqualToString:@"0"] && single != '.') {//第一位为0 第二位不为0 也不是小数点
                            [textField setText:[NSString stringWithCharacters:&single length:1]];
                            return NO;
                        }
                    }
                }
                //输入的小数点
                if (single=='.'){
                    if(!isHaveDian)//text中还没有小数点
                    {
                        isHaveDian=YES;
                        return YES;
                    }else
                    {
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                } else {
                    if (isHaveDian)//存在小数点
                    {
                        //判断小数点的位数
                        NSRange ran=[textField.text rangeOfString:@"."];
                        unsigned long tt=range.location-ran.location;
                        if (tt <= 6){
                            return YES;
                        }else{
                            return NO;
                        }
                    }
                    else
                    {
                        return YES;
                    }
                }
            }else{//输入的数据格式不正确
                [textField.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }
        }
    } else if (self.textType == NDInputTextTypeInteger) {
        if ([string length] > 0) {
            unichar single = [string characterAtIndex:0];//当前输入的字符
            if ((single >= '0' && single<= '9')) {
                if([textField.text length] != 0){
                    if (single == '0') {
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }
            } else {//输入的数据格式不正确
                [textField.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }
        }
        
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.txtDetail resignFirstResponder];
    return  true;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (_delegate && [_delegate respondsToSelector:@selector(ndMonitorCell:inputDoneWtih:)]) {
        [_delegate ndMonitorCell:self inputDoneWtih:self.txtDetail.text];
    }
}

@end
