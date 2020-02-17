//
//  PYSegmentTagsCollectionViewCell.m
//  PYBaseViews_Example
//
//  Created by 衣二三 on 2019/12/26.
//  Copyright © 2019 LiPengYue. All rights reserved.
//

#import "PYSegmentTagsCollectionViewCell.h"
/// PYBaseSegmentContentView *segmentContentView
@interface PYSegmentTagsCollectionViewCell()
<
BaseSegmentTagViewDelegate
>

@end

@implementation PYSegmentTagsCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self baseSetupViews];
    }
    return self;
}

- (void) baseSetupViews {
    [self.contentView addSubview:self.tagView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.tagView.frame = self.bounds;
}

- (BaseSegmentTagView *)tagView {
    if (!_tagView) {
        _tagView = [BaseSegmentTagView new];
    }
    return _tagView;
}
@end
