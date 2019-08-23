//
//  BaseGradientViewDrawRadialConfig.m
//  LYPCALayer
//
//  Created by 李鹏跃 on 2018/11/26.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

#import "PYBaseGradientViewDrawRadialConfig.h"

@implementation PYBaseGradientViewDrawRadialConfig


/// 起始半径（通常为0，否则在此半径范围内容无任何填充）
- (PYBaseGradientViewDrawRadialConfig *(^)(CGFloat startRadius)) setUpStartRadius {
    return ^(CGFloat startRadius) {
        self.startRadius = startRadius;
        return self;
    };
}

/// 终点半径（也就是渐变的扩散长度）
- (PYBaseGradientViewDrawRadialConfig *(^)(CGFloat endRadius)) setUpEndRadius {
    return ^(CGFloat endRadius) {
        self.endRadius = endRadius;
        return self;
    };
}

/** 绘制方式,
 
 kCGGradientDrawsBeforeStartLocation 开始位置之前就进行绘制，但是到结束位置之后不再绘制，
 kCGGradientDrawsAfterEndLocation开始位置之前不进行绘制，但到结束点之后继续填充
 */
- (PYBaseGradientViewDrawRadialConfig *(^)(CGGradientDrawingOptions options)) setUpOptions {
    return ^(CGGradientDrawingOptions options) {
        self.options = options;
        return self;
    };
}

/**
 内部装的是颜色数组
 */
- (PYBaseGradientViewDrawRadialConfig *(^)(NSArray <UIColor *> *colorArray))setUpColorArray {
    return ^(NSArray <UIColor *> *colorArray) {
        self.colorArray = colorArray;
        return self;
    };
}
/**
 内部装的是NSNumber化的CGFloat
 */
- (PYBaseGradientViewDrawRadialConfig *(^)(NSArray <NSNumber *>*locationArray)) setUpLocationArray{
    return ^(NSArray <NSNumber *>*locationArray) {
        self.locationArray = locationArray;
        return self;
    };
}
/**
 * 终点位置（通常和起始点相同，否则会有偏移）
 */
- (PYBaseGradientViewDrawRadialConfig *(^)(CGPoint endCenter)) setUpEndCenter {
    return ^(CGPoint end) {
        self.endCenter = end;
        return self;
    };
}
/**
 * 起始点位置
 */
- (PYBaseGradientViewDrawRadialConfig *(^)(CGPoint startCenter)) setUpStartCenter {
    return ^(CGPoint start) {
        self.startCenter = start;
        return self;
    };
}

- (PYBaseGradientViewDrawRadialConfig *(^)(CGPoint endCenter)) setUpScaleStartCenter {
    return ^(CGPoint start) {
        self.startScaleCenter = start;
        return self;
    };
}
- (PYBaseGradientViewDrawRadialConfig *(^)(CGPoint endCenter)) setUpScaleEndCenter {
    return ^(CGPoint end) {
        self.endScaleCenter = end;
        return self;
    };
}
@end
