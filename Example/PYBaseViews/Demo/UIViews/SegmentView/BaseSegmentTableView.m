//
//  BaseSegmentTableView.m
//  MFNestTableViewDemo
//
//  Created by 衣二三 on 2019/12/24.
//  Copyright © 2019 Lyman Li. All rights reserved.
//

#import "BaseSegmentTableView.h"

@implementation BaseSegmentTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self baseSetupView];
    }
    return self;
}

- (void) baseSetupView {
    self.tableViewDelegate = self;
    self.tableViewDataSource = self;
    
}

@end
