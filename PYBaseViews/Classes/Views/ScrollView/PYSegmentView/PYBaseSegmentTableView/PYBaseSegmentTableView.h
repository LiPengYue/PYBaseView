//
//  PYBaseSegmentTableView.h
//  PYBaseViews_Example
//
//  Created by 李鹏跃 on 2019/12/24.
//  Copyright © 2019 Lyman Li. All rights reserved.
//

//** 核心思路借鉴 【MFNestTableView】 感谢 **/
//git: https://github.com/lmf12/MFNestTableView

#import "PYBaseTableView.h"

NS_ASSUME_NONNULL_BEGIN

/// 多级嵌套 scrollView 视图 
@interface PYBaseSegmentTableView :PYBaseTableView

/**
 * 固定的距离， 就是 PYBaseSegmentTagTableHeaderView.y
 * 可以用 getHeaderFrameWithSection 求出来
 */
@property (nonatomic,assign) CGFloat topSpacing;

/**
 * contentView所在的这一组 所有的cell的高度的和
 * 如果 segmentTableView的基类是(PYBaseSegmentTableView) 则可以用:
 * CGRectGetMaxY([getHeaderFrameWithSection:contentViewSection]) - CGRectGetMinY([getFooterFrameWithSection:contentViewSection])
 */
@property (nonatomic,assign) CGFloat itemsHeight;


/// 注测 内容视图 的对应关系
/// @param contentView 内容视图
/// @param scrollView 内容视图中的滑动的view
- (void) registerContentWithView:(UIView *)contentView
    andContentInnerScrollView:(UIScrollView *)scrollView;

@end

NS_ASSUME_NONNULL_END
