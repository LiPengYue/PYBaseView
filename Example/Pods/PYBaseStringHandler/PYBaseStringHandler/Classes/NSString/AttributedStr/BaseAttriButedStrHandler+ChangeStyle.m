//
//  BaseAttributedStrHandler+ChangeStyle.m
//  AttributedString
//
//  Created by 李鹏跃 on 2018/8/25.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

#import "BaseAttriButedStrHandler+ChangeStyle.h"
#import <objc/runtime.h>


@implementation BaseAttributedStrHandler (ChangeStyle)
static NSString *const k_BaseAttributedStrHandlerCurrenRange = @"BaseAttributedStrHandlerCurrenRange";
NSString * const keventTarget = @"keventTarget";
NSString * const kAttributedStringCTFrameRef = @"kAttributedStringCTFrameRef";
NSString * const kAttributedStringCTFramestterRef = @"kAttributedStringCTFramestterRef";

- (void) setUpWeakSelfFunc: (void(^)(BaseAttributedStrHandler *weak))block {
    if (block) {
        __weak typeof(self)weakSelf = self;
        block(weakSelf);
    }
}

+ (BaseAttributedStrHandler *) createWithImage: (UIImage *)image andBounds: (CGRect)bounds {
    //创建Attachment Str
    NSTextAttachment * attach = [[NSTextAttachment alloc] init];
    attach.image = image;
    attach.bounds = bounds;
    NSAttributedString * imageStr = [NSAttributedString attributedStringWithAttachment:attach];
    //添加
    BaseAttributedStrHandler * handler = BaseAttributedStrHandler.createWithAttributedStr(imageStr);
    return handler;
}

+ (BaseAttributedStrHandler *) createWithImageName: (NSString *)name andBounds: (CGRect)bounds {
    UIImage *image = [UIImage imageNamed:name];
    return [self createWithImage:image andBounds:bounds];
}


- (NSRange) getRange {
    NSValue *value = objc_getAssociatedObject(self, &k_BaseAttributedStrHandlerCurrenRange);
    NSRange range = [value rangeValue];
    if (!range.length && !range.location) {
        range = NSMakeRange(0, self.str.length);
    }
    return range;
}

- (NSRange) range {
    return NSMakeRange(0, self.str.length);
}

