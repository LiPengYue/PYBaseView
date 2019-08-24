//
//  PYMainView.m
//  PYBaseViews_Example
//
//  Created by 衣二三 on 2019/8/23.
//  Copyright © 2019 LiPengYue. All rights reserved.
//

#import "PYMainView.h"
#import <PYBaseEventHandler.h>
#import <PYBaseView.h>
#import "PYMainTableViewCell.h"

@interface PYMainView ()
<
PYBaseTableViewDelegate,
PYBaseTableViewDataSource
>
@property (nonatomic,strong) PYTableMainView *tableView;
@property (nonatomic,strong) NSArray <NSString *>*dataArray;
@property (nonatomic,strong) NSArray <NSString *>*titleArray;
@end


@implementation PYMainView


// MARK: - init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViewsFunc];
    }
    return self;
}

- (NSArray<NSString *> *)dataArray {
    if (!_dataArray) {
        _dataArray = @[
                                              @"PresentViewController",
                       @"PYBaseTableViewController",
                       //                       @"BaseTextViewController",
                       //                       @"DeleteCollectionCellViewController",
                       //                       @"ThumbnailImageViewController",
                       //                       @"PresentAnimationVC",
                       //                       @"PYCountDownViewController",
                       //                       @"DebugNetWorkViewController"
                       ];
    }
    return _dataArray;
}

- (NSArray<NSString *> *)titleArray {
    if (!_titleArray) {
        _titleArray = @[
                        @"进度条demo",
                        @"tableView封装demo",
                        ];
    }
    return _titleArray;
}

#pragma mark - func
// MARK: reload data


// MARK: handle views
- (void) setupSubViewsFunc {
    [self addSubview: self.tableView];
    
    
}

// MARK: handle event
- (void) registerEventsFunc {
    
}

// MARK: lazy loads
- (PYTableMainView *)tableView {
    if (!_tableView) {
        _tableView = [[PYTableMainView alloc]initWithFrame:self.bounds];
        _tableView.tableViewDelegate = self;
        _tableView.tableViewDataSource = self;
    }
    return _tableView;
}

// MARK: systom functions

// MARK:life cycles


#pragma mark - delegate dataSource
- (SBaseTabelViewData) getTableViewData:(PYMainView *)baseTableView andCurrentSection:(NSInteger)section andCurrentRow:(NSInteger)row {
    
    SBaseTabelViewData data = SBaseTabelViewDataMakeDefault();
    data.rowCount = self.titleArray.count;
    data.sectionCount = 1;
    data.rowHeight = 60;
    data.rowType = PYMainTableViewCell.class;
    data.rowIdentifier = @"MainTableViewCell";
    data.key = self.dataArray[row];
    return data;
}

- (void)baseTableView:(PYMainView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath andData:(SBaseTabelViewData)data{
    
    if ([PYMainTableViewCell.class isEqual: data.rowType]) {
        PYMainTableViewCell *mainCell = (PYMainTableViewCell *)cell;
        mainCell.title = self.titleArray[indexPath.row];
    }
}


- (void)tableView:(PYTableMainView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath andData:(SBaseTabelViewData)data {
    
    if ([PYMainTableViewCell.class isEqual:data.rowType]) {
        NSString *classStr = data.key;
        UIViewController *vc = [NSClassFromString(classStr) new];
        [self send:kClickMainView andData:vc];
    }
}
@end


