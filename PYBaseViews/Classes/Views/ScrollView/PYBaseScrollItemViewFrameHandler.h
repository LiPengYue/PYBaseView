//
//  PYBaseScrollItemViewFrameHandler.h
//  FBSnapshotTestCase
//
//  Created by 衣二三 on 2019/12/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PYBaseScrollItemViewFrameHandler : NSObject

- (instancetype) initWithScrollView: (UIScrollView *)scrollView;

- (void) getItemH: (CGFloat(^)(NSIndexPath *indexPath))block;
- (void) getHeaderH: (CGFloat(^)(NSInteger section))block;
- (void) getFooterH: (CGFloat(^)(NSInteger section))block;

/// section组中 每列并排共有多少个cell，默认是1
- (void) getSectionItemColumnCount: (NSInteger(^)(NSInteger section)) block;

- (void) getSectionItemCount: (NSInteger(^)(NSInteger section)) block;

/// 必须是 collectionView、或者是TableView
@property (nonatomic,weak,readonly) UIScrollView *scrollView;


/// 每次在更改高度或者 数据源变化后，都需要重制缓存，否则会导致高度获取的不准确
- (void) reloadIndexPathFrameCatch;

/**
 获取当前所有的 indexPath对应的frame
 
 这个值会在[tableView reloadData]时候更新
 @return 缓存的位置信息
 */
- (NSDictionary <NSIndexPath *, NSValue *>*) getCurrentIndexPathAnchorPointsCache;


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
 @return frame
 */
- (CGRect) getItemFrameWithIndexPath: (NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
