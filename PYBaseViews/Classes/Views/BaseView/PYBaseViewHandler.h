//
//  PYBaseViewHandler.h
//  PYKit
//
//  Created by 李鹏跃 on 2018/9/11.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYViewShadowConfigration.h"

NS_ASSUME_NONNULL_BEGIN

@interface PYBaseViewHandler : NSObject

+ (PYBaseViewHandler *(^)(UIView *view)) handle;

/**
 * @brief  是否隐藏hh
 * @warning 参数类型： BOOL
 * @bug 需要保证 self != nil
 */
- (PYBaseViewHandler *(^)(BOOL)) setUpHidden;
/**
 * @brief  CGFloat 圆角大小
 * @warning 参数类型： CGFloat
 * @bug 需要保证 self != nil
 */
- (PYBaseViewHandler *(^)(CGFloat)) setUpCornerRadius;

/**
 * @brief  BOOL 超出范围是否裁切
 * @warning 参数类型： BOOL
 * @bug 需要保证 self != nil
 */
- (PYBaseViewHandler *(^)(BOOL)) setUpMasksToBounds;

/**
 * @brief  CGFloat 边框宽度
 * @warning 参数类型： CGFloat
 * @bug 需要保证 self != nil
 */
- (PYBaseViewHandler *(^)(CGFloat)) setUpBorderWidth;

/**
 * @brief  UIColor 边框颜色
 * @warning 参数类型： UIColor
 * @bug 需要保证 self != nil
 */
- (PYBaseViewHandler *(^)(UIColor *)) setUpBorderColor;

/**
 * @brief  UIColor 设置背景色
 * @warning 参数类型： UIColor
 * @bug 需要保证 self != nil
 */
- (PYBaseViewHandler *(^)(UIColor *)) setUpBackgroundColor;


// MARK: - 关于约束

/**
 * @brief 抗拉伸 设置优先级 默认为 横向
 *
 * @warning 如果有空余，那么优先级越高 越不容易被拉伸
 * @warning 参数类型： UILayoutPriority
 * @bug 需要保证 self != nil
 */
- (PYBaseViewHandler *(^)(UILayoutPriority priority)) setUpHuggingPriority;
/**
 * @brief 抗压缩 设置优先级 默认为 横向
 *
 * @warning 如果有没有空余，那么优先级越高 越不容易被压缩
 * @warning 参数类型： UILayoutPriority
 * @bug 需要保证 self != nil
 */
- (PYBaseViewHandler *(^)(UILayoutPriority priority)) setUpCompressionPriority;

/**
 * @brief 抗拉伸（有空余的情况下，谁不容易被拉伸）  默认为 横向
 *
 * @warning 横向还是纵向进行优先级限制
 * @warning 参数类型： UILayoutConstraintAxis
 * @bug 需要保证 self != nil
 */
- (PYBaseViewHandler *(^)(UILayoutConstraintAxis constraint)) setUpHuggingAxis;

/**
 * @brief 抗压缩（没有空余的情况下，谁不容易被压缩）默认为 横向
 *
 * @warning 横向还是纵向进行优先级限制
 * @warning 参数类型： UILayoutConstraintAxis
 * @bug 需要保证 self != nil
 */
- (PYBaseViewHandler *(^)(UILayoutConstraintAxis constraint)) setUpCompressionAxis;

// MARK: - 关于阴影
/**
 * @brief 设置阴影的offsetY
 * 默认为0
 * @bug 需要保证 self != nil
 */
- (PYBaseViewHandler *(^)(CGFloat Y)) setUpShadowOffsetY;

/**
 * @brief 设置阴影的offsetX
 * 默认为0
 * @bug 需要保证 self != nil
 */
- (PYBaseViewHandler *(^)(CGFloat X)) setUpShadowOffsetX;
/**
 * @brief 设置阴影的offset
 * @bug 需要保证 self != nil
 */
- (PYBaseViewHandler *(^)(CGSize offset)) setUpShadowOffset;


/**
 * @brief 设置阴影的透明度
 * 默认值为 0 取值为【0,1】
 * @bug 需要保证 self != nil
 */
- (PYBaseViewHandler *(^)(CGFloat opacity)) setUpShadowOpacity;

/**
 * @brief 设置阴影的颜色
 * @bug 需要保证 self != nil
 */
- (PYBaseViewHandler *(^)(UIColor *color)) setUpShadowColor;

/**
 * @brief 设置阴影圆角
 * @bug 需要保证 self != nil
 */
- (PYBaseViewHandler *(^)(CGFloat radius)) setUpShadowRadius;


@property (nonatomic,assign) NSNumber *layoutConstraintAxisNumber;
@property (nonatomic,assign) NSNumber *layoutPriorityNumber;
@end

NS_ASSUME_NONNULL_END
