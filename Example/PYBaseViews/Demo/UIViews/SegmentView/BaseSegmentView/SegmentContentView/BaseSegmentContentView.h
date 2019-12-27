//
//  BaseSegmentContentView.h
//  PYBaseViews_Example
//
//  Created by 衣二三 on 2019/12/26.
//  Copyright © 2019 LiPengYue. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol BaseSegmentContentViewDelegate;

@interface BaseSegmentContentView : UIView

@property (nonatomic,strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic,strong) UICollectionView *collectionView;

///
@property (nonatomic,strong) NSMutableArray <UIView *>*subViewArray;

@property (nonatomic,assign,readonly) NSInteger currentSelectedIndex;
@property (nonatomic,assign,readonly) NSInteger lastSelectedIndex;

@property (nonatomic,weak) id <BaseSegmentContentViewDelegate>delegate;

- (void) scrollToIndex:(NSInteger)index andAnimated: (BOOL)animated;
@end

@protocol BaseSegmentContentViewDelegate <NSObject>

/// 是否应该 显示下一页 （在翻页之前调用）
- (BOOL)shouldAppearView:(BaseSegmentContentView *)segmentView
              andToIndex:(NSInteger) toIndex;

/// 已经翻页调用
- (void) didAppearView:(BaseSegmentContentView *)segmentView
            andIndex:(NSInteger) index;

/// 左右滑动
- (void) collectionViewDidScroll: (BaseSegmentContentView *)segmentView;

@end

NS_ASSUME_NONNULL_END
