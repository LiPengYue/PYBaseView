//
//  PYSubTableVew.m
//  PYBaseViews_Example
//
//  Created by 李鹏跃 on 2019/12/25.
//  Copyright © 2019 LiPengYue. All rights reserved.
//

#import "PYSubTableVew.h"
#import <PYBaseView.h>
#import <MJRefresh/MJRefresh.h>

@interface PYSubTableVew()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) NSMutableArray <NSString *>*dataSourceArray;
@property (nonatomic,strong) ScrollViewPanDirectionHandler *panHandler;
@end

@implementation PYSubTableVew


- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        [self setupViews];
    }
    
    return self;
}

- (void) setupViews {
    self.delegate = self;
    self.dataSource = self;
    [self registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
    self.backgroundColor = [self random];
//    self.bounces = false;
    [self initDataSource];
    __weak typeof (self)weakSelf = self;
    self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.mj_footer endRefreshing];
        });
    }];
}

- (void)initDataSource {
    
    self.dataSourceArray = [[NSMutableArray alloc] init];
    for (int j = 0; j < 1; ++j) {
        [self.dataSourceArray addObject:[NSString stringWithFormat:@"row - %d", j]];
    }
}

- (UIColor *)random {
    return [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0];
}
#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSourceArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.dataSourceArray[indexPath.row];
    cell.backgroundColor = UIColor.clearColor;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

@end
