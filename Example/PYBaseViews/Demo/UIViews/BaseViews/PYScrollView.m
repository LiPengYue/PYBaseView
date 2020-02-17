//
//  PYScrollView.m
//  PYBaseViews_Example
//
//  Created by 衣二三 on 2019/12/25.
//  Copyright © 2019 LiPengYue. All rights reserved.
//

#import "PYScrollView.h"
#import <MJRefresh/MJRefresh.h>
@interface PYScrollView()
<
UIScrollViewDelegate
>
@end
@implementation PYScrollView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self baseSetup];
    }
    return self;
}

- (void) baseSetup {
    self.delegate = self;
    __weak typeof (self)weakSelf = self;
    self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.mj_footer endRefreshing];
        });
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"\n -- : 【%f】",scrollView.contentOffset.y);
}
@end
