//
//  BaseSegmentTableFooterView.m
//  PYBaseViews_Example
//
//  Created by 李鹏跃 on 2019/12/24.
//  Copyright © 2019 Lyman Li. All rights reserved.
//

#import "BaseSegmentTableFooterView.h"

@interface BaseSegmentTableFooterView()

@end

@implementation BaseSegmentTableFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self baseSetup];
    }
    return self;
}

- (void) baseSetup {
    [self.contentView addSubview:self.segmentContentView];
}

- (BaseSegmentContentView *)segmentContentView {
    if (!_segmentContentView) {
        _segmentContentView = [BaseSegmentContentView new];
    }
    return _segmentContentView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.segmentContentView.frame = self.contentView.bounds;
}

/// 是否应该 显示下一页 （在翻页之前调用）
- (void)shouldAppearView:(BOOL(^)(BaseSegmentContentView *segmentView,NSInteger toIndex))isAppearBlock {
//    [self.segmentContentView shouldAppearView:isAppearBlock];
}

/// 已经翻页调用
- (void)disappearView: (void(^)(BaseSegmentContentView *segmentView))disappear {
//    [self.segmentContentView disappearView:disappear];
}

- (void) scrollToIndex:(NSInteger)index andAnimated: (BOOL)animated {
    [self.segmentContentView scrollToIndex:index andAnimated:animated];
}

/// 左右滑动
- (void) collectionViewDidScroll: (void(^)(BaseSegmentContentView *segmentView))scroll {
//    [self.segmentContentView collectionViewDidScroll:scroll];
}


// MARK: delegate || dataSource
- (void) setSubViewArray:(NSMutableArray<UIView *> *)subViewArray {
    self.segmentContentView.subViewArray = subViewArray;
}

- (NSInteger)lastSelectedIndex {
    return self.segmentContentView.lastSelectedIndex;
}

- (NSInteger)currentSelectedIndex {
    return self.segmentContentView.currentSelectedIndex;
}

@end
