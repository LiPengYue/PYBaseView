//
//  PYBaseTableCell.h
//  FBSnapshotTestCase
//
//  Created by 衣二三 on 2019/8/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol PYBaseTableCellDelegate <NSObject>
/// 长按一个view后，的回调，这里不能直接去取cell，或者cell的model，因为长按手势有回调延迟，如果在毁掉延迟中对tableView进行reloadData，这个cell的位置就有可能改变
- (void) longPressGestureActionWithIndex: (NSIndexPath *)index;
@end
@interface PYBaseTableCell : UITableViewCell

@property (nonatomic,strong) UIView *topLineView;
@property (nonatomic,strong) UIView *bottomLineView;

@property (nonatomic,assign) BOOL isHiddenSeparatorLine;
@property (nonatomic,assign) CGFloat separatorLineH;
@property (nonatomic,strong) UIColor *separatorColor;
@property (nonatomic,assign) UIEdgeInsets separatorLineEdge;

/// 默认不绑定longPressGesture的view，需要自行绑定
@property (nonatomic,strong) UILongPressGestureRecognizer *longPressGesture;

@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,strong) NSIndexPath *currentIndexPath;

@property (nonatomic,weak) id <PYBaseTableViewCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
