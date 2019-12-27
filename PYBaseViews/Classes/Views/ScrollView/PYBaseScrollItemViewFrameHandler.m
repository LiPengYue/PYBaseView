//
//  PYBaseScrollItemViewFrameHandler.m
//  FBSnapshotTestCase
//
//  Created by 衣二三 on 2019/12/26.
//

#import "PYBaseScrollItemViewFrameHandler.h"
#ifdef DEBUG
#    define DLOG(...) NSLog(__VA_ARGS__)
#else
#    define DLOG(...)
#endif

@interface PYBaseScrollItemViewFrameHandler()
@property (nonatomic,copy)CGFloat(^getItemHeightBlock)(NSIndexPath *indexPath);
@property (nonatomic,copy)CGFloat(^getHeaderHeightBlock)(NSInteger section);
@property (nonatomic,copy)CGFloat(^getFooterHeightBlock)(NSInteger section);

@property (nonatomic,copy)NSInteger(^getSectionItemCountBlock)(NSInteger section);

@property (nonatomic,strong) NSMutableDictionary <NSIndexPath *,NSValue *>* currentIndexPathFrameCache;
@property (nonatomic,strong) NSMutableDictionary <NSIndexPath *,NSValue *>* currentSectionHeaderFrameCache;
@property (nonatomic,strong) NSMutableDictionary <NSIndexPath *,NSValue *>* currentSectionFooterFrameCache;

@end

@implementation PYBaseScrollItemViewFrameHandler


- (instancetype) initWithScrollView: (UIScrollView *)scrollView {
    if (self = [super init]) {
        _scrollView = scrollView;
    }
    return self;
}

- (CGFloat) getTopSpactin {
    if ([self.scrollView isKindOfClass:UITableView.class]) {
        UITableView *tableView = (UITableView *)self.scrollView;
        return tableView.contentInset.top + tableView.tableHeaderView.frame.size.height;
    }
    if ([self.scrollView isKindOfClass:UICollectionView.class]) {
        return self.scrollView.contentInset.top;
    }
    return self.scrollView.contentInset.top;
}

- (void) getItemH: (CGFloat(^)(NSIndexPath *indexPath))block {
    _getItemHeightBlock = block;
}

- (void) getHeaderH: (CGFloat(^)(NSInteger indexPath))block {
    _getHeaderHeightBlock = block;
}

- (void) getFooterH: (CGFloat(^)(NSInteger indexPath))block {
    _getFooterHeightBlock = block;
}

- (void) getSectionItemCount: (NSInteger(^)(NSInteger section)) block {
    _getSectionItemCountBlock = block;
}

- (CGFloat) getHeaderHeightForSection: (NSInteger)section {
    if (self.getHeaderHeightBlock) {
        return self.getHeaderHeightBlock(section);
    }
    return 0.0;
}

- (CGFloat) getFooterHeightForSection: (NSInteger)section {
    if (self.getFooterHeightBlock) {
        return self.getFooterHeightBlock(section);
    }
    return 0.0;
}

- (CGFloat) getItemHeightForIndexPath: (NSIndexPath *)indexPath {
    if (self.getItemHeightBlock) {
        return self.getItemHeightBlock(indexPath);
    }
    return 0.0;
}

- (NSInteger) getItemCountWithSection: (NSInteger) section {
    if (self.getSectionItemCountBlock) {
        return self.getSectionItemCountBlock(section);
    }
    return 0;
}

- (void) reloadIndexPathFrameCatch {
    [self.currentIndexPathFrameCache removeAllObjects];
    [self.currentSectionHeaderFrameCache removeAllObjects];
    [self.currentSectionFooterFrameCache removeAllObjects];
}

- (NSDictionary <NSIndexPath *, NSValue *>*) getCurrentIndexPathAnchorPointsCache {
    return self.currentIndexPathFrameCache;
}

