//
//  BaseTableTestCell2.h
//  Test
//
//  Created by 李鹏跃 on 2019/8/23.
//  Copyright © 2019 LiPengYue. All rights reserved.
//

#import <PYBaseView.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseTableTestCell2 : PYBaseTableViewCell
/// titleLabel
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UILabel * subTitleLabel;
@property (nonatomic,strong) void(^clickCallBack)(void);
@end

NS_ASSUME_NONNULL_END
