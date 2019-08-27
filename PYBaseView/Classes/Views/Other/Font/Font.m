//
//  BaseFont.m
//  PYKit
//
//  Created by 李鹏跃 on 2018/9/11.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

#import "BaseFont.h"
#import "BaseThemeManager.h"

#define IOS9_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
@implementation BaseFont

//PingFangSC
+ (UIFont *(^)(CGFloat size)) fontSCL {
    return ^(CGFloat size) {
        return [self pingFangSCLightFont:size];
    };
}

+ (UIFont *(^)(CGFloat size)) fontSCM {
    return ^(CGFloat size) {
        return [self pingFangSCMediumFont:size];
    };
}

+ (UIFont *(^)(CGFloat size)) fontSCR {
    return ^(CGFloat size) {
        return [self pingFangSCRFont:size];
    };
}

+ (UIFont *(^)(CGFloat size)) fontSCB {
    return ^(CGFloat size) {
        return [self pingFangSCBoldFont:size];
    };
}



//PingFangSC
+ (UIFont *)pingFangSCLightFont:(CGFloat)size {
    
    CGFloat h = size * [BaseThemeManager fontThemeGetHeight];
    return
    (IOS9_OR_LATER)
    ? [UIFont fontWithName:@"PingFangSC-Light" size:h]
    : [UIFont systemFontOfSize:h];
}

+ (UIFont *)pingFangSCMediumFont:(CGFloat)size {

    CGFloat h = size * [BaseThemeManager fontThemeGetHeight];
    return
    (IOS9_OR_LATER)
    ? [UIFont fontWithName:@"PingFangSC-Medium" size:size]
    : [UIFont systemFontOfSize:h];
}

+ (UIFont *)pingFangSCRFont:(CGFloat)size {
    
    CGFloat h = size * [BaseThemeManager fontThemeGetHeight];
    return [UIFont systemFontOfSize:h];
}

+ (UIFont *)pingFangSCBoldFont:(CGFloat)size {
   
    CGFloat h = size * [BaseThemeManager fontThemeGetHeight];
    UIFont *font = [UIFont fontWithName:@"PingFangSC-Bold" size:h];
    return font ? font : [UIFont boldSystemFontOfSize:h];
}

@end
