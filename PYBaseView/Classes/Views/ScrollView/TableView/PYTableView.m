//
//  PYTableView.m
//  FBSnapshotTestCase
//
//  Created by 衣二三 on 2019/8/16.
//

#import "PYTableView.h"

@interface PYTableView()
@property (nonatomic,copy) void(^reloadDataBlock)(void);
@end

@implementation PYTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGFLOAT_MIN, CGFLOAT_MIN)];
        self.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGFLOAT_MIN, CGFLOAT_MIN)];
    }
    return self;
}

- (void)reloadData {
    [super reloadData];
    if (self.reloadDataBlock) {
        self.reloadDataBlock();
    }
}

- (void) reloadDataEventCallBack: (void(^)(void))block {
    self.reloadDataBlock = block;
}
@end
