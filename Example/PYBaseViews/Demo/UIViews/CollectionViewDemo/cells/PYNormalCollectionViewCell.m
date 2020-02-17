//
//  PYNormalCollectionViewCell.m
//  PYBaseViews_Example
//
//  Created by 李鹏跃 on 2020/2/7.
//  Copyright © 2020 LiPengYue. All rights reserved.
//

#import "PYNormalCollectionViewCell.h"
#import <PYBaseView.h>
@implementation PYNormalCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textLabel = [UILabel new];
        [self.contentView addSubview:self.textLabel];
        self.textLabel.textColor = [self random];
        self.textLabel.font = [UIFont systemFontOfSize:12];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (UIColor *)random {
    return [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textLabel.frame = self.contentView.bounds;
}

@end
