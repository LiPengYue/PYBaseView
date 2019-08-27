//
//  BaseView.h
//  PYKit
//
//  Created by 李鹏跃 on 2018/9/11.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYBaseViewController.h"
#import "PYViewShadowConfigration.h"
#import "PYBaseFilletShadowViewConfig.h"
#import "PYBaseViewHandler.h"
#import "PYBaseGradientView.h"
#import "PYBasePointProgressView.h"
#import "PYBaseViewHandler.h"
#import "PYBaseButton.h"
#import "PYBaseLabel.h"
#import "PYTableMainView.h"
#import "ScrollViewPanDirectionHandler.h"
#import "PYBaseSize.h"


NS_ASSUME_NONNULL_BEGIN

@interface PYBaseView : UIView

/// backgroundColor
@property (nonatomic,strong) UIColor *bgColor;
/// 是否接收点击事件 优先级 低于 revoertPointInside
@property (nonatomic,assign) BOOL isTranslucent;

/// 是否穿透事件
- (void)revoertPointInside: (BOOL(^)(CGPoint point, UIEvent *event))block;
/// weak
- (void) setUpWeakSelf: (void(^)(UIView *weak))block;


#pragma mark - handler
- (void) setupBaseViewHandler: (void(^)(PYBaseViewHandler *handler))block;


#pragma mark - 裁切与阴影
@property (nonatomic,strong) PYBaseFilletShadowViewConfig *config;
/**reCut裁切的位置及范围*/
@property (nonatomic,assign) CGRect cutRect;
/// 是否显示阴影 默认为true
@property (nonatomic,assign) BOOL isDrawShadow;
/** 设置阴影必须要设置这个layer 不用自己创建 但必须保证其在底层 */
@property (nonatomic,strong) CALayer *shadowLayer;
/** 在这个上边布局 */
@property (nonatomic,strong) UIView *containerView;
/** containerView距离 self 的边距 */
@property (nonatomic,assign) UIEdgeInsets containerViewEdge;

/** 开始切图 */
- (void) cut;
/** 取消切图 */
- (void) unCunt;
/** 裁切 */
- (void) reCutWithRect:(CGRect) rect;
/// r重新裁剪，区域优先采用cutRect，如果cutRect为CGRectZero 则采用self.bounds
- (void) recut;
/// 阴影动画
- (void) beginShadowAnimation:(void(^)(PYViewShadowConfigration *config)) block;
@property (nonatomic,strong) PYViewShadowConfigration *shadowConfig;
@end

NS_ASSUME_NONNULL_END
