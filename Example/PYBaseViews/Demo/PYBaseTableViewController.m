//
//  PYBaseTableViewController.m
//  PYBaseViews_Example
//
//  Created by 衣二三 on 2019/8/23.
//  Copyright © 2019 LiPengYue. All rights reserved.
//

#import "PYBaseTableViewController.h"
#import "PYBaseTableTestView.h"

@interface PYBaseTableViewController ()

@property (nonatomic,strong) PYBaseTableTestView *tableView;
@end

@implementation PYBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.navBarView.addLeftItemWithTitleAndImg(@"返回",nil);
    __weak typeof (self)weakSelf = self;
    [self.navBarView clickLeftButtonFunc:^(UIButton * _Nonnull button, NSInteger index) {
        [weakSelf.navigationController popViewControllerAnimated:true];
    }];
    [self.navBarView reloadView];
    
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, PYBaseSize.navTotalH, PYBaseSize.screenW, PYBaseSize.screen_navH);
    [self.tableView reloadData];
    self.tableView.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.tableView.estimatedSectionHeaderHeight = 0;

}



- (PYBaseTableTestView *)tableView {
    if (!_tableView) {
        _tableView  = [[PYBaseTableTestView alloc]init];
    }
    return _tableView;
}


@end
