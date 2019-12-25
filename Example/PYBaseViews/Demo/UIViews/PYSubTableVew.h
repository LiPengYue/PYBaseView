//
//  PYSubTableVew.h
//  PYBaseViews_Example
//
//  Created by 李鹏跃 on 2019/12/25.
//  Copyright © 2019 LiPengYue. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PYSubTableVew : UITableView
@property (nonatomic,assign) BOOL isCanScroll;
@property (nonatomic,copy) void(^canNotScroll)(void);
@end

NS_ASSUME_NONNULL_END
