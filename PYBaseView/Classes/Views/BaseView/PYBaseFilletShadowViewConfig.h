//
//  PYBaseFilletShadowViewConfig.h
//  PYKit
//
//  Created by 李鹏跃 on 2018/9/11.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^PYBaseFilletShadowViewConfigPropertyChangedBlock)(BOOL isShapeChanged, BOOL isShadowChanged);
@interface PYBaseFilletShadowViewConfig : NSObject

/**圆形的半径*/
@property (nonatomic,assign) CGFloat radius;
- (PYBaseFilletShadowViewConfig *(^)(CGFloat radius)) setUpRadius;

/**四个角的半径控制接口*/
@property (nonatomic,assign) CGFloat leftTopAddRadius;
- (PYBaseFilletShadowViewConfig *(^)(CGFloat leftTopAddRadius)) setUpLeftTopAddRadius;

@property (nonatomic,assign) CGFloat leftBottomAddRadius;
- (PYBaseFilletShadowViewConfig *(^)(CGFloat leftBottomAddRadius)) setUpLeftBottomAddRadius;

@property (nonatomic,assign) CGFloat rightTopAddRadius;
- (PYBaseFilletShadowViewConfig *(^)(CGFloat rightTopAddRadius)) setUpRightTopAddRadius;

@property (nonatomic,assign) CGFloat rightBottomAddRadius;
- (PYBaseFilletShadowViewConfig *(^)(CGFloat rightBottomAddRadius)) setUpRightBottonAddRadius;


// MARK: - shadow
/// 阴影的透明度
@property (nonatomic,assign) CGFloat shadowAlpha;
- (PYBaseFilletShadowViewConfig *(^)(CGFloat alpha)) setUpShadowAlpha;

/// 设置阴影的offset
@property (nonatomic,assign) CGSize shadowOffset;
- (PYBaseFilletShadowViewConfig *(^)(CGSize offset)) setUpShadowOffset;

/// 设置阴影的color
@property (nonatomic,strong) UIColor *shadowColor;
- (PYBaseFilletShadowViewConfig *(^)(UIColor *color)) setUpShadowColor;

/// 设置阴影的渐变圆角
@property (nonatomic,assign) CGFloat shadowRadius;
- (PYBaseFilletShadowViewConfig *(^)(CGFloat radius)) setUpShadowRadius;

@end
NS_ASSUME_NONNULL_END
