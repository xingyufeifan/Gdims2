//
//  NSDate+ZX.m
//  Gdims2
//
//  Created by 李青松 on 2018/3/8.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NSDate+ND.h"

@implementation NSDate (ND)
- (NSString *)dateStringWithFormate:(NSString *)formate{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSString * f = formate;
    if (!f) {
        f = @"YYYY-MM-dd HH:mm";
    }
    [formatter setDateFormat:f];
    return [formatter stringFromDate:self];
}

@end
