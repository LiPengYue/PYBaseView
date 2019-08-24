//
//  BaseTableTestCell1.m
//  Test
//
//  Created by 衣二三 on 2019/4/16.
//  Copyright © 2019 衣二三. All rights reserved.
//

#import "BaseTableTestCell1.h"
#import <PYBaseView.h>
#import <BaseColorHandler.h>

@interface BaseTableTestCell1 ()
/// iconimage
@property (nonatomic,strong) UIImageView *iconImageView;
@property (nonatomic,strong) PYBaseLabel *nameLabel;
@end

@implementation BaseTableTestCell1
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupViews];
    }
    return self;
}

- (void) setupViews {
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.iconImageView];
}

- (void) layoutSubviews {
    [super layoutSubviews];
    CGFloat h = self.frame.size.height;
    CGFloat w = self.frame.size.width;
    CGFloat imageh = MIN(h, 40);
    CGFloat y = (h - imageh)/2.;
    self.nameLabel.frame = CGRectMake(imageh + 14 +8, y, w-imageh-12-14, imageh);
    self.iconImageView.frame = CGRectMake(14, y, imageh, imageh);
    self.iconImageView.layer.masksToBounds = true;
    self.iconImageView.layer.cornerRadius = imageh/2.;
    self.iconImageView.layer.borderColor = UIColor.redColor.CGColor;
    self.iconImageView.layer.borderWidth = 1;
}

- (PYBaseLabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[PYBaseLabel alloc]init];
        _nameLabel.text = @"你的名字";
        _nameLabel.textColor = [UIColor colorWithWhite:0 alpha:0.8];
    }
    return _nameLabel;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
        UIImage *image = [UIImage imageNamed:@"3"];
        _iconImageView.image = image;
    }
    return _iconImageView;
}
@end
