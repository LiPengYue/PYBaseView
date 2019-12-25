//
//  BaseSegmentTableFooterView.h
//  PYBaseViews_Example
//
//  Created by 李鹏跃 on 2019/12/24.
//  Copyright © 2019 Lyman Li. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 注意 如果这一组有多余的cell，那么需要给 PYBaseSegmentHandler.itemsHeight赋值
@interface BaseSegmentTableFooterView : UITableViewHeaderFooterView

@property (nonatomic,strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic,strong) UICollectionView *collectionView;

///

@property (nonatomic,strong) NSMutableArray <UIView *>*subViewArray;

@property (nonatomic,assign) NSInteger currentSelectedIndex;
@property (nonatomic,assign) NSInteger lastSelectedIndex;

/// 是否应该 显示下一页 （在翻页之前调用）
- (void)shouldAppearView:(BOOL(^)(BaseSegmentTableFooterView *segmentView,NSInteger toIndex))isAppearBlock;

/// 已经翻页调用
- (void)disappearView: (void(^)(BaseSegmentTableFooterView *segmentView))disappear;

- (void) scrollToIndex:(NSInteger)index andAnimated: (BOOL)animated;

/// 左右滑动
- (void) collectionViewDidScroll: (void(^)(BaseSegmentTableFooterView *segmentView))scroll;
@end

NS_ASSUME_NONNULL_END
