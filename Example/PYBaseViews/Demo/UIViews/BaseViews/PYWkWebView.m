//
//  PYWkWebView.m
//  PYBaseViews_Example
//
//  Created by 李鹏跃 on 2019/12/25.
//  Copyright © 2019 LiPengYue. All rights reserved.
//

#import "PYWkWebView.h"
#import <MJRefresh/MJRefresh.h>

@implementation PYWkWebView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self baseSetup];
    }
    return self;
}

- (void) baseSetup {
    __weak typeof (self)weakSelf = self;
    self.scrollView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.scrollView.mj_footer endRefreshing];
        });
    }];
}

@end
