//
//  BaseSegmentTagView.h
//  PYBaseViews_Example
//
//  Created by 衣二三 on 2019/12/26.
//  Copyright © 2019 LiPengYue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSegmentTagCollectionViewCell.h"
NS_ASSUME_NONNULL_BEGIN


@protocol BaseSegmentTagViewDelegate;
typedef struct SBaseSegmentTagViewData SBaseSegmentTagViewData;

@interface BaseSegmentTagView : UIView

@property (nonatomic,strong) BaseSegmentTagCollectionViewCellStyleModel *cellStyleData;
@property (nonatomic,weak) id<BaseSegmentTagViewDelegate>delegate;
/// modelArray 直接传递到 cell 中
@property (nonatomic,strong) NSArray <id> *modelArray;

/// 底部的当前选中view
@property (nonatomic,strong) UIView *bottomGuidepostView;
@property (nonatomic,assign) UIEdgeInsets collectionViewEdgeInsets;

/// 是否可以重复点击 默认为 NO
@property (nonatomic,assign) BOOL isRepeatSetIndex;

/// 需要通过 scrollToIndex: 设置
@property (nonatomic,assign,readonly) NSInteger currentSelectedIndex;
@property (nonatomic,assign,readonly) NSInteger lastSelectedIndex;

@property (nonatomic,strong) UICollectionView *collectionView;

- (void) scrollToIndex:(NSInteger) index
           andAnimated:(BOOL)isAnimated;


#pragma mark - 自定义 相关
///自定义的cell类型
/// 默认是 BaseSegmentTagCollectionViewCell.class 不支持 XIB
@property (nonatomic,strong) Class <BaseSegmentTagCollectionViewCellDelegate> collectionViewCellClass;

/// 自定义 collectionView 的 delegate
@property (nonatomic,weak) id <UICollectionViewDelegate,UICollectionViewDelegateFlowLayout> collectionViewDelegate;
@property (nonatomic,weak) id <UICollectionViewDataSource> collectionViewDataSource;

@end


@protocol BaseSegmentTagViewDelegate <NSObject>

@required
- (CGSize)baseSegmentTagView:(BaseSegmentTagView *)tagView
      sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

/// 是否应该 选中点击到index 如果返回是 则 调用·scrollToIndex：·
- (BOOL) baseSegmentTagView:(BaseSegmentTagView *)tagView
        shouldSelectedIndex: (NSInteger)selectedIndex;


@optional
- (void) baseSegmentTagView:(BaseSegmentTagView *)tagView
             customAnimated:(UICollectionView *)collectionView
     andBottomGuidepostView: (UIView *)bottomGuidepostView
        andCurrentIndexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
