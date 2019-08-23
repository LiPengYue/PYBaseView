//
//  AppDelegate.h
//  StarAnimation
//
//  Created by 李鹏跃 on 17/1/24.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "PYBaseGradientViewDrawRadialConfig.h"
#import "PYBaseGradientViewLineConfig.h"

@interface PYBaseGradientView : UIView
/// 线性绘制
- (void) drawLineGradient: (void(^)(PYBaseGradientViewLineConfig *lineConfig))drawLine;
/// 扩散绘制
- (void) drawRadialGradient: (void(^)(PYBaseGradientViewDrawRadialConfig *radialConfig))drawRadial;
@end
