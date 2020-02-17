//
//  PYSegmentContentViewCollectionViewCell.m
//  PYBaseViews_Example
//
//  Created by 衣二三 on 2019/12/26.
//  Copyright © 2019 LiPengYue. All rights reserved.
//

#import "PYSegmentContentViewCollectionViewCell.h"
@interface PYSegmentContentViewCollectionViewCell()

@end

@implementation PYSegmentContentViewCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self baseSetup];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.segmentContentView.frame = self.contentView.bounds;
}

- (void) baseSetup {
    self.segmentContentView = [[PYBaseSegmentContentView alloc]initWithFrame:CGRectZero];
    [self.contentView addSubview:self.segmentContentView];
}

@end
