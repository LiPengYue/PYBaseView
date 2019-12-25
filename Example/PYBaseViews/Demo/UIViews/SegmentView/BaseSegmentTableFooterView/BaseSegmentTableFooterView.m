//
//  BaseSegmentTableFooterView.m
//  PYBaseViews_Example
//
//  Created by 李鹏跃 on 2019/12/24.
//  Copyright © 2019 Lyman Li. All rights reserved.
//

#import "BaseSegmentTableFooterView.h"
#import "BaseSegmentVcCollectionViewCell.h"

@interface BaseSegmentTableFooterView()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UIScrollViewDelegate
>
@property (nonatomic,strong) NSMutableArray <UIViewController *>*subVcArray;// 暂时不用
@property (nonatomic,strong) NSMutableDictionary <NSString *,NSString *> *registedDic;
@property (nonatomic,copy) void(^disappearBlock)(BaseSegmentTableFooterView *segmentView);
@property (nonatomic,copy) BOOL(^isAppearBlock)(BaseSegmentTableFooterView *segmentView,NSInteger toIndex);
@property (nonatomic,copy) void(^scrollViewDidScrollBlock)(BaseSegmentTableFooterView *segmentView);
@end

@implementation BaseSegmentTableFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self baseSetup];
    }
    return self;
}

- (void) baseSetup {
    [self.contentView addSubview:self.collectionView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = self.contentView.bounds;
}

/// 是否应该 显示下一页 （在翻页之前调用）
- (void)shouldAppearView:(BOOL(^)(BaseSegmentTableFooterView *segmentView,NSInteger toIndex))isAppearBlock {
    _isAppearBlock = isAppearBlock;
}

/// 已经翻页调用
- (void)disappearView: (void(^)(BaseSegmentTableFooterView *segmentView))disappear {
    _disappearBlock = disappear;
}

- (void) scrollToIndex:(NSInteger)index andAnimated: (BOOL)animated {
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:animated];
}

/// 左右滑动
- (void) collectionViewDidScroll: (void(^)(BaseSegmentTableFooterView *segmentView))scroll {
    _scrollViewDidScrollBlock = scroll;
}


// MARK: delegate || dataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.subViewArray.count;
}

- (NSString *) getIdenterWithIndex: (NSIndexPath *)index AndView: (UIView *)view {
    if (view) {
        return [NSString stringWithFormat:@"%@,%@",index,view];
    }
    return @"ERRORID";
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UIView *view = self.subViewArray[indexPath.row];
    NSString *viewIdenter = [self getIdenterWithIndex:indexPath AndView:view];
    
    if (!self.registedDic[viewIdenter]) {
        [self.collectionView registerClass:BaseSegmentVcCollectionViewCell.class forCellWithReuseIdentifier:viewIdenter];
    }
    
    BaseSegmentVcCollectionViewCell *segmentCell =   (BaseSegmentVcCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:viewIdenter forIndexPath:indexPath];
    
    if ([segmentCell isKindOfClass:BaseSegmentVcCollectionViewCell.class]) {
        segmentCell.view = view;
    }
    return segmentCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.flowLayout) {
          return self.flowLayout.itemSize;
      }
    return self.bounds.size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (self.flowLayout) {
        return self.flowLayout.sectionInset;
    }
    return UIEdgeInsetsMake(CGFLOAT_MIN, CGFLOAT_MIN, CGFLOAT_MIN, CGFLOAT_MIN);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (self.flowLayout) {
          return self.flowLayout.minimumLineSpacing;
      }
      return CGFLOAT_MIN;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (![scrollView isEqual:self.collectionView]) {
        return;
    }
    
    if (self.scrollViewDidScrollBlock) {
        self.scrollViewDidScrollBlock(self);
    }
    
    //当前滑动的进度
    CGFloat indexFloat = scrollView.contentOffset.x / MAX(self.collectionView.contentSize.width, 1);
    NSInteger frontIndex = self.currentSelectedIndex;
    NSInteger bottomViewCount = self.subViewArray.count;
    
    if (self.isAppearBlock) {
        NSInteger wellIndex = indexFloat > frontIndex ? 1 : -1;
        wellIndex += frontIndex;

        if (wellIndex < 0 || wellIndex >= bottomViewCount) {
            return;
        }
        
        BOOL isAppear = self.isAppearBlock(self,wellIndex);
        if (!isAppear) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:wellIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:false];
            return;
        }
    }

    self.currentSelectedIndex = round(indexFloat);
}

// MARK: - get || set

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        [_collectionView registerClass:BaseSegmentVcCollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(BaseSegmentVcCollectionViewCell.class)];
    }
    return _collectionView;
}

- (NSMutableDictionary<NSString *,NSString *> *)registedDic {
    if (!_registedDic) {
        _registedDic = [NSMutableDictionary new];
    }
    return _registedDic;
}

- (void)setSubVcArray:(NSMutableArray<UIViewController *> *)subVcArray {
    if ([_subVcArray isEqualToArray:subVcArray]) {
        return;
    }
    _subVcArray = subVcArray;
    [self.collectionView reloadData];
}

- (void) setSubViewArray:(NSMutableArray<UIView *> *)subViewArray {
    if (![subViewArray isEqualToArray:_subViewArray]) {
        _subViewArray = subViewArray.mutableCopy;
    }
    [self.collectionView reloadData];
}

- (void)setCurrentSelectedIndex:(NSInteger)currentSelectedIndex {
    if (currentSelectedIndex == _currentSelectedIndex) {
        return;
    }
    _lastSelectedIndex = self.currentSelectedIndex;
    _currentSelectedIndex = currentSelectedIndex;
    
}

@end
