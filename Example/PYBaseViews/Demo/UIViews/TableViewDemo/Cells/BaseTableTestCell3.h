//
//  BaseTableTestCell3.h
//  Test
//
//  Created by 李鹏跃 on 2019/8/23.
//  Copyright © 2019 LiPengYue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PYBaseView.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseTableTestCell3 : PYBaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@end

NS_ASSUME_NONNULL_END
