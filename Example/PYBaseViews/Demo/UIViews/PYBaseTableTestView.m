//
//  PYBaseTableTestView.m
//  PYBaseViews_Example
//
//  Created by 衣二三 on 2019/8/23.
//  Copyright © 2019 LiPengYue. All rights reserved.
//

#import "PYBaseTableTestView.h"

//#import "BaseObjectHeaders.h"
//#import "BaseViewHeaders.h"
#import <PYBaseView.h>
#import "BaseTableTestCell1.h"
#import "BaseTableTestCell2.h"
#import "BaseTableTestCell3.h"
#import "BasetableTestHeserFooterView1.h"
#import "BasetableTestHeserFooterView2.h"


@interface PYBaseTableTestView()
<
PYBaseTableViewDelegate,
PYBaseTableViewDataSource,
PYBaseTableViewCellDelegate
>

@property (nonatomic,strong) NSMutableArray <NSString *>*data1;
@property (nonatomic,strong) NSMutableArray <NSString *>*data2;
@property (nonatomic,strong) NSMutableArray <NSString *>*data3;
@property (nonatomic,strong) NSMutableArray <NSString *>*data4;
@end

static NSString *const KBaseTableTestCell3_data3 = @"KBaseTableTestCell3_data3";
static NSString *const KBaseTableTestCell3_data4 = @"KBaseTableTestCell3_data4";

static NSString *const KBaseTableTestCell1 = @"BaseTableTestCell1";
static NSString *const KBaseTableTestCell2 = @"BaseTableTestCell2";
static NSString *const KBaseTableTestCell3 = @"BaseTableTestCell3";
static NSString *const KBasetableTestHeserFooterView1 = @"BasetableTestHeserFooterView1";
static NSString *const KBasetableTestHeserFooterView2 = @"BasetableTestHeserFooterView2";

@implementation PYBaseTableTestView
// MARK: - init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViewsFunc1];
        self.tableViewDelegate = self;
        self.tableViewDataSource = self;
    }
    return self;
}

#pragma mark - func
// MARK: reload data


// MARK: handle views
- (void) setupSubViewsFunc1 {
    self.data1 = @[@"你的名字"].mutableCopy;
    self.data2 = @[@"我的钱包",@"常见问题",@"联系客服",@"查看权益"].mutableCopy;
    self.data3 = @[@"绿箩<EB>学名：Epipremnum aureum (Linden et André) G. S. Bunting 是天南星科喜林芋属蔓性攀援植物"].mutableCopy;
    self.data4 = @[@"鹅掌柴<EB>学名：（Schefflera octophylla (Lour.) Harms），为常绿灌木。分枝多，枝条紧密。掌状复叶，小叶5～8枚，"].mutableCopy;
    for (int i = 0; i < 3; i++) {
        [self.data3 addObjectsFromArray:self.data3];
        [self.data4  addObjectsFromArray:self.data4];
    }
    [self reloadData];
}

// MARK: handle event
- (void) registerEventsFunc {
    
}

// MARK: lazy loads

// MARK: systom functions

// MARK:life cycles


