//
//  BasePointProgressViewProtocol.h
//  BaseProgress
//
//  Created by 衣二三 on 2019/4/9.
//  Copyright © 2019年 衣二三. All rights reserved.
//

#import <UIKit/UIKit.h>
/// 让节点高亮的策略
typedef enum : NSUInteger {
    /// 到达 节点中心才算高亮
    PYBasePointProgressSelectedCenter,
    /// 到达 节点边缘
    PYBasePointProgressSelectedEdge,
} PYEBasePointProgressSelectedType;

typedef PYEBasePointProgressSelectedType PYEBasePointProgressSelectedType;
struct PYBasePointProgressLineData {
    UIColor *lineColor;
    /// 线的center y 值
    CGFloat lineScaleY;
    CGFloat lineHeight;
    /// 连续绘制几个单位长度
    CGFloat drowLength;
    /// 连续空白几个单位长度
    CGFloat marginLength;
    /// 线的层级 是否在pointView之上
    BOOL isMovePointViewTop;
};
typedef struct PYBasePointProgressLineData PYBasePointProgressLineData;

//// 创建高亮状态下的默认显示
NS_INLINE PYBasePointProgressLineData PYBasePointProgressLineDataMakeHighlightDefult() {
    PYBasePointProgressLineData defult;
//    defult.lineLeftSpacing = 0;
//    defult.lineRightSpacing = 0;
    defult.lineScaleY = 0.5;
    defult.lineHeight = 2;
    defult.lineColor = [UIColor colorWithRed:0.956862745 green:0.470588235 blue:0.447058824 alpha:1];
    defult.marginLength = 0;
    return defult;
}


/// 创建 默认情况下的默认值
NS_INLINE PYBasePointProgressLineData PYBasePointProgressLineDataMakeNormalDefult() {
    PYBasePointProgressLineData defult;
    defult.lineScaleY = 0.5;
    defult.lineHeight = 1;
//    defult.lineLeftSpacing = 0;
//    defult.lineRightSpacing = 0;
    CGFloat colorValue = 175.0 / 255.0;
    defult.lineColor = [UIColor colorWithRed:colorValue green:colorValue blue:colorValue alpha:1];
    defult.marginLength = 0;
    return defult;
}


@class PYBasePointProgressView,PYBasePointProgressContentView;
@protocol PYBasePointProgressProtocol <NSObject>



/// 创建 节点的view
- (NSArray <PYBasePointProgressContentView *> *) createPointContentViewWithProgressView: (PYBasePointProgressView *)progressView;


/**
 将要显示的时候调用 可以在这里设置pointView

 @param pointView pointView
 @param isSelected 是否应该高亮显示
 @param index pointView的位置
 */
- (void) willDisplayPointView: (PYBasePointProgressContentView *) pointView
                  andIsSected: (BOOL) isSelected
                     andIndexPath: (NSInteger)index;


/**
 /// 动画结束后
 */

- (void) animationDidStopWithProgressView: (PYBasePointProgressView *)progressView
                    andSelectedPointViews: (NSArray <PYBasePointProgressContentView *>*) selectedPointViews
                      andNormalPointViews: (NSArray <PYBasePointProgressContentView *>*)normalPointViews;

/// 托转currentProgressView的时候回调
- (void) panChangedWithProgressView: (PYBasePointProgressView *)progressView
              andSelectedPointViews: (NSArray <PYBasePointProgressContentView *>*) selectedPointViews
                andNormalPointViews: (NSArray <PYBasePointProgressContentView *>*)normalPointViews;
@end


@interface PYBasePointProgressViewProtocol : NSObject

@end

