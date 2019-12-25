//
//  BaseSegmentVcCollectionViewCell.m
//  PYBaseViews_Example
//
//  Created by 李鹏跃 on 2019/12/24.
//  Copyright © 2019 LiPengYue. All rights reserved.
//

#import "BaseSegmentVcCollectionViewCell.h"
@interface BaseSegmentVcCollectionViewCell()
@property (nonatomic,weak) UIView *lastView;
@end
@implementation BaseSegmentVcCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.view.frame = self.contentView.bounds;
    if (![self.lastView isEqual:self.view]) {
        [self.lastView removeFromSuperview];
    }
}

- (void)setView:(UIView *)view {
    [self.contentView addSubview: view];
    if (![view isEqual:self.view]) {
        _lastView = self.view;
    }
    _view = view;
    view.frame = self.contentView.bounds;
    [self layoutSubviews];
}

@end
