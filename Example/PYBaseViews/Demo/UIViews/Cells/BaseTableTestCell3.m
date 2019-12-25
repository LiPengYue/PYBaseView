//
//  BaseTableTestCell3.m
//  Test
//
//  Created by 李鹏跃 on 2019/8/23.
//  Copyright © 2019 LiPengYue. All rights reserved.
//

#import "BaseTableTestCell3.h"
@interface BaseTableTestCell3()

@end
@implementation BaseTableTestCell3

- (void)awakeFromNib {
    [super awakeFromNib];
    self.productImageView.image = [UIImage imageNamed:@"1"];
    self.productImageView.contentMode = UIViewContentModeScaleToFill;
    self.productImageView.layer.masksToBounds = true;
    self.productImageView.layer.cornerRadius = 6;
    self.productImageView.contentMode = UIViewContentModeScaleAspectFill;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
