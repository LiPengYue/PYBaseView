//
//  BaseSegmentTagTableHeaderView.h
//  MFNestTableViewDemo
//
//  Created by 衣二三 on 2019/12/24.
//  Copyright © 2019 Lyman Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSegmentTagCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN
@protocol BaseSegmentTagTableHeaderViewDelegate;
typedef struct SBaseSegmentTagTableHeaderViewData SBaseSegmentTagTableHeaderViewData;

@interface BaseSegmentTagTableHeaderView : UITableViewHeaderFooterView

@property (nonatomic,weak) id<BaseSegmentTagTableHeaderViewDelegate>delegate;
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

- (void) scrollToIndex:(NSInteger) index andAnimated:(BOOL)isAnimated;

/// 是否应该 选中点击到index 如果返回是 则 调用·scrollToIndex：·
- (void) shouldSelectedIndex: (BOOL(^)(NSInteger selectedIndex))block;



#pragma mark - 自定义 相关
/// 自定义的cell 默认是 BaseSegmentTagCollectionViewCell.class 不支持 XIB
@property (nonatomic,strong) Class <BaseSegmentTagCollectionViewCellDelegate> collectionViewCellClass;

@property (nonatomic,assign) SBaseSegmentTagCollectionViewCellData cellStyleData;

//MARK: 自定义 collectionView 的 delegate || dataSource || layoutDelegate
@property (nonatomic,weak) id <UICollectionViewDelegate,UICollectionViewDelegateFlowLayout> collectionViewDelegate;
@property (nonatomic,weak) id <UICollectionViewDataSource> collectionViewDataSource;
@end

struct SBaseSegmentTagTableHeaderViewData {
    CGSize itemSize;
    UIEdgeInsets insetForSection;
    CGFloat minimumSpacingForSection;
};

@protocol BaseSegmentTagTableHeaderViewDelegate <NSObject>
- (SBaseSegmentTagTableHeaderViewData) getDataWithRow: (NSInteger)row
andSection: (NSInteger)section;

- (void) customSelectedIndexAnimationWithCollectionView:(UICollectionView *)collectionView
                                 andBottomGuidepostView: (UIView *)bottomGuidepostView
                                    andCurrentIndexPath:(NSIndexPath *)indexPath;
@end
NS_ASSUME_NONNULL_END
