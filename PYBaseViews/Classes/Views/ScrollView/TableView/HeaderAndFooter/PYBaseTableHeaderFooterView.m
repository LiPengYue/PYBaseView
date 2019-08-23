//
//  BaseTableHeaderFooterView.m
//  Test
//
//  Created by 衣二三 on 2019/4/16.
//  Copyright © 2019 衣二三. All rights reserved.
//

#import "PYBaseTableHeaderFooterView.h"

@implementation PYBaseTableHeaderFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self baseTableHeaderFooterViewSetUpSubViews];
    }
    return self;
}

- (void) baseTableHeaderFooterViewSetUpSubViews {
    [self.contentView addSubview:self.containerView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.containerView.frame = self.contentView.bounds;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [UIView new];
        _containerView.backgroundColor = UIColor.whiteColor;
    }
    return _containerView;
}
@end
