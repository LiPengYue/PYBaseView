//
//  PYBaseSegmentHandler.h
//  PYBaseViews_Example
//
//  Created by 衣二三 on 2019/12/25.
//  Copyright © 2019 LiPengYue. All rights reserved.
//

//** 核心思路借鉴 【MFNestTableView】 感谢 **/
//git: https://github.com/lmf12/MFNestTableView


#import <Foundation/Foundation.h>
#import "BaseSegmentContentView.h"
#import "BaseSegmentTagView.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * 管理 多层嵌套scrollView的工具
 * 说明：
 * 1. segmentScrollView: 用于展示（装着左右横滑的collectionView）最外层的scrollView
 * 2. segmentCollectionView: 左右横滑的collectionView
 * 3. contentView: segmentCollectionView的item中装的view
 * 4. contentScrollView: contentView 或者contentView中的scrollView
 */

@interface PYBaseSegmentHandler : NSObject

/**
 * 用于展示（装着左右横滑的collectionView）最外层的scrollView
 */
@property (nonatomic,weak) UIScrollView *segmentScrollView;
@property (nonatomic,weak) BaseSegmentContentView *segmentContentView;
@property (nonatomic,weak) BaseSegmentTagView *tagView;


/**
 * BaseSegmentTagTableHeaderView.y（tabbar 的顶部距离）
 * * 如果segmentScrollView的基类是(BasesegmentScrollView) 则可以用 getHeaderFrameWithSection 求出来
 */
@property (nonatomic,assign) CGFloat topSpacing;

/**
 * contentView所在的这一组 所有的cell的高度的和
 * 如果 segmentScrollView的基类是(BasesegmentScrollView) 则可以用:
 * CGRectGetMaxY([getHeaderFrameWithSection:contentViewSection]) - CGRectGetMinY([getFooterFrameWithSection:contentViewSection])
 */
@property (nonatomic,assign) CGFloat itemsHeight;

/// 是否需要多级个视图响应 手势
/// @warning: 需要在注册BaseSegmentTableFooterView。的 tableview实现
- (BOOL) shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *) gestureRecognizer andOtherRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;


/// 注测 内容视图 的对应关系
/// @param contentView 内容视图
/// @param scrollView 内容视图中的滑动的view
- (void) registerContentWithView:(UIView *)contentView
    andContentInnerScrollView:(UIScrollView *)contentScrollView;

@end

NS_ASSUME_NONNULL_END
