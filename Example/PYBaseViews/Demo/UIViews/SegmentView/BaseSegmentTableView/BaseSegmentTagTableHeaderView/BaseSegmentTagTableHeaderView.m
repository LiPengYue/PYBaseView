//
//  BaseSegmentTagTableHeaderView.m
//  PYBaseViews_Example
//
//  Created by 李鹏跃 on 2019/12/24.
//  Copyright © 2019 Lyman Li. All rights reserved.
//

#import "BaseSegmentTagTableHeaderView.h"



@interface BaseSegmentTagTableHeaderView()

@end


@implementation BaseSegmentTagTableHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self baseSetupViews];
    }
    return self;
}

- (void) baseSetupViews {
    [self.contentView addSubview:self.tagView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat x = self.tagViewEdgeInsets.left;
    CGFloat y = self.tagViewEdgeInsets.top;
    CGFloat w = self.frame.size.width - self.tagViewEdgeInsets.right - x;
    CGFloat h = self.frame.size.height - self.tagViewEdgeInsets.bottom - y;
    self.tagView.frame = CGRectMake(x, y, w, h);
}

- (BaseSegmentTagView *)tagView {
    if (!_tagView) {
        _tagView = [BaseSegmentTagView new];
    }
    return _tagView;
}

- (void)setTagViewEdgeInsets:(UIEdgeInsets)tagViewEdgeInsets{
    _tagViewEdgeInsets = tagViewEdgeInsets;
    [self layoutSubviews];
}

- (void)setDelegate:(id<BaseSegmentTagViewDelegate>)delegate {
    _delegate = delegate;
    self.tagView.delegate = delegate;
}

- (void)setModelArray:(NSArray<id> *)modelArray {
    _modelArray = modelArray;
    self.tagView.modelArray = modelArray;
}

- (void)setIsRepeatSetIndex:(BOOL)isRepeatSetIndex {
    _isRepeatSetIndex = isRepeatSetIndex;
    self.tagView.isRepeatSetIndex = isRepeatSetIndex;
}

- (NSInteger)currentSelectedIndex {
    return self.tagView.currentSelectedIndex;
}

- (NSInteger)lastSelectedIndex {
    return self.tagView.lastSelectedIndex;
}

- (void) scrollToIndex:(NSInteger) index andAnimated:(BOOL)isAnimated {
    [self.tagView scrollToIndex:index andAnimated:isAnimated];
}

- (void) shouldSelectedIndex: (BOOL(^)(NSInteger selectedIndex))block {
//    [self.tagView shouldSelectedIndex:block];
}

@end
