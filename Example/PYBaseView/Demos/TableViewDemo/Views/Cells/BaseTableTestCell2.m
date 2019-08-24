//
//  BaseTableTestCell2.m
//  Test
//
//  Created by 衣二三 on 2019/4/16.
//  Copyright © 2019 衣二三. All rights reserved.
//

#import "BaseTableTestCell2.h"
#import <BaseColorHandler.h>

@interface BaseTableTestCell2()
/// clickCallBack
@property (nonatomic,strong) UIButton *button;
@end

@implementation BaseTableTestCell2
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupViews];
    }
    return self;
}

- (void) setupViews {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subTitleLabel];
    [self.contentView addSubview:self.button];
}

- (void) layoutSubviews {
    [super layoutSubviews];
    CGFloat h = self.frame.size.height;
    CGFloat w = self.frame.size.width;
    self.titleLabel.frame = CGRectMake(14, 0, w/2.0-14, h);
    self.subTitleLabel.frame = CGRectMake(w/2.0-14, 0, w/2.0-14, h);
    self.button.frame = self.contentView.bounds;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = BaseColorHandler.cGrayD;
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [UILabel new];
        _subTitleLabel.textAlignment = NSTextAlignmentRight;
//        _subTitleLabel.font = BaseFont.fontSCL(12);
        _subTitleLabel.textColor = BaseColorHandler.cGrayL;
    }
    return _subTitleLabel;
}
/// button
- (UIButton *) button {
    if (!_button) {
        _button = [UIButton new];
        
        [_button addTarget:self action:@selector(click_buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}
- (void) click_buttonAction:(UIButton *)button {
    if (self.clickCallBack) {
        self.clickCallBack();
    }
}
@end
