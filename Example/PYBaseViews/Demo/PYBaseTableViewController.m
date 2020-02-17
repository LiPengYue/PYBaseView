//
//  PYBaseTableViewController.m
//  PYBaseViews_Example
//
//  Created by 衣二三 on 2019/8/23.
//  Copyright © 2019 LiPengYue. All rights reserved.
//

#import "PYBaseTableViewController.h"
#import "PYBaseTableTestView.h"
#import <PYTableView.h>
@interface PYBaseTableViewController ()
<
UIGestureRecognizerDelegate,
UITableViewDataSource
>
@property (nonatomic,strong) PYTableView *tableView1;
@property (nonatomic,strong) PYBaseTableTestView *tableView;
@end

@implementation PYBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
//    self.navBarView.addLeftItemWithTitleAndImg(@"返回",nil);
//    __weak typeof (self)weakSelf = self;
//    [self.navBarView clickLeftButtonFunc:^(UIButton * _Nonnull button, NSInteger index) {
//        [weakSelf.navigationController popViewControllerAnimated:true];
//    }];
//    [self.navBarView reloadView];
//
//    [self.view addSubview:self.tableView];
//    self.tableView.frame = CGRectMake(0, PYBaseSize.navTotalH, PYBaseSize.screenW, PYBaseSize.screen_navH);
//    [self.tableView reloadData];
//    self.tableView.tableView.estimatedSectionFooterHeight = 0;
//    self.tableView.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView1 = [[PYTableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView1];
    self.tableView1.delegate = self;
    self.tableView1.dataSource = self;
    
    [self.tableView1 registerClass:UITableViewCell.class forCellReuseIdentifier:@"CELLID"];
    
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return true;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 12;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:@"CELLID" forIndexPath:indexPath];
}

- (PYBaseTableTestView *)tableView {
    if (!_tableView) {
        _tableView  = [[PYBaseTableTestView alloc]init];
        _tableView.tableViewStyle = UITableViewStylePlain;
    }
    return _tableView;
}


@end
