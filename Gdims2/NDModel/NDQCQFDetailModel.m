//
//  NDQCQFDetailModel.m
//  Gdims2
//
//  Created by apple on 2018/3/9.
//  Copyright © 2018年 name. All rights reserved.
//

#import "NDQCQFDetailModel.h"

@implementation NDQCQFDetailModel


- (NSArray<NSString *> *)zx_imgList {
    NSMutableArray<NSString *> * fullPathList = [NSMutableArray array];
    NSString * urlStr = self.macro_url;
    if (!urlStr || [urlStr zx_isEmpty]) {
        urlStr = self.monitor_url;
    }
    if (urlStr && [urlStr isKindOfClass:[NSString class]] && ![urlStr zx_isEmpty]) {
        NSArray * arrStr = [urlStr componentsSeparatedByString:@","];
        for (NSString * str in arrStr) {
            if (str && ![str zx_isEmpty]) {
                [fullPathList addObject:[NSString stringWithFormat:@"%@%@",ND_IMAGE_URL,[str stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"]]];
            }
        }
    }
    return fullPathList;
}

- (NSString *)zx_validString {
    return self.is_validate == 1 ? @"合法" : @"不合法";
}

-(NSString *)zx_stateString{
    return self.state == 1 ? @"有效" : @"无效";
}
//1:蓝色告警/2:黄色告警/3:橙色告警/4:红色告警/-1:异常/0或其他值:正常
- (NSString *)zx_warnString {
    switch (self.warn_level) {
        case 1:
            return @"蓝色告警";
            break;
        case 2:
            return @"黄色告警";
            break;
        case 3:
            return @"橙色告警";
            break;
        case 4:
            return @"红色告警";
            break;
        case -1:
            return @"异常";
            break;
        default:
            break;
    }
    return @"正常";
}

- (UIColor *)zx_warnColor {
    switch (self.warn_level) {
        case 1:
            return [UIColor blueColor];
            break;
        case 2:
            return NDCOLOR_RGB(250, 215, 3, 1);
            break;
        case 3:
            return [UIColor orangeColor];
            break;
        case 4:
            return [UIColor redColor];
            break;
        case -1:
            return [UIColor redColor];
            break;
        default:
            break;
    }
    return [UIColor greenColor];
}

@end
