//
//  PYMainTableViewCell.m
//  PYBaseViews_Example
//
//  Created by 衣二三 on 2019/8/23.
//  Copyright © 2019 LiPengYue. All rights reserved.
//

#import "PYMainTableViewCell.h"
#import <PYBaseView.h>

@interface PYMainTableViewCell()
/// title
@property (nonatomic,strong) PYBaseLabel * titleLabel;

@end
@implementation PYMainTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self =[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.titleLabel = [PYBaseLabel new];
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    self.titleLabel.textColor = UIColor.grayColor;
    self.titleLabel.numberOfLines = 0;
    [self.contentView addSubview:self.titleLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(10, 0, self.frame.size.width - 10, self.frame.size.height);
}

- (void) setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}
@end
