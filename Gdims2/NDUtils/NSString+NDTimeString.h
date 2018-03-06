//
//  NSString+NDTimeString.h
//  Gdims2
//
//  Created by apple on 2018/3/6.
//  Copyright © 2018年 name. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NDTimeString)
- (BOOL)zx_isEmpty;

+ (NSString *)zx_currentDateString;
+ (NSString *)zx_serialNumber;
@end
