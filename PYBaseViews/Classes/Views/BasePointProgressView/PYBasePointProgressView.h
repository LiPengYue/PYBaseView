//
//  BasePointProgress.h
//  yiapp
//
//  Created by 衣二三 on 2019/4/8.
//  Copyright © 2019年 yi23. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYBasePointProgressViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN
#pragma mark - 有点进度条
@interface PYBasePointProgressView : UIView
/// 已经高亮的节点view数组 数组
@property (nonatomic,strong,readonly) NSArray <PYBasePointProgressContentView *> *selectedPointArray;

/// 所有的节点view数组
@property (nonatomic,strong,readonly) NSArray <PYBasePointProgressContentView *>* allPointViewArray;

/// 节点view的y值占self的比例
@property (nonatomic,assign) CGFloat  pointViewScaleCenterY;

/// 当前的进度 赋值后 更新进度并 产生动画
@property (nonatomic,assign) CGFloat currentProgress;

/// 设置 当前进度
- (void) setCurrentProgress:(CGFloat)currentProgress andAnimation: (BOOL) isAnimation;

/// 设置当前进度 根据真实的宽度
- (void) setCurrentProgressWithWidth: (CGFloat) width andAnimation: (BOOL) animation;


/**
 /// 当前的进度 赋值后 更新进度并 产生动画
 @param view 进度到view的中心
 @param offsetX 中心偏移多少px
 */
- (void) reloadProgressToViewCenter: (PYBasePointProgressContentView *) view andOffset: (CGFloat) offsetX;

/// 前面的进度条 的样式
@property (nonatomic,assign) PYBasePointProgressLineData frontLineStyle;

/// 背景进度条 的样式
@property (nonatomic,assign) PYBasePointProgressLineData normalLineStyle;

/// 进度动画代理
@property (nonatomic,weak) id <PYBasePointProgressProtocol> frontLineAnimationDelegate;

/// 进度条动画时长
@property (nonatomic,assign) CGFloat animationDuration;

/// 背景进度条动画时长
@property (nonatomic,assign) CGFloat bgAnimationDuration;

@property (nonatomic,strong) PYBasePointProgressContentView *currentProgressView;

/// 默认的节点view的大小
@property (nonatomic,assign) CGSize pointViewSize;

/// 节点选中的策略
@property (nonatomic,assign) PYEBasePointProgressSelectedType selectedType;

/**
 节点view高亮的标准。 到达center.x + selectedCenterOffsetX 高亮
 */
@property (nonatomic,assign) CGFloat selectedCenterOffsetX;

/// 重新布局
- (void) relayoutViews;

/**
 获取 allPointViewArray 点亮 pointView range
 @param maxCount 最多有多少个pointView
 @return 点亮的range
 */
- (NSRange) getPointViewSelectedMaxCount: (NSInteger) maxCount;

@end


@interface PYBasePointProgressContentView : UIView
@property (nonatomic,strong) UIButton *button;
@end

NS_ASSUME_NONNULL_END
