//
//  UIColor+ND.m
//  Gdims2
//
//  Created by apple on 2018/3/2.
//  Copyright © 2018年 name. All rights reserved.
//

#import "UIColor+ND.h"

@implementation UIColor (ND)
+ (UIColor *)nd_tintColor {
    return NDCOLOR_RGB(17, 59, 100, 1);
}

+ (UIColor *)nd_backgroundColor {
    return NDCOLOR_RGB(250, 250, 250, 1);
}

+ (UIColor *)nd_textColor {
    return NDCOLOR_RGB(79, 79, 79, 1);
}

+ (UIColor *)nd_textMarkColor {
    return NDCOLOR_RGB(110, 110, 110, 1);
}

+ (UIColor *)nd_buttonColor {
    return NDCOLOR_RGB(17, 59, 100, 1);
    //return ZXCOLOR_RGB(9, 84, 159, 1);
}

+ (UIColor *)nd_coordinateColor {
    return NDCOLOR_RGB(44, 174, 170, 1);
}

+ (UIColor *)nd_whiteColor {
    return NDCOLOR_RGB(252, 252, 252, 1);
}
@end
