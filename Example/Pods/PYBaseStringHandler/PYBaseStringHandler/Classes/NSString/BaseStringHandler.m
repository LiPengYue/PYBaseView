//
//  BaseStringHandler.m
//  yiapp
//
//  Created by 衣二三 on 2019/3/7.
//  Copyright © 2019年 yi23. All rights reserved.
//

#import "BaseStringHandler.h"
#import "BaseAttriButedStrHandler+ChangeStyle.h"

@interface BaseStringHandler()
/// str
@property (nonatomic,strong) NSString* str;

@end

@implementation BaseStringHandler

+ (BaseStringHandler *(^)(id str, NSString *defaultStr)) handlerWithDefault {
    return ^(id str, NSString *defaultStr) {
        BaseStringHandler *handler = BaseStringHandler.handler(str);
        if (defaultStr.length <= 0) {
            defaultStr = @"";
        }
        if (handler.str.length <= 0) {
            handler.str = defaultStr;
        }
        return handler;
    };
}

+ (BaseStringHandler *(^)(id str)) handler {
    return ^(id str) {
        BaseStringHandler *handler = [BaseStringHandler new];
        if (!str) {
            str = @"";
        }
        if ([str isKindOfClass:BaseStringHandler.class]) {
            str = ((BaseStringHandler *) str).getStr;
        }
        if (![str isKindOfClass:NSString.class]) {
            str = [NSString stringWithFormat:@"%@",str];
        }
        handler.str = str;
        return handler;
    };
}

- (BaseStringHandler *(^)(NSString *defaultStr)) setDefaultIfNull {
    return ^(NSString *defaultStr) {
        if (self.str.length <= 0) {
            self.str = BaseStringHandler.handler(defaultStr).str;
        }
        return self;
    };
}

- (NSString *)getStr {
    return self.str;
}



/**
 添加objc对象
 · 参数为id类型
 */
- (BaseStringHandler *(^)(id objc)) addObjc {
    return ^(id objc){
        
        NSString *str = objc;
        if (str.length <= 0) {
            str = @"";
        }
        if ([objc isKindOfClass:self.class]) {
            str = [ ((BaseStringHandler *)objc) getStr];
        }
        
        self.str = [NSString stringWithFormat:@"%@%@",self.str,str];
        return self;
    };
}

/**
 添加int字符
 */
- (BaseStringHandler *(^)(NSInteger value)) addInt {
    return ^(NSInteger value) {
        self.str = [NSString stringWithFormat:@"%@%ld",self.str,(long)value];
        return self;
    };
}


- (BaseStringHandler *(^)(NSString *deleteStr)) deleteStr {
    return ^ (NSString *deleteStr) {
        NSMutableString *str = self.str.mutableCopy;
        [str stringByReplacingOccurrencesOfString:deleteStr withString:@""];
        self.str = str;
        return self;
    };
}

/**
 * @brief 从后开始遍历删除指定字符
 * @ 参数为 string
 * @return 返回str.
 */
- (BaseStringHandler *(^)(NSString *deleteStr)) deleteLastStr {
    
    return ^ (NSString *deleteStr) {
        NSMutableString *str = self.str.mutableCopy;
        [str stringByReplacingOccurrencesOfString:deleteStr withString:@""];
        self.str = str.copy;
        return self;
    };
}

/**
 * @brief 从前开始遍历删除指定字符
 * @ 参数为 string
 * @return 返回str.
 */
- (BaseStringHandler *(^)(NSString *deleteStr)) deleteFrontStr {
    return ^ (NSString *deleteStr) {
        NSMutableString *str = self.str.mutableCopy;
        NSInteger i, length = str.length;
        NSString *firstStr = [str substringFromIndex:0];
        for (i = 0; i < length; i++) {
            if ([firstStr isEqualToString:deleteStr]) {
                NSRange range = NSMakeRange(0, 1);
                [str deleteCharactersInRange:range];
            }
        }
        self.str = str;
        return self;
    };
}

