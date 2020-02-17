//
//  BaseSegmentTagCollectionViewCell.m
//  PYBaseViews_Example
//
//  Created by 李鹏跃 on 2019/12/24.
//  Copyright © 2019 Lyman Li. All rights reserved.
//

#import "BaseSegmentTagCollectionViewCell.h"

@interface BaseSegmentTagCollectionViewCell ()

@property (nonatomic,strong) id modelPrivate;
@end

@implementation BaseSegmentTagCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.label];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.label.frame = self.contentView.bounds;
}

- (void)setupData:(id)data {
    self.modelPrivate = data;
    if ([data isKindOfClass:NSString.class]) {
        self.label.text = data;
    }
}

- (id)model { return self.modelPrivate; }

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;

    BaseSegmentTagCollectionViewCellStyleModel *data = self.styleData;
    UIColor *textColor = isSelected?data.selectedTextColor:data.normalTextColor;
    UIColor *bgColor = isSelected?data.selectedBackgroundColor:data.normalBackgroundColor;
    
    CGFloat borderW = isSelected?data.selectedBorderW:data.normalBorderW;
    CGFloat cornerRadius = isSelected?data.selectedCornerRadius:data.normalCornerRadius;
    UIColor *borderColor = isSelected?data.selectedBorderColor:data.normalBorderColor;

    UIFont *font = isSelected?data.selectedFont:data.normalFont;
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.label.font = font;
        self.label.textColor = textColor;
        self.label.backgroundColor = bgColor;
        self.label.layer.borderWidth = borderW;
        self.label.layer.borderColor = borderColor.CGColor;
        self.label.layer.cornerRadius = cornerRadius;
    } completion:^(BOOL finished) {

    }];
    
}


- (UILabel *)label {
    if (!_label) {
        _label = [UILabel new];
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}
@end

@implementation BaseSegmentTagCollectionViewCellStyleModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.normalFont = [UIFont systemFontOfSize:12];
        self.selectedFont = [UIFont systemFontOfSize:12];
        self.normalBackgroundColor = UIColor.whiteColor;
        self.selectedBackgroundColor = UIColor.whiteColor;
        self.selectedTextColor = [UIColor colorWithRed:28/255.0 green:28/255.0 blue:28/255.0 alpha:1.0];
        self.normalTextColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    }
    return self;
}

@end
