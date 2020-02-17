//
//  PYBaseSegmentCollectionView.h
//  PYBaseViews_Example
//
//  Created by 衣二三 on 2019/12/26.
//  Copyright © 2019 LiPengYue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYBaseSegmentHandler.h"

NS_ASSUME_NONNULL_BEGIN

@interface PYBaseSegmentCollectionView : UICollectionView

/**
 * 固定的距离
 */
@property (nonatomic,assign) CGFloat topSpacing;

/**
 * contentView所在的这一组 所有的cell的高度的和
 */
@property (nonatomic,assign) CGFloat itemsHeight;


/// 注测 内容视图 的对应关系
/// @param contentView 内容视图
/// @param scrollView 内容视图中的滑动的view
- (void) registerContentWithView:(UIView *)contentView
    andContentInnerScrollView:(UIScrollView *)scrollView;

@end

NS_ASSUME_NONNULL_END
