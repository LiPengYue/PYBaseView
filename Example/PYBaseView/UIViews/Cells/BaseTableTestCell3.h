//
//  BaseTableTestCell3.h
//  Test
//
//  Created by 衣二三 on 2019/4/16.
//  Copyright © 2019 衣二三. All rights reserved.
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
