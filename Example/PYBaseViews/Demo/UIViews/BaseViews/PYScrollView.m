//
//  PYScrollView.m
//  PYBaseViews_Example
//
//  Created by 衣二三 on 2019/12/25.
//  Copyright © 2019 LiPengYue. All rights reserved.
//

#import "PYScrollView.h"
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
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"\n -- : 【%f】",scrollView.contentOffset.y);
}
@end