- (void) setRange: (NSRange)range {
    NSValue *rangeValue = [NSValue valueWithRange:range];
    objc_setAssociatedObject(self, &k_BaseAttributedStrHandlerCurrenRange, rangeValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CFRange) getCfRange {
    return CFRangeMake(0, self.str.length);
}

- (BaseAttributedStrHandler *(^)(BaseAttributedStrHandler *str)) append {
    return ^(BaseAttributedStrHandler *str) {
        [self.str appendAttributedString:str.str];
        return self;
    };
}
- (BaseAttributedStrHandler *(^)(NSAttributedString *str)) appendStr {
    return ^(NSAttributedString *str) {
        [self.str appendAttributedString:str];
        return self;
    };
}

- (instancetype) setupInRange:(NSRange)range andCallBack: (void(^)(BaseAttributedStrHandler *attributedStr))callBack{
    [self setRange:range];
    NSAttributedString *str = [[self.str attributedSubstringFromRange:range] mutableCopy];
    BaseAttributedStrHandler *strHandler = BaseAttributedStrHandler.handle(str);
    if(callBack) {
        callBack(strHandler);
    }
    [self.str replaceCharactersInRange:range withAttributedString:strHandler.str];
    [self setRange: NSMakeRange(0, self.length)];
    return self;
}




- (BaseAttributedStrHandler *(^)(UIColor *)) setUpColor {
    __weak typeof (self) weakSelf = self;
    return ^(UIColor *color) {
        [weakSelf foregroundColor:color];
        return weakSelf;
    };
}

- (BaseAttributedStrHandler *(^)(UIFont *)) setUpFont {
    __weak typeof (self) weakSelf = self;
    return ^(UIFont *font) {
        [weakSelf font:font];
        return weakSelf;
    };
}

- (BaseAttributedStrHandler *(^)(UIColor *color)) setUpBackgroundColor {
    __weak typeof (self) weakSelf = self;
    return ^(UIColor *color) {
        [weakSelf backgroundColor:color];
        return weakSelf;
    };
}

- (BaseAttributedStrHandler *(^)(BOOL isLigature))setUpIsLigature{
    __weak typeof (self) weakSelf = self;
    return ^(BOOL isLigature) {
        [weakSelf ligature:isLigature];
        return weakSelf;
    };
}

- (BaseAttributedStrHandler *(^)(UIColor *color)) setUpStrokeColor{
    __weak typeof (self) weakSelf = self;
    return ^(UIColor *color) {
        [weakSelf strokeColor:color];
        return weakSelf;
    };
}

- (BaseAttributedStrHandler *(^)(CGFloat width)) setUpStrokeWidth {
    __weak typeof (self) weakSelf = self;
    return ^(CGFloat width) {
        [weakSelf strokeWidth:width];
        return weakSelf;
    };
}

- (BaseAttributedStrHandler *(^)(NSShadow *shadow)) setUpShadow {
    __weak typeof (self) weakSelf = self;
    return ^(NSShadow *shadow) {
        [weakSelf shadow:shadow];
        return weakSelf;
    };
}

- (BaseAttributedStrHandler *(^)(NSAttStrChangeStyleLineStyleEffectEnum effect)) setUpTextEffect {
    __weak typeof (self) weakSelf = self;
    return ^(NSAttStrChangeStyleLineStyleEffectEnum effect) {
        NSString *effectStr;
        switch (effect) {
            case NSAttStrChangeStyleLineStyleEffectEnum_LetterpressStyle:
                effectStr = NSTextEffectLetterpressStyle;
                break;
        }
        [weakSelf textEffect:effectStr];
        return weakSelf;
    };
}

- (BaseAttributedStrHandler *(^)(NSTextAttachment *attachment)) setUpAttachment {
    __weak typeof (self) weakSelf = self;
    return ^(NSTextAttachment *attachment) {
        [weakSelf attachment:attachment];
        return weakSelf;
    };
}

- (BaseAttributedStrHandler *(^)(CGFloat offset)) setUpBaselineOffset {
    __weak typeof (self) weakSelf = self;
    return ^(CGFloat offset) {
        [weakSelf baselineOffset:offset];
        return weakSelf;
    };
}

- (BaseAttributedStrHandler *(^)(UIColor *color)) setUpUnderLineColor {
    __weak typeof (self) weakSelf = self;
    return ^(UIColor *color) {
        [weakSelf underLineColor:color];
        return weakSelf;
    };
}

- (BaseAttributedStrHandler *(^)(NSAttStrChangeStyleLineStyleEnum style, UIColor *color,NSNumber *OffsetAttributeName)) setUpStrikethrough {
    __weak typeof (self) weakSelf = self;
    return ^(NSAttStrChangeStyleLineStyleEnum style, UIColor *color,NSNumber *OffsetAttributeName) {
        NSNumber *styleNumbser = [self getNumbserWithStyle:style];
        if (!OffsetAttributeName) {
            OffsetAttributeName = @0;
        }
        NSDictionary *dic = @{
          NSStrikethroughStyleAttributeName : styleNumbser,
          NSStrikethroughColorAttributeName : color,
          NSBaselineOffsetAttributeName : OffsetAttributeName
          };
        
        [weakSelf.str addAttributes:dic range:[weakSelf getRange]];
        return weakSelf;
    };
}

- (BaseAttributedStrHandler *(^)(CGFloat obliqueness)) setUpObliqueness {
    __weak typeof (self) weakSelf = self;
    return ^(CGFloat obliqueness) {
        [weakSelf obliqueness:obliqueness];
        return weakSelf;
    };
}

- (BaseAttributedStrHandler *(^)(CGFloat expansion)) setUpExpansion {
    __weak typeof (self) weakSelf = self;
    return ^(CGFloat expansion) {
        [weakSelf expansion:expansion];
        return weakSelf;
    };
}

- (BaseAttributedStrHandler *(^)(BOOL isVertical)) setUpIsVertical {
    __weak typeof (self) weakSelf = self;
    return ^(BOOL isVertical) {
        [weakSelf verticalGlyph:isVertical];
        return weakSelf;
    };
}

- (BaseAttributedStrHandler *(^)(NSMutableParagraphStyle *style)) setUpMutableParagraphStyle {
    __weak typeof (self) weakSelf = self;
    return ^(NSMutableParagraphStyle *style) {
        [weakSelf mutableParagraphStyle:style];
        return weakSelf;
    };
}

- (BaseAttributedStrHandler *(^)(BaseParagraphStyleHandler *style)) setUpStyleHandler {
    __weak typeof (self) weakSelf = self;
    return ^(BaseParagraphStyleHandler *style) {
        [weakSelf mutableParagraphStyle:style.style];
        return weakSelf;
    };
}


- (BaseAttributedStrHandler *(^)(NSString *)) setUpLink {
    __weak typeof (self) weakSelf = self;
    return ^(NSString *link) {
        [weakSelf linkString:link];
        return weakSelf;
    };
}

- (BaseAttributedStrHandler *(^)(CGFloat)) setUpKern {
    __weak typeof (self) weakSelf = self;
    return ^(CGFloat kern) {
        [weakSelf kern:kern];
        return weakSelf;
    };
}

- (BaseAttributedStrHandler *(^)(SingleCallBack singleCallBack)) setUpRegisterSingleClick {
     __weak typeof (self) weakSelf = self;
    return ^(SingleCallBack singleCallBack) {
        if (singleCallBack) {
            [weakSelf.str addAttribute:k_NSMutableAttributedStringRegisterSingleCliekWithBlock value:singleCallBack range:[weakSelf getRange]];
        }
        return weakSelf;
    };
}

- (BaseAttributedStrHandler *(^)(NSAttStrChangeStyleLineStyleEnum style, UIColor *color)) setUpAddBottomLine {
    __weak typeof (self) weakSelf = self;
    return ^(NSAttStrChangeStyleLineStyleEnum style,UIColor *color) {
        [weakSelf addBottomLineWithColor:color andStyle:style];
        return weakSelf;
    };
}

- (BaseAttributedStrHandler *(^)(CGFloat width, UIColor *color)) setUpStroke {
    __weak typeof (self) weakSelf = self;
    return ^(CGFloat width, UIColor *color) {
        [weakSelf strokeWithWidth:width andColor:color];
        return weakSelf;
    };
}


- (instancetype) foregroundColor: (UIColor *)color {
    if (color) {
        [self.str addAttribute:NSForegroundColorAttributeName value:color range:[self getRange]];
    }
    return self;
}
- (instancetype) font: (UIFont *)font {
    if (font) {
        [self.str addAttribute:NSFontAttributeName value:font range:[self getRange]];
    }
    return self;
}
- (instancetype) backgroundColor: (UIColor *)color {
    if (color) {
        [self.str addAttribute:NSBackgroundColorAttributeName value:color range:[self getRange]];
    }
    return self;
}
- (instancetype) ligature: (BOOL)isLigature {
    [self.str addAttribute:NSLigatureAttributeName value:@(isLigature) range:[self getRange]];
    return self;
}
- (instancetype) kern: (CGFloat)kern {
    [self.str addAttribute:NSKernAttributeName value:@(kern) range:[self getRange]];
    return self;
}
- (instancetype) strikethroughStyle: (NSNumber *)value {
    if (value) {
        [self.str addAttribute:NSStrikethroughStyleAttributeName value:value range:[self getRange]];
    }
    return self;
}
- (instancetype) underlineStyle: (NSNumber *)value {
    if (value) {
        [self.str addAttribute:NSUnderlineStyleAttributeName value:value range:[self getRange]];
    }
    return self;
}
- (instancetype) strokeColor: (UIColor *)color {
    if (color) {
        [self.str addAttribute:NSStrokeColorAttributeName value:color range:[self getRange]];
    }
    return self;
}
- (instancetype) strokeWidth: (CGFloat) width {
    [self.str addAttribute:NSStrokeWidthAttributeName value:@(width) range:[self getRange]];
    return self;
}
- (instancetype) shadow: (NSShadow *)shadow {
    if (shadow) {
        [self.str addAttribute:NSShadowAttributeName value:shadow range:[self getRange]];
    }
    return self;
}
- (instancetype) textEffect: (NSString *)effect {
    if (effect.length > 0) {
        [self.str addAttribute:NSTextEffectAttributeName value:effect range:[self getRange]];
    }
    return self;
}
- (instancetype) attachment: (NSTextAttachment *)value {
    if (value) {
        [self.str addAttribute:NSAttachmentAttributeName value:value range:[self getRange]];
    }
    return self;
}
- (instancetype) linkString: (NSString *)string {
    if (string.length > 0) {
        [self.str addAttribute:NSLinkAttributeName value:string range:[self getRange]];
    }
    return self;
}
- (instancetype) baselineOffset: (CGFloat)offset {
    [self.str addAttribute:NSBaselineOffsetAttributeName value:@(offset) range:[self getRange]];
    return self;
}
- (instancetype) underLineColor: (UIColor *)color {
    if (color) {
        [self.str addAttribute:NSUnderlineColorAttributeName value:color range:[self getRange]];
    }
    return self;
}
- (instancetype) strikethroughColor: (UIColor *)color {
    if (color) {
        [self.str addAttribute:NSStrikethroughColorAttributeName value:color range:[self getRange]];
    }
    return self;
}
- (instancetype) obliqueness: (CGFloat)value {
    [self.str addAttribute:NSBaselineOffsetAttributeName value:@(value) range:[self getRange]];
    return self;
}
- (instancetype) expansion: (CGFloat)value {
    [self.str addAttribute:NSExpansionAttributeName value:@(value) range:[self getRange]];
    return self;
}
- (instancetype) verticalGlyph: (BOOL) isVertical {
    [self.str addAttribute:NSVerticalGlyphFormAttributeName value:@(isVertical) range:[self getRange]];
    return self;
}
- (instancetype) mutableParagraphStyle: (NSMutableParagraphStyle *)style {
    if (style) {
        [self.str addAttribute:NSParagraphStyleAttributeName value:style range:[self getRange]];
    }
    return self;
}
- (NSNumber *) getNumbserWithStyle: (NSAttStrChangeStyleLineStyleEnum)style {
    NSNumber *styleNumbser = @0;
    switch (style) {
        case NSAttStrChangeStyleLineStyleEnum_Single:
            styleNumbser = @(NSUnderlineStyleSingle);
            break;
        case NSAttStrChangeStyleLineStyleEnum_Double:
            styleNumbser = @(NSUnderlineStyleDouble);
            break;
        case NSAttStrChangeStyleLineStyleEnum_Thick:
            styleNumbser = @(NSUnderlineStyleThick);
            break;
        case NSAttStrChangeStyleLineStyleEnum_None:
            styleNumbser = @(NSUnderlineStyleNone);
            break;
    }
    return styleNumbser;
}
- (instancetype) addBottomLineWithColor: (UIColor *)color
                               andStyle: (NSAttStrChangeStyleLineStyleEnum)style {
    NSNumber *styleNumbser = [self getNumbserWithStyle:style];
    NSDictionary * attris = @{
                              NSUnderlineStyleAttributeName:styleNumbser,
                              NSUnderlineColorAttributeName:color
                              };
    
    [self.str addAttributes:attris range: [self getRange]];
    return self;
}
- (instancetype) strokeWithWidth: (CGFloat)w
                        andColor: (UIColor *)color {
    
    BaseAttributedStrHandler * mutableAttriStr = self;
    NSDictionary * attris = @{
                              NSStrokeColorAttributeName:color,
                              NSStrokeWidthAttributeName:@(w)
                              };
    NSRange range = NSMakeRange(0,mutableAttriStr.length);
    [mutableAttriStr.str addAttributes:attris range:range];
    return mutableAttriStr;
}


//- (BaseAttributedStrHandler *(^)(SEL, NSObject *target, NSObject *data)) singleClick {
//    __weak typeof (self) weakSelf = self;
//    return ^(SEL selecter, NSObject *target, NSObject *data) {
//
//        NSLog(@"str指针内存地址：%x",&target);
//        NSLog(@"str指针所指向对象的地址：%p\n",target);
//        NSString *selecterStr = NSStringFromSelector(selecter);
//
//        [weakSelf addAttribute:k_BaseAttributedStrHandlerSingleClick value:selecterStr range:[weakSelf getRange]];
//
//        [weakSelf addAttribute:k_BaseAttributedStrHandlerSingleData value:data range:[weakSelf getRange]];
//
//        //MARK: - 出现循环引用问题
//        [weakSelf addAttribute:k_BaseAttributedStrHandlerSingleTarget value:target range:[weakSelf getRange]];
//        return weakSelf;
//    };
//}


//- (BaseAttributedStrHandler *(^)(NSObject *))target {
//    __weak typeof (self) weakSelf = self;
//    return ^(NSObject *obj){
//        NSLog(@"%@",obj);
////        [weakSelf addAttribute:@"qq" value:obj range: [weakSelf getRange]];
////        weakSelf.eventTarget = obj;
//        return weakSelf;
//    };
//}
//- (BaseAttributedStrHandler *) test:(NSObject *)obj; {
//    NSLog(@"test 指针内存地址：%x",&obj);
//    NSLog(@"test 指针所指向对象的地址：%p\n",obj);
//    return self;
//}



// MARK: - set && get

//- (void) setEventTarget:(NSObject *)eventTarget {
//
//    objc_setAssociatedObject(self, &keventTarget, eventTarget, OBJC_ASSOCIATION_ASSIGN);
//    if (self.eventTarget) {
//        __weak typeof(self.eventTarget) weakEvent = self.eventTarget;
//    }
//}
//- (NSObject *) eventTarget {
//    return objc_getAssociatedObject(self, &keventTarget);
//}

@end
