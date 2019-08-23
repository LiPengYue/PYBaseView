//
//  BaseGradientViewLineConfig.h
//  LYPCALayer
//
//  Created by 李鹏跃 on 2018/11/27.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//
#import "PYBaseGradientViewBaseConfig.h"
#import "PYBaseGradientViewLineConfig.h"
/// 线性填充
@interface PYBaseGradientViewLineConfig : PYBaseGradientViewBaseConfig
/**
 内部装的是颜色数组
 */
- (PYBaseGradientViewLineConfig *(^)(NSArray <UIColor *> *colorArray))setUpColorArray;
/**
 内部装的是NSNumber化的CGFloat
 */
- (PYBaseGradientViewLineConfig *(^)(NSArray <NSNumber *>*locationArray)) setUpLocationArray;
/**
 * 终点位置（通常和起始点相同，否则会有偏移）
 */
- (PYBaseGradientViewLineConfig *(^)(CGPoint endCenter)) setUpEndCenter;
/**
 * 起始点位置
 */
- (PYBaseGradientViewLineConfig *(^)(CGPoint startCenter)) setUpStartCenter;

/**
 * 相对起点位置
 * @warning startScaleCenter.x = self.center.x / self.width
 
 * startScaleCenter.y = self.center.y / self.height
 */
- (PYBaseGradientViewLineConfig *(^)(CGPoint endCenter)) setUpScaleStartCenter;
/**
 * 相对终点位置
 * @warning endScaleCenter.x = self.center.x / self.width
 
 * endScaleCenter.y = self.center.y / self.height
 */
- (PYBaseGradientViewLineConfig *(^)(CGPoint endCenter)) setUpScaleEndCenter;

/** 绘制方式,
 
 kCGGradientDrawsBeforeStartLocation 开始位置之前就进行绘制，但是到结束位置之后不再绘制，
 kCGGradientDrawsAfterEndLocation开始位置之前不进行绘制，但到结束点之后继续填充
 */
- (PYBaseGradientViewLineConfig *(^)(CGGradientDrawingOptions options)) setUpOptions;
@end
