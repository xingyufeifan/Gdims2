//
//  NDUnSafeHouseNumCell.m
//  Gdims2
//
//  Created by 李青松 on 2018/3/7.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDUnSafeHouseNumCell.h"

@implementation NDUnSafeHouseNumCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.lbTips.textColor = [UIColor nd_textColor];
    self.lbTips1.textColor = [UIColor nd_textColor];
    self.lbTips2.textColor = [UIColor nd_textColor];
    self.txtHouseNum.textColor = [UIColor nd_textColor];
    self.txtPeopleNum.textColor = [UIColor nd_textColor];
    self.txtHouseNum.delegate = self;
    self.txtPeopleNum.delegate = self;
    self.txtHouseNum.returnKeyType = UIReturnKeyDone;
    self.txtHouseNum.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.txtPeopleNum.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.txtPeopleNum.returnKeyType = UIReturnKeyDone;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return true;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.txtHouseNum) {
        if (_delegate && [_delegate respondsToSelector:@selector(ndUnSafeHouseNumCell:houseNum:)]) {
            [_delegate ndUnSafeHouseNumCell:self houseNum:textField.text];
        }
        
    } else if (textField == self.txtPeopleNum) {
        if (_delegate && [_delegate respondsToSelector:@selector(ndUnSafeHouseNumCell:peopleNum:)]) {
            [_delegate ndUnSafeHouseNumCell:self peopleNum:textField.text];
        }
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
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
    return YES;
}


@end
