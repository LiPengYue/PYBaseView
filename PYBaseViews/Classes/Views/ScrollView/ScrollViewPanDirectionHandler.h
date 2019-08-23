//
//  ScrollViewPanDirectionHandler.h
//  PYKit
//
//  Created by 李鹏跃 on 2018/9/11.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^PanDirectionHandlerCallBack)(void);
@interface ScrollViewPanDirectionHandler : NSObject
/// 向上拉
@property (nonatomic,copy) PanDirectionHandlerCallBack up;
/// 向下拉
@property (nonatomic,copy) PanDirectionHandlerCallBack down;
/// 向左拉
@property (nonatomic,copy) PanDirectionHandlerCallBack left;
/// 向右拉
@property (nonatomic,copy) PanDirectionHandlerCallBack right;
/**
 * self.scrollView 滚动时候调用
 */
- (void) scrollViewDidScrollCallBack: (void(^)(CGPoint lodOffset, CGPoint newOffset)) block;

/**
 * 横向 变化多少，才会调用 left/right 属性 默认为10
 */
@property (nonatomic,assign) CGFloat horizontalOffset;
/**
 * 纵向 变化多少，才会调用 up/down 属性 默认为10
 */
@property (nonatomic,assign) CGFloat verticalOffset;
/**
 * 需要监听滚动的scrollView
 */
@property (nonatomic,strong) UIScrollView *scrollView;

@end

NS_ASSUME_NONNULL_END