/**
 * @brief 删除最后一个字符 @ 参数为 void
 */
- (BaseStringHandler *(^)(void)) deleteLastChar {
    return ^ {
        NSMutableString *str = self.str.mutableCopy;
        NSRange range = NSMakeRange(self.str.length-1, 1);
        [str deleteCharactersInRange:range];
        self.str = str;
        return self;
    };
}

/**
 * @brief 删除第一个字符 @ 参数为 void
 */
- (BaseStringHandler *(^)(void)) deleteFrontChar {
    return ^ {
        NSMutableString *str = self.str.mutableCopy;
        NSRange range = NSMakeRange(0, 1);
        [str deleteCharactersInRange:range];
        self.str = str;
        return self;
    };
}

/**
 * @brief 获取高度 根据width @ 参数为 CGFloat (最大宽度)
 */
- (CGFloat (^)(CGFloat width,UIFont *font)) getHeightWithWidthAndFont {
    return ^(CGFloat width,UIFont *font) {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.str];
        if (font) {
            NSRange range = NSMakeRange(0, self.str.length);
            [str addAttribute:NSFontAttributeName value:font range: range];
        }
        return [str getHeightWithWidth:width];
    };
}

/**
 * @brief 获取高度 根据width @ 参数为 CGFloat (最大高度)
 */
- (CGFloat (^)(CGFloat height,UIFont *font)) getWidthWithHeightAndFont {
    return ^(CGFloat height,UIFont *font) {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.str];
        if (font) {
            NSRange range = NSMakeRange(0, self.str.length);
            [str addAttribute:NSFontAttributeName value:font range: range];
        }
        return [str getWidthWithHeight:height];
    };
}


+ (BaseStringHandler *(^)(NSInteger intValue)) createWithInt: (NSInteger)value {
    return ^(NSInteger intValue) {
        BaseStringHandler *handler = [BaseStringHandler new];
        handler.str = [NSString stringWithFormat:@"%ld",(long)intValue];
        return handler;
    };
}

/**
 float 转成字符串
 
 @param value float值
 @param decimalDigits 保留几位小数
 @param isRound 四舍五入或者直接去掉最后的小数
 @return string
 */
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



- (void) scaleFontByMaxWidth: (CGFloat)maxWidth
                  andMaxFont: (UIFont *)maxFont
                    andBlock: (void(^)(UIFont *font, CGFloat currentWidth))block {
    
    CGFloat originW = self.getWidthWithHeightAndFont(9999,maxFont);
    
    UIFont *newFont = maxFont;
    
    CGFloat currentW = originW;
    
    if (originW > maxWidth) {
        
        CGFloat fontsize = maxWidth / originW * maxFont.pointSize;
        newFont = [maxFont fontWithSize: fontsize];
        
        currentW = self.getWidthWithHeightAndFont(9999,newFont);
    }
    
    if (block) {
        block(newFont,currentW);
    }
}

- (BaseStringHandler *(^)(CGFloat value, NSInteger decimalDigits, BOOL isRound)) addFloat {
    return ^(CGFloat value, NSInteger decimalDigits, BOOL isRound) {
        NSString *floatValue = [NSString createWithFloat:value
                                        andDecimalDigits:decimalDigits
                                              andIsRound:isRound];
        self.str = [NSString stringWithFormat:@"%@%@",self.str,floatValue];
        return self;
    };
}


//判断是否为整形：
- (BOOL)isPureInt{
    NSScanner* scan = [NSScanner scannerWithString:self.str];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形：
- (BOOL)isPureFloat{
    NSScanner* scan = [NSScanner scannerWithString:self.str];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

/// 是否为数字
- (BOOL) isNumber
{
    if (self.str.length <= 0) {
        return NO;
    }
    NSString *regex = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:self.str];
}

@end
