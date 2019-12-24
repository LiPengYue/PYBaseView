//
//  PYPageTableView.h
//  FBSnapshotTestCase
//
//  Created by 衣二三 on 2019/12/20.
//

#import <UIKit/UIKit.h>
#import "PYBaseView.h"

@class PYPageTableView;

NS_ASSUME_NONNULL_BEGIN

@protocol PYPageTableViewDelegate <NSObject>
@optional
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
          andData: (SBaseTabelViewData)data;

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section andData: (SBaseTabelViewData)data NS_AVAILABLE_IOS(6_0);

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section andData: (SBaseTabelViewData)data NS_AVAILABLE_IOS(6_0);

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath andData: (SBaseTabelViewData)data NS_AVAILABLE_IOS(6_0);

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section andData: (SBaseTabelViewData)data NS_AVAILABLE_IOS(6_0);

- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section andData: (SBaseTabelViewData)data NS_AVAILABLE_IOS(6_0);
@end

@protocol PYPageTableViewDataSource <NSObject>
@required
/// 获取tableView 的布局数据 (将会频繁调用)
- (SBaseTabelViewData) getTableViewData: (PYPageTableView *)tableView
                      andCurrentSection: (NSInteger) section
                          andCurrentRow: (NSInteger) row;

/// cell 将要出现的时候调用
- (void) baseTableView: (PYPageTableView *)tableView
       willDisplayCell: (UITableViewCell *)cell
     forRowAtIndexPath: (NSIndexPath *)indexPath
               andData: (SBaseTabelViewData)data;

@end



@interface PYPageTableView : PYBaseView


/// 更新这两个属性后 需要完全自定义 pageView的位置
@property (nonatomic,weak) id <PYPageTableViewDataSource> tableViewDataSource;
@property (nonatomic,weak) id <PYPageTableViewDelegate> tableViewDelegate;

@property (nonatomic,strong) PYBaseTableView *tableView;
@end

NS_ASSUME_NONNULL_END