#pragma mark - delegate dataSource
- (SBaseTabelViewData) getTableViewData:(PYBaseTableView *)baseTableView andCurrentSection:(NSInteger)section andCurrentRow:(NSInteger)row {
    
    SBaseTabelViewData data = SBaseTabelViewDataMakeDefault();
    data.sectionCount = 6;
    
    if (section == 0) {
        data.rowCount = self.data1.count;
        data.rowHeight = 60;
        data.rowType = BaseTableTestCell1.class;
        data.rowIdentifier = KBaseTableTestCell1;
    }
    
    if (section == 1) {
        data.rowCount = self.data2.count;
        data.rowHeight = 30;
        data.rowType = BaseTableTestCell2.class;
        data.rowIdentifier = KBaseTableTestCell2;
        data.headerHeight = 40;
        data.headerIdentifier = KBasetableTestHeserFooterView1;
        data.headerType = BasetableTestHeserFooterView1.class;
    }
    
    if (section == 2) {
        data.rowCount = self.data3.count;
        data.rowHeight = 112;
        data.rowType = BaseTableTestCell3.class;
        data.rowIdentifier = KBaseTableTestCell3;
        data.headerHeight = 50;
        data.headerIdentifier = KBasetableTestHeserFooterView2;
        data.headerType = BasetableTestHeserFooterView2.class;
        data.isXibCell = true;
        data.key = KBaseTableTestCell3_data3;///根据key区分是第二组数据
    }
    
    if (section == 3) {
        data.rowCount = self.data4.count;
        data.rowHeight = 120;
        data.rowType = BaseTableTestCell3.class;
        data.rowIdentifier = KBaseTableTestCell3;
        
        data.headerHeight = 60;
        data.headerIdentifier = KBasetableTestHeserFooterView2;
        data.headerType = BasetableTestHeserFooterView2.class;
        data.isXibCell = true;
        data.key = KBaseTableTestCell3_data4;///根据key区分是第三组数据
    }
    return data;
}

- (void)baseTableView:(PYBaseTableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath andData:(SBaseTabelViewData)data{
    
    if ([BaseTableTestCell1.class isEqual: cell.class]) {
    }
    
    if ([BaseTableTestCell2.class isEqual: cell.class]) {
        BaseTableTestCell2 *cell2 = (BaseTableTestCell2 *)cell;
        cell2.titleLabel.text = self.data2[indexPath.row];
        cell2.subTitleLabel.text = self.data2[indexPath.row];
        __weak typeof(self)weakSelf = self;
        [cell2 setClickCallBack:^{
            [weakSelf.tableView reloadData];
        }];
    }
    
    if ([BaseTableTestCell3.class isEqual: cell.class]) {
        
        BaseTableTestCell3 *cell3 = (BaseTableTestCell3 *)cell;
        NSString *str = @"";
        
        if ([KBaseTableTestCell3_data3 isEqualToString:data.key]) {
            str = self.data3[indexPath.row];
        }
        
        if ([KBaseTableTestCell3_data4 isEqualToString:data.key]) {
            str = self.data4[indexPath.row];
        }
        
        NSArray <NSString *>*array = [str componentsSeparatedByString:@"<EB>"];
        cell3.nameLabel.text = array.firstObject;
        cell3.subTitleLabel.text = array.lastObject;
        cell3.delegate = self;
        [cell3 addGestureRecognizer: cell3.longPressGesture];
    }
}


- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section andData: (SBaseTabelViewData)data {
    
    if ([BasetableTestHeserFooterView1.class isEqual:view.class]) {
        BasetableTestHeserFooterView1 *header = (BasetableTestHeserFooterView1 *)view;
        header.titleLabel.text = @"设置";
    }
    
    /// 第二种headerView
    if ([BasetableTestHeserFooterView2.class isEqual:view.class]) {
        BasetableTestHeserFooterView2 *header = (BasetableTestHeserFooterView2 *)view;
        
        /// 用key区分header的类型
        if ([data.key isEqualToString:KBaseTableTestCell3_data3]) {
            header.titleLabel.text = @"小的绿萝";
            header.rightPointView.backgroundColor = UIColor.redColor;
        }
        if ([data.key isEqualToString:KBaseTableTestCell3_data4]) {
            header.titleLabel.text = @"大的鹅鹅鹅掌柴";
            header.rightPointView.backgroundColor = UIColor.blueColor;
        }
    }
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath andData:(SBaseTabelViewData)data {
//    if ([BaseTableTestCell1.class isEqual:data.rowType]) {
//        NSLog(@"BaseTableTestCell1");
//    }
//}

- (void)longPressGestureActionWithIndex:(NSIndexPath *)index {
    NSLog(@"%@",index);
}

@end
