//
//  NSAttributedString+Size.m
//  yiapp
//
//  Created by 李鹏跃 on 2018/10/23.
//  Copyright © 2018年 yi23. All rights reserved.
//

#import "NSAttributedString+Size.h"
#import "BaseAttriButedStrHandler+ChangeStyle.h"
@implementation NSAttributedString (Size)
- (NSInteger) getMaxLineWithSize: (CGSize)maxSize {
    CGFloat width = maxSize.width;
    CGFloat height = maxSize.height;
    
    if (!self || width <= 0 || height <= 0) {
        return 0;
    }
    
    CFAttributedStringRef str = (__bridge CFAttributedStringRef)self;
    CTFramesetterRef framesetterRef = CTFramesetterCreateWithAttributedString(str);
    CGPathRef path = CGPathCreateWithRect(CGRectMake(0, 0, maxSize.width, CGFLOAT_MAX), nil);
    CFRange cfRange = CFRangeMake(0, self.length);
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetterRef, cfRange, path, nil);
    NSArray * arrLines = (NSArray *)CTFrameGetLines(frameRef);
    if (!arrLines) { return 0; }
    
    CFRelease(framesetterRef);
    CFRelease(path);
    CFRelease(frameRef);
    return arrLines.count;
}

- (NSInteger (^)(CGSize maxSize)) getMaxLineWithMaxSize {
    return ^ (CGSize maxSize) {
        return [self getMaxLineWithSize:maxSize];
    };
}

- (CGFloat) getHeightWithWidth: (CGFloat)w {
    CGSize size = CGSizeMake(w, 99999);
    return [self getSizeWithSize:size].height;
}
- (CGFloat (^)(CGFloat))getHeightWithMaxW {
    return ^(CGFloat w) {
        return [self getHeightWithWidth:w];
    };
}

- (CGFloat) getWidthWithHeight: (CGFloat)H {
    CGSize size = CGSizeMake(99999,H);
    return [self getSizeWithSize:size].width;
}
- (CGFloat(^)(CGFloat H)) getWidthtWithMaxH {
    return ^(CGFloat h) {
        return [self getWidthWithHeight:h];
    };
}

- (CGSize) getSizeWithSize: (CGSize) size {
    NSMutableAttributedString *str = [self mutableCopy];

    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)str);
    __block CGSize attriSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, str.length), NULL, size, NULL);
    CFRelease(framesetter);
    
    return attriSize;
}

/// 因为在计算高度的时候，NSLineBreakByCharWrapping 才能计算的正确
//- (NSMutableAttributedString *) setupNSLineBreakByCharWrapping {
//    NSMutableAttributedString *str = self.mutableCopy;
//    str = BaseAttributedStrHandler
//    .handle(str)
//    .setUpStyleHandler(
//                       BaseParagraphStyleHandler
//                       .handler()
//                       .setUpLineBreakMode(NSLineBreakByWordWrapping)
//                       ).str;
//
//    return str;
//}


- (CGRect) getNumberOfLineFrame:(NSInteger)numberOfLines
                        andSize:(CGSize)maxSize {
    if (numberOfLines < 0) {
        return CGRectZero;
    }
    
    CGFloat width = maxSize.width;
    CGFloat height = maxSize.height;
    CGRect rect = CGRectMake(0, 0, width, height);
    if (!self || width <= 0 || height <= 0) {
        return CGRectZero;
    }
    
    CFAttributedStringRef str = (__bridge CFAttributedStringRef)[self mutableCopy];
    CTFramesetterRef framesetterRef = CTFramesetterCreateWithAttributedString(str);
    CGPathRef path = CGPathCreateWithRect(rect, nil);
    CFRange cfRange = CFRangeMake(0, self.length);
    CTFrameRef frameRef = CTFramesetterCreateFrame(framesetterRef, cfRange, path, nil);
    
    NSArray * arrLines = (NSArray *)CTFrameGetLines(frameRef);
    if (!arrLines) { return CGRectZero; }
    
    CFIndex count = arrLines.count;
    
    // 获得每一行的origin坐标
    CGPoint origins[count];
    CTFrameGetLineOrigins(frameRef, CFRangeMake(0,0), origins);
    
    // 翻转坐标系
    CGAffineTransform transform =  CGAffineTransformMakeTranslation(0, height);
    
    transform = CGAffineTransformScale(transform, 1.f, -1.f);
    
    NSInteger maxLineIndex = arrLines.count - 1;
    NSInteger i = numberOfLines > maxLineIndex ?  maxLineIndex : numberOfLines;
    
    CTLineRef line = (__bridge CTLineRef)(arrLines[i]);
    CGPoint linePoint = origins[i];
    CGRect flippedRect = [self getLineBounds:line
                                       point:linePoint];
    rect = CGRectApplyAffineTransform(flippedRect, transform);
    
    CFRelease(framesetterRef);
    CFRelease(frameRef);
    CFRelease(path);
    
    return rect;
}

- (CGRect)getLineBounds:(CTLineRef)line point:(CGPoint)point {
    CGFloat ascent = 0.0f;
    CGFloat descent = 0.0f;
    CGFloat leading = 0.0f;
    CGFloat width = (CGFloat)CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    CGFloat height = ascent + descent;
    return CGRectMake(point.x, point.y - descent, width, height);
}

/**
 根据 self.attributedString 的length */
- (NSMutableAttributedString *) scaleFontByMaxWidth: (CGFloat)maxWidth
                                         andMaxFont: (UIFont *)maxFont
                                           andBlock: (void(^)(UIFont *font, CGFloat currentWidth))block {
    
    if (!self.length && block) { block(maxFont,0); }
    
    NSMutableAttributedString *str = self.mutableCopy;
    
    CGFloat originW =
    BaseAttributedStrHandler
    .handle(str)
    .setUpFont(maxFont)
    .str
    .getWidthtWithMaxH(9999);
    
    UIFont *newFont = maxFont;
    CGFloat currentW = originW;
    
    if (originW > maxWidth) {
        
        CGFloat fontsize = maxWidth / originW * maxFont.pointSize;
        newFont = [maxFont fontWithSize: fontsize];
        
        originW =
        BaseAttributedStrHandler
        .handle(str)
        .setUpFont(newFont)
        .str
        .getWidthtWithMaxH(999);
    }
    
    if (block) {
        block(newFont,currentW);
    }
    return str;
}
@end
