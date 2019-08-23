//
//  BaseLabel.m
//  AttributedString
//
//  Created by 李鹏跃 on 2018/8/27.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

#import "PYBaseLabel.h"
#import <PYBaseStringHandler/PYBaseStringHandler.h>

@interface PYBaseLabel ()
@property (nonatomic,assign) CTFramesetterRef ctFramesetter;
@property (nonatomic,assign) CTFrameRef ctFrame;
@property (nonatomic,strong) NSMutableAttributedString *attributedStr;
@end


@implementation PYBaseLabel
@synthesize ctFramesetter = _ctFramesetter, ctFrame = _ctFrame;
#pragma mark - init

#pragma mark - functions

- (void) reloadFramestter {
    self.ctFramesetter = nil;
    self.ctFrame = nil;
}
- (void) setup {
    
}

- (CGRect)getLineBounds:(CTLineRef)line point:(CGPoint)point {
    CGFloat ascent = 0.0f;
    CGFloat descent = 0.0f;
    CGFloat leading = 0.0f;
    CGFloat width = (CGFloat)CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    CGFloat height = ascent + descent;
    return CGRectMake(point.x, point.y - descent, width, height);
}

- (CFIndex) touchContentOffsetPoint:(CGPoint)point
                           frameRef:(CTFrameRef)frameRef{
    
    NSArray * arrLines = (NSArray *)CTFrameGetLines(self.ctFrame);
    if (!arrLines) {
        return -1;
    }
    CFIndex count = arrLines.count;
    
    // 获得每一行的origin坐标
    CGPoint origins[count];
    CTFrameGetLineOrigins(frameRef, CFRangeMake(0,0), origins);
    
    // 翻转坐标系
    CGAffineTransform transform =  CGAffineTransformMakeTranslation(0, self.bounds.size.height);
    transform = CGAffineTransformScale(transform, 1.f, -1.f);
    
    CFIndex idx = -1;
    
    if (!self.attributedStr.length) {
        return idx;
    }
    
    CGSize size = self.currentTextSize;
    CGFloat offsetY = (self.frame.size.height - size.height)/2;
    offsetY = offsetY < 0 ? 0 : offsetY;
    
    NSInteger forCount = self.numberOfLines == 1 ? 1 : count;
    for (int i = 0; i < forCount; i++) {
        CGPoint pointOffset = point;
        CGPoint linePoint = origins[i];
        CTLineRef line = (__bridge CTLineRef)(arrLines[i]);
//        pointOffset.y -= offsetY;
//        pointOffset.x -= 4;
        
        // 获得每一行的CGRect信息
        CGRect flippedRect = [self getLineBounds:line
                                           point:linePoint];
        
        CGRect rect = CGRectApplyAffineTransform(flippedRect, transform);
        
        if (CGRectContainsPoint(rect, pointOffset)) {
            // 将点击的坐标转换成相对于当前行的坐标
            CGPoint relativePoint = CGPointMake(pointOffset.x-CGRectGetMinX(rect),
                                                pointOffset.y-CGRectGetMinY(rect));
            
            // 获得当前点击坐标对应的字符串偏移
            idx = CTLineGetStringIndexForPosition(line, relativePoint);
            
        }
    }
    NSLog(@"%ld",idx);
    return idx;
}

- (CGSize)getNumberOfLineFrame:(NSInteger)numberOfLines {
    CGFloat width = self.frame.size.width;
    if (width <= 0) {
        [self layoutSubviews];
        width = self.frame.size.width;
    }
    
    if (!self.ctFramesetter || width <= 0) {
        return CGSizeZero;
    }
    
    if (!self.attributedStr.length) {
        return CGSizeZero;
    }
    
    CFRange cfRange = CFRangeMake(0, self.attributedStr.length);
    
    CGSize size = CTFramesetterSuggestFrameSizeWithConstraints(self.ctFramesetter, cfRange, nil, CGSizeMake(width, CGFLOAT_MAX), nil);
    
    NSArray * arrLines = (NSArray *)CTFrameGetLines(self.ctFrame);
    if (!arrLines) {
        return CGSizeZero;
    }
    
    CFIndex count = arrLines.count;
    if (numberOfLines <= 0 || numberOfLines >= count) {
        return size;
    }
    
    // 获得每一行的origin坐标
    CGPoint origins[count];
    CTFrameGetLineOrigins(self.ctFrame, CFRangeMake(0,0), origins);
    
    // 翻转坐标系
    CGAffineTransform transform =  CGAffineTransformMakeTranslation(0, self.bounds.size.height);
    
    transform = CGAffineTransformScale(transform, 1.f, -1.f);
    NSInteger i = numberOfLines;
    
    CTLineRef line = (__bridge CTLineRef)(arrLines[i]);
    CGPoint linePoint = origins[i];
    CGRect flippedRect = [self getLineBounds:line
                                       point:linePoint];
    CGRect rect = CGRectApplyAffineTransform(flippedRect, transform);
    size.height = CGRectGetMaxY(rect);
    return size;
}

