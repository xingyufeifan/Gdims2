//
//  NSString+NDTimeString.m
//  Gdims2
//
//  Created by apple on 2018/3/6.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NSString+NDTimeString.h"

@implementation NSString (NDTimeString)

- (BOOL)zx_isEmpty {
    NSString * str = self;
    if (str == nil || (id)str == [NSNull null]) {
        return true;
    } else {
        if (![str respondsToSelector:@selector(length)]) {
            return true;
        }
        str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([str length]) {
            return false;
        }
    }
    return true;
}

+ (NSString *)zx_currentDateString {
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:[NSString stringWithFormat:@"YYYY-MM-dd HH:mm:ss"]];
    return [formatter stringFromDate:[NSDate date]];
}

+ (NSString *)zx_serialNumber {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    formatter.dateFormat =@"yyyyMMddHHmmssSSS";
    NSString * str = [formatter stringFromDate:[NSDate date]];
    return str;
}
@end
