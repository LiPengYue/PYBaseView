//
//  BaseSegmentContentView.m
//  PYBaseViews_Example
//
//  Created by 衣二三 on 2019/12/26.
//  Copyright © 2019 LiPengYue. All rights reserved.
//

#import "BaseSegmentContentView.h"
#import "BaseSegmentContentCollectionViewCell.h"

@interface BaseSegmentContentView()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UIScrollViewDelegate
>
@property (nonatomic,strong) NSMutableArray <UIViewController *>*subVcArray;// 暂时不用
@property (nonatomic,strong) NSMutableDictionary <NSString *,NSString *> *registedDic;
@property (nonatomic,assign) NSInteger currentSelectedIndexPrivate;
@property (nonatomic,assign) BOOL isScrollEnable;
@end

@implementation BaseSegmentContentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self baseSetup];
    }
    return self;
}

- (void) baseSetup {
    [self addSubview:self.collectionView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
}


- (void) scrollToIndex:(NSInteger)index andAnimated: (BOOL)animated {
    if ([self.delegate respondsToSelector:@selector(shouldAppearView:andToIndex:)]) {
        BOOL isAppear = [self.delegate shouldAppearView:self andToIndex:index];
        if (!isAppear) {
//            self.isScrollEnable = false;
        }else{
            self.currentSelectedIndexPrivate = index;
            self.isScrollEnable = true;
        }
    }
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:animated];
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
        [self.collectionView registerClass:BaseSegmentContentCollectionViewCell.class forCellWithReuseIdentifier:viewIdenter];
    }
    
    BaseSegmentContentCollectionViewCell *segmentCell =   (BaseSegmentContentCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:viewIdenter forIndexPath:indexPath];
    
    if ([segmentCell isKindOfClass:BaseSegmentContentCollectionViewCell.class]) {
        segmentCell.view = view;
    }
    return segmentCell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(shouldAppearView:andToIndex:)]) {
        BOOL isAppear = [self.delegate shouldAppearView:self andToIndex:indexPath.row];
        if (!isAppear) {
//            self.isScrollEnable = false;
        }else{
            self.currentSelectedIndexPrivate = indexPath.row;
            self.isScrollEnable = true;
        }
    }
}

- (void) collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(didAppearView:andIndex:)]) {
        [self.delegate didAppearView:self andIndex:self.currentSelectedIndexPrivate];
    }
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
    
    if (!self.isScrollEnable && scrollView.tracking) {
        CGFloat x = self.currentSelectedIndexPrivate * self.collectionView.frame.size.width;
        if (self.collectionView.contentOffset.x != x) {
            self.collectionView.contentOffset = CGPointMake(x, 0);
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(collectionViewDidScroll:)]) {
        [self.delegate collectionViewDidScroll:self];
    }
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
        [_collectionView registerClass:BaseSegmentContentCollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(BaseSegmentContentCollectionViewCell.class)];
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

- (void)setCurrentSelectedIndexPrivate:(NSInteger) currentSelectedIndexPrivate {
    if (currentSelectedIndexPrivate == _currentSelectedIndexPrivate) {
        return;
    }
    _lastSelectedIndex = self.currentSelectedIndex;
    _currentSelectedIndexPrivate = currentSelectedIndexPrivate;
    _currentSelectedIndex = currentSelectedIndexPrivate;
}

@end
