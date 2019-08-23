//
//  BaseGradientViewBaseConfig.h
//  LYPCALayer
//
//  Created by 李鹏跃 on 2018/11/27.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BaseGradientViewConfigPointDefault CGPointMake(-1000, -1000)
///
@interface PYBaseGradientViewBaseConfig : NSObject
/** 绘制方式,
 
 kCGGradientDrawsBeforeStartLocation 开始位置之前就进行绘制，但是到结束位置之后不再绘制，
 kCGGradientDrawsAfterEndLocation开始位置之前不进行绘制，但到结束点之后继续填充
 */
@property (nonatomic,assign) CGGradientDrawingOptions options;

/**
 内部装的是颜色数组
 */
@property (nonatomic,copy) NSArray <UIColor *> *colorArray;

/**
 内部装的是NSNumber化的CGFloat
 */
@property (nonatomic,copy) NSArray <NSNumber *>*locationArray;
/**
 * 终点位置（通常和起始点相同，否则会有偏移）
 */
@property (nonatomic,assign) CGPoint endCenter;

/**
 * 相对终点位置
 * @warning endScaleCenter.x = self.center.x / self.width
 
 * endScaleCenter.y = self.center.y / self.height
 */
@property (nonatomic,assign) CGPoint endScaleCenter;

/**
 * 起始点位置
 */
@property (nonatomic,assign) CGPoint startCenter;

/**
 * 相对起点位置
 * @warning startScaleCenter.x = self.center.x / self.width
 
 * startScaleCenter.y = self.center.y / self.height
 */
@property (nonatomic,assign) CGPoint startScaleCenter;


@end