/// 获取某一行的frame
- (CGRect)getLineFrame:(NSInteger)numberOfLine {
    CGRect rect = CGRectZero;
    CGSize size = [self getNumberOfLineFrame:numberOfLine];
    CGFloat y = (self.frame.size.height - size.height)/2;
    rect.size = size;
    rect.origin.y = y;
    return rect;
}

// MARK: network
// MARK: handle views
// MARK: handle event
// MARK: properties get && set

- (NSMutableAttributedString *) attributedStr {
    if (!_attributedStr) {
        _attributedStr = [self.attributedText mutableCopy];
    }
    if (!_attributedStr) {
        NSString *str = self.text.length <= 0 ? @"" : self.text;
        _attributedStr = [[NSMutableAttributedString alloc]initWithString:str];
        NSRange range = NSMakeRange(0, str.length);
        [_attributedStr addAttribute: NSFontAttributeName value:self.font range:range];
    }
    return _attributedStr;
}

- (CTFramesetterRef) ctFramesetter {
    if (!_ctFramesetter) {
        CFAttributedStringRef str = (__bridge CFAttributedStringRef)self.attributedText;
        _ctFramesetter = CTFramesetterCreateWithAttributedString(str);
    }
    return _ctFramesetter;
}

- (CTFrameRef) ctFrame {
    if (!self.frame.size.width) return nil;
    if (!_ctFrame) {
        CFRange range = CFRangeMake(0, self.attributedStr.length);
        CGRect rect = self.bounds;
        //        rect.origin.y -= 44;
        //        rect.size.height -= 8;
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
        
        _ctFrame = CTFramesetterCreateFrame(self.ctFramesetter, range, path.CGPath, nil);
    }
    return _ctFrame;
}

- (void) setCtFrame:(CTFrameRef)ctFrame {
    if (_ctFrame) CFRelease(_ctFrame);
    _ctFrame = ctFrame;
}

- (void) setCtFramesetter:(CTFramesetterRef)ctFramesetter {
    if (_ctFramesetter) CFRelease(_ctFramesetter);
    _ctFramesetter = ctFramesetter;
}

- (CGSize) currentTextSize {
    return [self getNumberOfLineFrame:self.numberOfLines];
}

- (CGSize) allTextSize {
    return [self getNumberOfLineFrame:-1];
}

// MARK:life cycles
-(void)dealloc {
    Class classStr = [self class];
    NSLog(@"✅ ： %@",classStr);
    CFRelease(self.ctFrame);
    CFRelease(self.ctFramesetter);
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [super touchesBegan:touches withEvent:event];
    
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    
    // 获取 index
    CFIndex index = [self touchContentOffsetPoint:location frameRef:self.ctFrame];
    
    if (index < 0 || index >= self.attributedText.length) {
        return;
    }
    if (self.attributedStr.length < 1) {
        return;
    }
    
    /// 点击范围
    NSRange range = NSMakeRange(0, 1);
    
    NSDictionary <NSString *,id> *attributes = [self.attributedStr attributesAtIndex:index effectiveRange:&range];
    
    SingleCallBack block = attributes[k_NSMutableAttributedStringRegisterSingleCliekWithBlock];
    if (block) {
        block();
    }
    
    NSObject *targate = attributes[k_NSMutableAttributedStringSingleTarget];
    NSObject *data = attributes[k_NSMutableAttributedStringSingleData];
    NSString *func = attributes[k_NSMutableAttributedStringSingleClick];
    
    if (!targate || !func) {
        return;
    }
    
    SEL sel = NSSelectorFromString(func);
    IMP imp = [targate methodForSelector:sel];
    
    if (![targate respondsToSelector:sel]) {
        return;
    }
    
    void (*function)(id, SEL,NSObject *) = (void *)imp;
    function(targate, sel,data);
}

@end

