//
//  BaseSegmentTagCollectionViewCell.m
//  MFNestTableViewDemo
//
//  Created by 衣二三 on 2019/12/24.
//  Copyright © 2019 Lyman Li. All rights reserved.
//

#import "BaseSegmentTagCollectionViewCell.h"

@interface BaseSegmentTagCollectionViewCell ()
@property (nonatomic,strong) UILabel *label;
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
    
    SBaseSegmentTagCollectionViewCellData data = self.styleData;
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

@end
