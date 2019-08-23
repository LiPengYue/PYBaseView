//
//  BasetableTestHeserFooterView1.m
//  Test
//
//  Created by 衣二三 on 2019/4/16.
//  Copyright © 2019 衣二三. All rights reserved.
//

#import "BasetableTestHeserFooterView1.h"


@implementation BasetableTestHeserFooterView1

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self setupviews];
    }
    return self;
}

- (void) setupviews {
    [self.contentView addSubview: self.titleLabel];
}

- (void) layoutSubviews {
    [super layoutSubviews];
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    self.titleLabel.frame = CGRectMake(14, 0, w, h);
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
         _titleLabel.textColor = UIColor.grayColor;
    }
    return _titleLabel;
}

@end

