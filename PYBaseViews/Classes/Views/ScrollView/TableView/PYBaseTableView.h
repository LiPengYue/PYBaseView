//
//  PYBaseTableView.h
//  FBSnapshotTestCase
//
//  Created by 衣二三 on 2019/8/23.
//

#import <UIKit/UIKit.h>
#import "PYBaseTableViewDelegate.h"
#import "PYBaseTableViewDataSource.h"
#import "PYBaseTableViewCell.h"
#import "PYTableView.h"
#import "PYBaseTableHeaderFooterView.h"

NS_ASSUME_NONNULL_BEGIN

@interface PYBaseTableView : UIView
<
UITableViewDataSource,
UITableViewDelegate
>


@property (nonatomic,weak) id <PYBaseTableViewDelegate> tableViewDelegate;
@property (nonatomic,weak) id <PYBaseTableViewDataSource> tableViewDataSource;



@property (nonatomic,assign) UITableViewStyle tableViewStyle;
@property (nonatomic,strong,readonly) PYTableView *tableView;

- (void) reloadData;
- (void) endUpdates;
- (void) beginUpdates;

/// 每次在更改高度或者 数据源变化后，都需要重制缓存，否则会导致高度获取的不准确
- (void) reloadIndexPathFrameCatch;

/**
 获取当前所有的 indexPath对应的frame
 
 这个值会在[tableView reloadData]时候更新
 @return 缓存的位置信息
 */
- (NSDictionary <NSIndexPath *, NSValue *>*) getCurrentIndexPathAnchorPointsCache;


/**
 获取一个indexPath 对应的frame
 
 @param indexPath indexPath
 @return frame
 */
- (CGRect) getAnchorPointWithIndexPath: (NSIndexPath *)indexPath;

/**
 某个header的frame
 
 @param section 第几组
 @return frame
 */
- (CGRect) getHeaderFrameWithSection: (NSInteger) section;

/**
 某个footer的frame
 
 @param section 第几组
 @return frame
 */
- (CGRect) getFooterFrameWithSection: (NSInteger) section;

/**
 获取某个index的y
 
 @param indexPath index
 @return frame.origin.y
 */
- (CGFloat) getYIndexPathWithIndexPath: (NSIndexPath *)indexPath;

/// 如果是baseTableViewCell
@property (nonatomic,assign) BOOL isHiddenSeparatorLine;
@property (nonatomic,assign) CGFloat separatorLineH;
@property (nonatomic,strong) UIColor *separatorColor;
@property (nonatomic,assign) UIEdgeInsets separatorLineEdge;
@end

NS_ASSUME_NONNULL_END
