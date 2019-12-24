//
//  PYPageTableView.m
//  FBSnapshotTestCase
//
//  Created by 衣二三 on 2019/12/20.
//

#import "PYPageTableView.h"
#import "PYBaseTableView.h"

@interface PYPageTableView ()
<
PYBaseTableViewDelegate,
PYBaseTableViewDataSource
>


@end

@implementation PYPageTableView


- (PYBaseTableView *)tableView {
    
    if (!_tableView) {
        _tableView = [PYBaseTableView new];
        _tableView.tableViewDelegate =  self;
        _tableView.tableViewDataSource = self;
    }
    return _tableView;
}

- (SBaseTabelViewData) getTableViewData: (PYBaseTableView *)baseTableView
                      andCurrentSection: (NSInteger) section
                          andCurrentRow: (NSInteger) row {
    
    SBaseTabelViewData data = SBaseTabelViewDataMakeDefault();
    if ([self.tableViewDataSource respondsToSelector:@selector(getTableViewData:andCurrentSection:andCurrentRow:)]) {
        [self.tableViewDataSource getTableViewData:self andCurrentSection:section andCurrentRow:row];
    }
    
    return data;
}


@end