- (NSMutableDictionary<NSIndexPath *,NSValue *> *)currentIndexPathFrameCache {
    if (!_currentIndexPathFrameCache) {
        _currentIndexPathFrameCache = [NSMutableDictionary new];
    }
    return _currentIndexPathFrameCache;
}

- (NSMutableDictionary<NSIndexPath *,NSValue *> *)currentSectionFooterFrameCache {
    if (!_currentSectionFooterFrameCache) {
        _currentSectionFooterFrameCache = [NSMutableDictionary new];
    }
    return _currentSectionFooterFrameCache;
}

- (NSMutableDictionary<NSIndexPath *,NSValue *> *)currentSectionHeaderFrameCache {
    if (!_currentSectionHeaderFrameCache) {
        _currentSectionHeaderFrameCache = [NSMutableDictionary new];
    }
    return _currentSectionHeaderFrameCache;
}

- (CGRect) getHeaderFrameWithSection: (NSInteger) section {
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:section];
    if (!self.currentSectionHeaderFrameCache[index]) {
        
        // 求上层的footer的frame
        CGFloat y = 0;
        CGFloat h = [self getHeaderHeightForSection:section];
        if (section == 0) {
            y = [self getTopSpactin];
        }else{
            y = CGRectGetMaxY([self getFooterFrameWithSection:section-1]);
        }
        self.currentSectionHeaderFrameCache[index] = [NSValue valueWithCGRect:CGRectMake(0, y, self.scrollView.frame.size.width, h)];
    }
    return self.currentSectionHeaderFrameCache[index].CGRectValue;
}

- (CGRect) getFooterFrameWithSection: (NSInteger) section {
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:section];
    CGFloat y = 0;
    CGFloat h = [self getFooterHeightForSection:section];
    if (!self.currentSectionFooterFrameCache[index]) {
        NSInteger rowCount = [self getItemCountWithSection:section];
        if(rowCount <= 0) {
            y = CGRectGetMaxY([self getHeaderFrameWithSection:section]);
        }else{
            NSInteger row = rowCount - 1;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            y = CGRectGetMaxY([self getItemFrameWithIndexPath:indexPath]);
        }
        self.currentSectionFooterFrameCache[index] = [NSValue valueWithCGRect:CGRectMake(0, y, self.scrollView.frame.size.width, h)];
    }
    return self.currentSectionFooterFrameCache[index].CGRectValue;
}

- (CGRect) getItemFrameWithIndexPath: (NSIndexPath *)indexPath {
    
    CGFloat y = 0;
    CGFloat h = 0;
    if (indexPath.section < 0) {
        DLOG(@"\n🌶：getItemFrameWithIndexPath section小于0！！\n");
        return CGRectZero;
    }
    if (!self.currentIndexPathFrameCache[indexPath]) {
        NSInteger rowCount = [self getItemCountWithSection: indexPath.section];
        if (rowCount <= 0 || indexPath.row < 0){
            y = CGRectGetMaxY([self getHeaderFrameWithSection:indexPath.section]);
        }
        else if (rowCount <= indexPath.row) {
            DLOG(@"\n🌶：getItemFrameWithIndexPath 【rowCount <= indexPath.row】！！\n");
            y = CGRectGetMinY([self getFooterFrameWithSection:indexPath.section]);
        }
        else if (indexPath.row == 0) {
            y = CGRectGetMaxY([self getHeaderFrameWithSection:indexPath.section]);
            h = [self getItemHeightForIndexPath: indexPath];
        }else if (indexPath.row > 0 && indexPath.row < rowCount){
            NSIndexPath *frontIndexPath = [NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section];
            y = CGRectGetMaxY([self getItemFrameWithIndexPath:frontIndexPath]);
            h = [self getItemHeightForIndexPath:indexPath];
        }
        self.currentIndexPathFrameCache[indexPath] = [NSValue valueWithCGRect:CGRectMake(0, y, self.scrollView.frame.size.width, h)];
    }
    
    return self.currentIndexPathFrameCache[indexPath].CGRectValue;
}


@end
