//
//  BaseColor.m
//  PYKit
//
//  Created by 李鹏跃 on 2018/9/11.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

#import "BaseColorHandler.h"

@implementation BaseColorHandler

+ (UIColor *) cBlack {
    return UIColor.blackColor;
}

+ (UIColor *) cGrayD {
        return UIColor.grayColor;
}

+ (UIColor *) cGrayL {
    return UIColor.lightGrayColor;
}


+ (BaseColorHandler * _Nonnull (^)(id _Nonnull))handle {
    return ^(id value) {
        BaseColorHandler *handler = [BaseColorHandler new];
        
        UIColor *color = UIColor.whiteColor;
        
        if ([value isKindOfClass:NSNumber.class]) {
            value = [NSString stringWithFormat:@"%@",value];
        }
        if ([value isKindOfClass:NSString.class]) {
            color = BaseColorHandler.cHexStr(value);
        }
        if ([value isKindOfClass:UIColor.class]) {
            color = value;
        }
        
        handler.color = color;
        return handler;
    };
}

+ (UIColor *) colorWithHexString: (NSString *)color {
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // 判断前缀
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

+ (UIColor *(^)(NSString *hexStr)) cHexStr {
    return ^(NSString *hexStr) {
        return [self colorWithHexString:hexStr];
    };
}

+ (UIColor *(^)(NSInteger hex)) cHex {
    return ^(NSInteger hex) {
        return BaseColorHandler.cHexWithAlpha(hex,1);
    };
}

+ (UIColor *(^)(NSInteger hex, CGFloat alpha)) cHexWithAlpha {
    return ^(NSInteger hex, CGFloat alpha) {
        NSInteger r = (hex&0xFF0000) >> 16;
        NSInteger g = (hex&0x00FF00) >> 8;
        NSInteger b = (hex&0x0000FF);
        return [UIColor colorWithRed:r/255.0 green:g/255.0f blue:b/255.0f alpha:alpha];
    };
}

+ (UIColor *(^)(NSInteger element)) cElement {
    return ^(NSInteger element) {
        CGFloat elementScale = element / 255.0f;
        return [UIColor colorWithRed:elementScale green:elementScale blue:elementScale alpha:1];
    };
}

- (STRUCT_ColorRGBA (^)(void)) getRGBA {
    return ^{
        STRUCT_ColorRGBA rgba;
        CGFloat r,g,b,a = 0;
        [self.color getRed:&r green:&g blue:&b alpha:&a];
        rgba.R = r;
        rgba.G = g;
        rgba.B = b;
        rgba.A = a;
        return rgba;
    };
}

//MARK: - get && set
- (UIColor *)color {
    if (!_color) {
        _color = [UIColor whiteColor];
    }
    return _color;
}
- (CGFloat)r {
    return self.getRGBA().R;
}

- (CGFloat)g {
    return self.getRGBA().G;
}

- (CGFloat)b {
   return self.getRGBA().B;
}

- (CGFloat)a {
    return self.getRGBA().A;
}

- (UIColor *(^)(CGFloat r)) copyByR {
    return ^(CGFloat r) {
        return [UIColor colorWithRed:r green:self.g blue:self.b alpha:self.a];
    };
}

- (UIColor *(^)(CGFloat g)) copyByG {
    return ^(CGFloat g) {
        return [UIColor colorWithRed:self.r green:g blue:self.b alpha:self.a];
    };
}

- (UIColor *(^)(CGFloat b)) copyByB {
    return ^(CGFloat b) {
        return [UIColor colorWithRed:self.r green:self.g blue:b alpha:self.a];
    };
}

- (UIColor *(^)(CGFloat a)) copyByA {
    return ^(CGFloat a) {
        return [UIColor colorWithRed:self.r green:self.g blue:self.b alpha:a];
    };
}
@end
