//
//  BaseSegmentTagTableHeaderView.m
//  PYBaseViews_Example
//
//  Created by 李鹏跃 on 2019/12/24.
//  Copyright © 2019 Lyman Li. All rights reserved.
//

#import "BaseSegmentTagTableHeaderView.h"

#ifdef DEBUG
#    define DLog(...) NSLog(__VA_ARGS__)
#else
#    define DLog(...)
#endif

@interface BaseSegmentTagTableHeaderView()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,copy) BOOL(^selectedIndexBlock)(NSInteger selectedIndex);
@end


@implementation BaseSegmentTagTableHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self baseSetupViews];
    }
    return self;
}

- (void) baseSetupViews {
    [self.contentView addSubview:self.collectionView];
    self.collectionViewCellClass = BaseSegmentTagCollectionViewCell.class;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat x = self.collectionViewEdgeInsets.left;
    CGFloat y = self.collectionViewEdgeInsets.top;
    CGFloat w = self.frame.size.width - self.collectionViewEdgeInsets.right - x;
    CGFloat h = self.frame.size.height - self.collectionViewEdgeInsets.bottom - y;
    self.collectionView.frame = CGRectMake(x, y, w, h);
}

// MARK: - 逻辑相关

- (void)shouldSelectedIndex:(BOOL (^)(NSInteger))block {
    _selectedIndexBlock = block;
}

- (void)scrollToIndex:(NSInteger)index andAnimated:(BOOL)isAnimated {
    if (!self.isRepeatSetIndex) {
        if (self.currentSelectedIndex == index) {
            return;
        }
    }
    
    _lastSelectedIndex = self.currentSelectedIndex;
    _currentSelectedIndex = index;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    if ([self.delegate respondsToSelector:@selector(baseSegmentCustomSelectedIndexAnimationWithCollectionView:andBottomGuidepostView:andCurrentIndexPath:)]) {
        [self.delegate baseSegmentCustomSelectedIndexAnimationWithCollectionView:self.collectionView
                                               andBottomGuidepostView:self.bottomGuidepostView
                                                  andCurrentIndexPath:indexPath];
    }else{
    
        NSIndexPath *lastSelectedIndexPath = [NSIndexPath indexPathForRow:self.lastSelectedIndex inSection:0];
        [self.collectionView reloadItemsAtIndexPaths:@[indexPath,lastSelectedIndexPath]];
//        [self.collectionView reloadData];
        [self.collectionView scrollToItemAtIndexPath:indexPath
                                    atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                            animated:isAnimated];
        
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
            CGFloat x = cell.center.x;
            CGFloat y = self.bottomGuidepostView.center.y;
            self.bottomGuidepostView.center = CGPointMake(x, y);
        } completion:^(BOOL finished) {
        }];
    }
}


// MARK: - delegate && dataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.modelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BaseSegmentTagCollectionViewCell *cell = (BaseSegmentTagCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(self.collectionViewCellClass) forIndexPath:indexPath];
    
    if ([cell isKindOfClass:self.collectionViewCellClass]) {
        if ([cell respondsToSelector:@selector(setupData:)]) {
            [cell setupData: self.modelArray[indexPath.row]];
        }
        cell.styleData = self.cellStyleData;
        cell.isSelected = indexPath.row == self.currentSelectedIndex;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.isRepeatSetIndex) {
        if (self.currentSelectedIndex == indexPath.row) {
            return;// 允许重复点击
        }
    }
    BOOL isChange = true;
    if (self.selectedIndexBlock) {
        isChange = self.selectedIndexBlock(indexPath.row);
    }
    if (isChange) {
        [self scrollToIndex:indexPath.row andAnimated:true];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(baseSegmentGetDataWithRow:andSection:)]) {
        return [self.delegate baseSegmentGetDataWithRow:indexPath.row andSection:indexPath.section].itemSize;
    }else{
        DLog(@"\n 🌶：itemSize 没有值\n");
        return CGSizeMake(CGFLOAT_MIN, CGFLOAT_MIN);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(baseSegmentGetDataWithRow:andSection:)]) {
        return [self.delegate baseSegmentGetDataWithRow:0 andSection:section].insetForSection;
    }else{
        DLog(@"\n 🌶：insetForSection 没有值\n");
        return UIEdgeInsetsMake(CGFLOAT_MIN, CGFLOAT_MIN, CGFLOAT_MIN, CGFLOAT_MIN);
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(baseSegmentGetDataWithRow:andSection:)]) {
        return [self.delegate baseSegmentGetDataWithRow:0 andSection:section].minimumSpacingForSection;
    }else{
        DLog(@"\n 🌶：minimumSpacingForSection 没有值\n");
        return CGFLOAT_MIN;
    }
}


// MARK: - get || set
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.whiteColor;
    }
    return _collectionView;
}

- (void)setCollectionViewDataSource:(id<UICollectionViewDataSource>)collectionViewDataSource {
    _collectionViewDataSource = collectionViewDataSource;
    self.collectionView.dataSource = collectionViewDataSource;
}

- (void)setCollectionViewDelegate:(id<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>)collectionViewDelegate {
    _collectionViewDelegate = collectionViewDelegate;
    self.collectionView.delegate = collectionViewDelegate;
    
}

- (UIView *)bottomGuidepostView {
    if (!_bottomGuidepostView) {
        _bottomGuidepostView = [UIView new];
        _bottomGuidepostView.backgroundColor = [UIColor colorWithRed:255/255.0 green:84/255.0 blue:75/255.0 alpha:1.0];
        _bottomGuidepostView.layer.cornerRadius = 1.5;
        _bottomGuidepostView.bounds = CGRectMake(0, 0, 3, 3);
    }
    return _bottomGuidepostView;
}

- (BaseSegmentTagCollectionViewCellStyleModel *)cellStyleData {
    if (!_cellStyleData) {
        _cellStyleData = [[BaseSegmentTagCollectionViewCellStyleModel alloc]init];
    }
    return _cellStyleData;
}

- (void) setCollectionViewCellClass:(Class)collectionViewCellClass {
    _collectionViewCellClass = collectionViewCellClass;
    [self.collectionView registerClass:collectionViewCellClass forCellWithReuseIdentifier:NSStringFromClass(collectionViewCellClass)];
}

- (void)setCollectionViewEdgeInsets:(UIEdgeInsets)collectionViewEdgeInsets {
    _collectionViewEdgeInsets = collectionViewEdgeInsets;
    [self layoutSubviews];
}

- (void)setModelArray:(NSArray<id> *)modelArray {
    _modelArray = modelArray;
    [self.collectionView reloadData];
}

@end
