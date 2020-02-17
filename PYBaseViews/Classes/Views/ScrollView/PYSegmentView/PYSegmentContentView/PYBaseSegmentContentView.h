//
//  PYBaseSegmentContentView.h
//  PYBaseViews_Example
//
//  Created by 衣二三 on 2019/12/26.
//  Copyright © 2019 LiPengYue. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol PYBaseSegmentContentViewDelegate;

@interface PYBaseSegmentContentView : UIView

@property (nonatomic,strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic,strong) UICollectionView *collectionView;

///
@property (nonatomic,strong) NSMutableArray <UIView *>*subViewArray;

@property (nonatomic,assign,readonly) NSInteger currentSelectedIndex;
@property (nonatomic,assign,readonly) NSInteger lastSelectedIndex;

@property (nonatomic,weak) id <PYBaseSegmentContentViewDelegate>delegate;

- (void) scrollToIndex:(NSInteger)index andAnimated: (BOOL)animated;
@end

@protocol PYBaseSegmentContentViewDelegate <NSObject>

/// 是否应该 显示下一页 （在翻页之前调用）
- (void)willDisplayView:(PYBaseSegmentContentView *)segmentView
                forItemAtIndex:(NSInteger)index;

/// 已经翻页调用
- (void) didEndDisplayingView:(PYBaseSegmentContentView *)segmentView
               forItemAtIndex:(NSInteger) index;

/// 左右滑动
- (void) collectionViewDidScroll: (PYBaseSegmentContentView *)segmentView;

@end

NS_ASSUME_NONNULL_END
