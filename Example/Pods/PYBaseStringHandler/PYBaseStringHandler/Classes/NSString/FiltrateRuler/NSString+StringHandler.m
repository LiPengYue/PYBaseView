//
//  NSString+StringHandler.m
//  OC_AttributedStringHandler
//
//  Created by 李鹏跃 on 2018/9/28.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

#import "NSString+StringHandler.h"
#import "NSAttributedString+Size.h"
#import <math.h>

@implementation NSString (StringHandler)

- (NSString *(^)(id objc)) addObjc {
    return ^(id objc){
        if (!objc) {
            objc = @"";
        }
        return [NSString stringWithFormat:@"%@%@",self,objc];
    };
}

- (NSString *(^)(CGFloat value, NSInteger decimalDigits, BOOL isRound)) addFloat {
    return ^(CGFloat value, NSInteger decimalDigits, BOOL isRound) {
        NSString *floatValue = [NSString createWithFloat:value
                                       andDecimalDigits:decimalDigits
                                             andIsRound:isRound];
        return [NSString stringWithFormat:@"%@%@",self,floatValue];
    };
}

- (NSString *(^)(NSInteger value)) addInt {
    return ^(NSInteger value) {
        return [NSString stringWithFormat:@"%ld",(long)value];
    };
}

- (NSString *(^)(NSString *deleteStr)) deleteStr {
    return ^ (NSString *deleteStr) {
        NSMutableString *str = self.mutableCopy;
        [str stringByReplacingOccurrencesOfString:deleteStr withString:@""];
        return str;
    };
}

- (NSString *(^)(NSString *deleteStr)) deleteLastStr {
    return ^ (NSString *deleteStr) {
        NSMutableString *str = self.mutableCopy;
        NSInteger i = 0, length = str.length;
        for (i = length - 1; i >= 0; i--) {
           NSString *lastStr = [str substringFromIndex:str.length - 1];
            
            if ([lastStr isEqualToString:deleteStr]) {
                NSRange range = NSMakeRange(i, 1);
                [str deleteCharactersInRange:range];
                
            }else{ break; }
        }
        return str;
    };
}

- (NSString *(^)(NSString *deleteStr)) deleteFrontStr {
    return ^ (NSString *deleteStr) {
        NSMutableString *str = self.mutableCopy;
        NSInteger i, length = str.length;
        NSString *firstStr = [str substringFromIndex:0];
        for (i = 0; i < length; i++) {
            if ([firstStr isEqualToString:deleteStr]) {
                NSRange range = NSMakeRange(0, 1);
                [str deleteCharactersInRange:range];
            }
        }
        return str;
    };
}

- (NSString *(^)(void)) deleteLastChar {
    return ^ {
        NSMutableString *str = self.mutableCopy;
        NSRange range = NSMakeRange(self.length-1, 1);
        [str deleteCharactersInRange:range];
        return str;
    };
}

- (NSString *(^)(void)) deleteFrontChar {
    return ^ {
        NSMutableString *str = self.mutableCopy;
        NSRange range = NSMakeRange(0, 1);
        [str deleteCharactersInRange:range];
        return str;
    };
}

- (CGFloat (^)(CGFloat width,UIFont *font)) getHeightWithWidthAndFont {
    
    return ^(CGFloat width,UIFont *font) {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self];
        if (font) {
            NSRange range = NSMakeRange(0, self.length);
            [str addAttribute:NSFontAttributeName value:font range: range];
        }
        return [str getHeightWithWidth:width];
    };
}

- (CGFloat (^)(CGFloat height,UIFont *font)) getWidthWithHeightAndFont {
    return ^(CGFloat height,UIFont *font) {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self];
        if (font) {
            NSRange range = NSMakeRange(0, self.length);
            [str addAttribute:NSFontAttributeName value:font range: range];
        }
        return [str getWidthWithHeight:height];
    };
}


+ (NSString *) createWithFloat: (CGFloat)value
                andDecimalDigits: (NSInteger)decimalDigits
                      andIsRound: (BOOL)isRound {
    
    
    
    NSInteger decimalDigitsTemp = decimalDigits;
    CGFloat floatValue = value * (pow(10,decimalDigitsTemp));
    if(value < 0) floatValue = -floatValue;
    NSInteger integerValue = 0;
    integerValue = isRound ? round(floatValue) : floatValue;
    
    NSMutableString *strTemp = @"".mutableCopy;
    
    for (int i = 0; i < decimalDigitsTemp; i ++) {
        NSInteger value = integerValue % 10;
        
        NSString *valueStr = [NSString stringWithFormat:@"%ld",(long)value];
        [strTemp insertString:valueStr atIndex:0];
        
        integerValue /= 10;
    }
    
    integerValue = value;
    NSString *result = [NSString stringWithFormat:@"%ld.%@",(long)integerValue,strTemp];
    if(value < 0) result.addObjc(@"-");
    return result;
}

+ (NSString *) createWithInt: (NSInteger)value {
    return [NSString stringWithFormat:@"%ld",(long)value];
}


//- (NSString *(^)(NSString *defaultStr)) setDefault {
//    return ^(NSString *defaultStr) {
//        return [self isNullString] ? defaultStr : self;
//    };
//}
//
//- (NSString *(^)(NSString * defaultStr)) ifIsNullEqualTo {
//    return ^(NSString *defaultStr) {
//        return self.setDefault(defaultStr);
//    };
//}

+ (BOOL(^)(NSString *str)) isNull {
    return ^(NSString *str){
        return [self isNullString:str];
    };
}
+ (NSString *) str: (NSString *)str1 isNullRetrun: (NSString *)str2 {
    return str1 ? str1 : str2;
}

+ (NSString *) setDefult: (NSString *)str {
    return [self str:str isNullRetrun:@""];
}

+ (BOOL)isNullString: (NSString *)str{
    if ([str isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (![str isKindOfClass:[NSString class]]) {
        return YES;
    }
    return ([str isEqualToString:@""] || (str.length < 1)) ? YES : NO;
}

- (UIImage *) createImage {
    return [UIImage imageNamed:self];
}
- (NSMutableAttributedString *) createAttributedStr {
    return [[NSMutableAttributedString alloc]initWithString:self];
}
+ (NSString *(^)(NSString *str)) setDefault: (NSString *)string {
    return ^(NSString *str) {
        if (!str) {
            return string;
        }
        return str;
    };
}

/**
 根据 self.text 的length 获取能全部显示情况下的 最大的Width，与最大font，
 @param maxWidth 最大宽度
 @param maxFont 最大的font
 @ 计算后的近似font值与对应的width
 @warning 返回的是能全部显示情况下的 最大的Width，与最大font，
 */
- (void) scaleFontByMaxWidth: (CGFloat)maxWidth
              andMaxFont: (UIFont *)maxFont
                    andBlock: (void(^)(UIFont *font, CGFloat currentWidth))block {
    
    CGFloat originW =
    @""
    .addObjc(self)
    .getWidthWithHeightAndFont(9999,maxFont);
    
    UIFont *newFont = maxFont;
    
    CGFloat currentW = originW;
    
    if (originW > maxWidth) {
        
        CGFloat fontsize = maxWidth / originW * maxFont.pointSize;
        newFont = [maxFont fontWithSize: fontsize];
        
        currentW =
        @""
        .addObjc(self)
        .getWidthWithHeightAndFont(9999,newFont);
    }
    
    if (block) {
        block(newFont,currentW);
    }
}
@end
