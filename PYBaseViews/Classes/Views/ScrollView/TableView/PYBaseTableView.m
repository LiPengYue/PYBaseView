//
//  PYBaseTableView.m
//  FBSnapshotTestCase
//
//  Created by 衣二三 on 2019/8/23.
//

#import "PYBaseTableView.h"

#import "PYBaseTableViewCell.h"

#ifdef DEBUG
#    define DLOG(...) NSLog(__VA_ARGS__)
#else
#    define DLOG(...)
#endif

@interface PYBaseTableView()
<UIScrollViewDelegate>
/// 已经注册的cell
@property (nonatomic,strong) NSMutableDictionary *registerCellDic;
@property (nonatomic,strong) NSMutableDictionary *registerHeaderDic;
@property (nonatomic,strong) NSMutableDictionary *registerFooterDic;

@property (nonatomic,assign) SBaseTabelViewData defaultData;

@property (nonatomic,strong) PYBaseScrollItemViewFrameHandler *itemViewFrameHandler;

@end
/// cellID
static NSString *const KBASETABLEVIEWDEFAULTCELLID = @"KBASETABLEVIEWDEFAULTCELLID";
/// headerID
static NSString *const KBASETABLEVIEWDEFAULTHEADERID = @"KBASETABLEVIEWDEFAULTHEADERID";
/// footerID
static NSString *const KBASETABLEVIEWDEFAULTFOOTERID = @"KBASETABLEVIEWDEFAULTFOOTERID";
@implementation PYBaseTableView

// MARK: - init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupProperty];
        [self setupSubViewsFunc];
    }
    return self;
}

#pragma mark - func
// MARK: reload data


// MARK: handle views
- (void) setupSubViewsFunc {
    [self createTableView];
}

- (void) setupProperty {
    self.defaultData = SBaseTabelViewDataMakeDefault();
    self.tableViewStyle = UITableViewStylePlain;
    self.separatorLineH = 0.5;
    self.separatorLineEdge = UIEdgeInsetsMake(0, 14, 0, 14);
    
}

// MARK: handle event
- (void) registerEventsFunc {
    
}

// MARK: lazy loads

- (void) createTableView {
    [self.tableView removeFromSuperview];
    [self setValue:[[PYTableView alloc]initWithFrame:CGRectZero style:self.tableViewStyle] forKey:@"tableView"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:KBASETABLEVIEWDEFAULTCELLID];
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview: self.tableView];
}

- (void)setTableViewStyle:(UITableViewStyle)tableViewStyle {
    
    _tableViewStyle = tableViewStyle;
    if (self.tableView.style == tableViewStyle) {
        return;
    }
    [self createTableView];
}

- (NSMutableDictionary *)registerCellDic {
    if (!_registerCellDic) {
        _registerCellDic = [[NSMutableDictionary alloc]init];
    }
    return _registerCellDic;
}
- (NSMutableDictionary *)registerHeaderDic {
    if (!_registerHeaderDic) {
        _registerHeaderDic = [[NSMutableDictionary alloc]init];
    }
    return _registerHeaderDic;
}
- (NSMutableDictionary *)registerFooterDic {
    if (!_registerFooterDic) {
        _registerFooterDic = [[NSMutableDictionary alloc]init];
    }
    return _registerFooterDic;
}

// MARK: systom functions

- (void) layoutSubviews {
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
}

- (void) reloadData {
    [self.tableView reloadData];
}

- (void) beginUpdates {
    [self.tableView reloadData];
    [self reloadIndexPathFrameCatch];
}

- (void) endUpdates {
    [self.tableView endUpdates];
    [self reloadIndexPathFrameCatch];
}

- (void) reloadIndexPathFrameCatch {
    [self.itemViewFrameHandler reloadIndexPathFrameCatch];
}

// MARK:life cycles

#pragma mark - Delegate && DataSource
// MARK: dataSource
- (SBaseTabelViewData) getDataWithCurrentSection: (NSInteger)section andCurrentRow: (NSInteger)row {
    if ([self.tableViewDataSource respondsToSelector:@selector(getTableViewData:andCurrentSection:andCurrentRow:)]) {
        return [self.tableViewDataSource getTableViewData:self
                                        andCurrentSection:section
                                            andCurrentRow:row];
    }
    return self.defaultData;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return [self getDataWithCurrentSection:0 andCurrentRow:0].sectionCount;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self getDataWithCurrentSection:section andCurrentRow:0].rowCount;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SBaseTabelViewData data = [self getDataWithCurrentSection:indexPath.section andCurrentRow:indexPath.row];
    
    NSString *key = data.rowIdentifier;
    if (![self.registerCellDic valueForKeyPath:key]) {
        Class class = data.rowType;
        
        if (data.isXibCell) {
            UINib *nib = [UINib nibWithNibName:NSStringFromClass(data.rowType) bundle:nil];
            [self.tableView registerNib:nib forCellReuseIdentifier:data.rowIdentifier];
        }else{
            [self.tableView registerClass:class forCellReuseIdentifier:key];
        }
        [self.registerCellDic setValue:class forKey:key];
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:key forIndexPath:indexPath];
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:KBASETABLEVIEWDEFAULTCELLID forIndexPath:indexPath];
        DLOG(@"🌶🌶🌶：\n    baseTableView dequeueCell 为空：【key：%@】\n【cellClass：%@】",key,data.rowType);
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//MARK: delegate
- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.tableViewDataSource respondsToSelector:@selector(baseTableView:willDisplayCell:forRowAtIndexPath: andData:)]) {
        SBaseTabelViewData data = [self getDataWithCurrentSection:indexPath.section andCurrentRow:indexPath.row];
        
        if (!self.isHiddenSeparatorLine && [cell isKindOfClass:PYBaseTableViewCell.class]) {
            PYBaseTableViewCell *baseCell = (PYBaseTableViewCell *)cell;
            baseCell.topLineView.hidden = indexPath.row <= 0;
            baseCell.bottomLineView.hidden = indexPath.row >= data.rowCount-1;
            baseCell.separatorLineEdge = self.separatorLineEdge;
            baseCell.separatorLineH = self.separatorLineH;
            baseCell.separatorColor = self.separatorColor;
        }
        [self.tableViewDataSource baseTableView:self willDisplayCell:cell forRowAtIndexPath:indexPath andData:data];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:willDisplayHeaderView:forSection:andData:)]) {
        SBaseTabelViewData data = [self getDataWithCurrentSection:section andCurrentRow:0];
        [self.tableViewDelegate tableView:tableView willDisplayHeaderView:view forSection:section andData:data];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:willDisplayFooterView:forSection:andData:)]) {
        SBaseTabelViewData data = [self getDataWithCurrentSection:section andCurrentRow:0];
        [self.tableViewDelegate tableView:tableView willDisplayFooterView:view forSection:section andData:data];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath {
    
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:didEndDisplayingCell:forRowAtIndexPath:andData:)]) {
        SBaseTabelViewData data = [self getDataWithCurrentSection:indexPath.section andCurrentRow:indexPath.row];
        return [self.tableViewDelegate tableView:tableView didEndDisplayingCell:cell forRowAtIndexPath:indexPath andData:data];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:didEndDisplayingHeaderView:forSection:andData:)]) {
        SBaseTabelViewData data = [self getDataWithCurrentSection:section andCurrentRow:0];
        return [self.tableViewDelegate tableView:tableView didEndDisplayingHeaderView:view forSection:section andData:data];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:didEndDisplayingFooterView:forSection:andData:)]) {
        SBaseTabelViewData data = [self getDataWithCurrentSection:section andCurrentRow:0];
        return [self.tableViewDelegate tableView:tableView didEndDisplayingFooterView:view forSection:section andData:data];
    }
}

// Variable height support

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SBaseTabelViewData data = [self getDataWithCurrentSection:indexPath.section andCurrentRow:indexPath.row];
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:andData:)]) {
        return [self.tableViewDelegate tableView:tableView heightForRowAtIndexPath:indexPath andData:data];
    }
    return data.rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    SBaseTabelViewData data = [self getDataWithCurrentSection:section andCurrentRow:0];
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:heightForHeaderInSection:andData:)]) {
        return [self.tableViewDelegate tableView:tableView heightForHeaderInSection:section andData:data];
    }
    return data.headerHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    SBaseTabelViewData data = [self getDataWithCurrentSection:section andCurrentRow:0];
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:heightForFooterInSection:andData:)]) {
        return [self.tableViewDelegate tableView:tableView heightForFooterInSection:section andData:data];
    }
    return data.footerHeight;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SBaseTabelViewData data = [self getDataWithCurrentSection:section andCurrentRow:0];
    NSString *key = data.headerIdentifier;
    if (![self.registerHeaderDic valueForKey:key]) {
        [self.registerHeaderDic setValue:data.headerType forKey:key];
        [tableView registerClass:data.headerType forHeaderFooterViewReuseIdentifier:key];
    }
    UIView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:key];
    return view;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    SBaseTabelViewData data = [self getDataWithCurrentSection:section andCurrentRow:0];
    NSString *key = data.footerIdentifier;
    if (![self.registerFooterDic valueForKey:key]) {
        [self.registerFooterDic setValue:data.footerType forKey:key];
        [tableView registerClass:data.footerType forHeaderFooterViewReuseIdentifier:key];
    }
    UIView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:key];
    
    return view;
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:accessoryButtonTappedForRowWithIndexPath:andData:)]) {
        SBaseTabelViewData data = [self getDataWithCurrentSection:indexPath.section andCurrentRow:indexPath.row];
        [self.tableViewDelegate tableView:tableView accessoryButtonTappedForRowWithIndexPath:indexPath andData:data];
    }
}


- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:shouldHighlightRowAtIndexPath:andData:)]) {
        SBaseTabelViewData data = [self getDataWithCurrentSection:indexPath.section andCurrentRow:indexPath.row];
        return [self.tableViewDelegate tableView:tableView shouldHighlightRowAtIndexPath:indexPath andData:data];
    }
    return true;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:didHighlightRowAtIndexPath:andData:)]) {
        SBaseTabelViewData data = [self getDataWithCurrentSection:indexPath.section andCurrentRow:indexPath.row];
        [self.tableViewDelegate tableView:tableView didHighlightRowAtIndexPath:indexPath andData:data];
    }
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:didUnhighlightRowAtIndexPath:andData:)]) {
        SBaseTabelViewData data = [self getDataWithCurrentSection:indexPath.section andCurrentRow:indexPath.row];
        [self.tableViewDelegate tableView:tableView didUnhighlightRowAtIndexPath:indexPath andData:data];
    }
}

- (nullable NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:didUnhighlightRowAtIndexPath:andData:)]) {
        SBaseTabelViewData data = [self getDataWithCurrentSection:indexPath.section andCurrentRow:indexPath.row];
        [self.tableViewDelegate tableView:tableView didUnhighlightRowAtIndexPath:indexPath andData:data];
    }
    return indexPath;
}

- (nullable NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:willDeselectRowAtIndexPath:andData:)]) {
        SBaseTabelViewData data = [self getDataWithCurrentSection:indexPath.section andCurrentRow:indexPath.row];
        [self.tableViewDelegate tableView:tableView willDeselectRowAtIndexPath:indexPath andData:data];
    }
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:andData:)]) {
        SBaseTabelViewData data = [self getDataWithCurrentSection:indexPath.section andCurrentRow:indexPath.row];
        [self.tableViewDelegate tableView:tableView didSelectRowAtIndexPath:indexPath andData:data];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:didDeselectRowAtIndexPath:andData:)]) {
        SBaseTabelViewData data = [self getDataWithCurrentSection:indexPath.section andCurrentRow:indexPath.row];
        [self.tableViewDelegate tableView:tableView didDeselectRowAtIndexPath:indexPath andData:data];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:editingStyleForRowAtIndexPath:andData:)]) {
        SBaseTabelViewData data = [self getDataWithCurrentSection:indexPath.section andCurrentRow:indexPath.row];
        return [self.tableViewDelegate tableView:tableView editingStyleForRowAtIndexPath:indexPath andData:data];
    }
    return UITableViewCellEditingStyleNone;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:titleForDeleteConfirmationButtonForRowAtIndexPath:andData:)]) {
        SBaseTabelViewData data = [self getDataWithCurrentSection:indexPath.section andCurrentRow:indexPath.row];
        return [self.tableViewDelegate tableView:tableView titleForDeleteConfirmationButtonForRowAtIndexPath:indexPath andData:data];
    }
    return nil;
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:editActionsForRowAtIndexPath:andData:)]) {
        SBaseTabelViewData data = [self getDataWithCurrentSection:indexPath.section andCurrentRow:indexPath.row];
        [self.tableViewDelegate tableView:tableView editActionsForRowAtIndexPath:indexPath andData:data];
    }
    return nil;
}

- (nullable UISwipeActionsConfiguration *)tableView:(UITableView *)tableView leadingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath  API_AVAILABLE(ios(11.0)){
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:leadingSwipeActionsConfigurationForRowAtIndexPath:andData:)]) {
        SBaseTabelViewData data = [self getDataWithCurrentSection:indexPath.section andCurrentRow:indexPath.row];
        if (@available(iOS 11.0, *)) {
            return [self.tableViewDelegate tableView:tableView leadingSwipeActionsConfigurationForRowAtIndexPath:indexPath andData:data];
            
        }
    }
    return nil;
}

- (nullable UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(tvos) {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:trailingSwipeActionsConfigurationForRowAtIndexPath:andData:)]) {
        SBaseTabelViewData data = [self getDataWithCurrentSection:indexPath.section andCurrentRow:indexPath.row];
        if (@available(iOS 11.0, *)) {
            return [self.tableViewDelegate tableView:tableView trailingSwipeActionsConfigurationForRowAtIndexPath:indexPath andData:data];
            
        }
    }
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:shouldIndentWhileEditingRowAtIndexPath:andData:)]) {
        SBaseTabelViewData data = [self getDataWithCurrentSection:indexPath.section andCurrentRow:indexPath.row];
        return [self.tableViewDelegate tableView:tableView shouldIndentWhileEditingRowAtIndexPath:indexPath andData:data];
        
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:willBeginEditingRowAtIndexPath:andData:)]) {
        SBaseTabelViewData data = [self getDataWithCurrentSection:indexPath.section andCurrentRow:indexPath.row];
        [self.tableViewDelegate tableView:tableView willBeginEditingRowAtIndexPath:indexPath andData:data];
        
    }
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(nullable NSIndexPath *)indexPath {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:didEndEditingRowAtIndexPath:andData:)]) {
        SBaseTabelViewData data = [self getDataWithCurrentSection:indexPath.section andCurrentRow:indexPath.row];
        [self.tableViewDelegate tableView:tableView didEndEditingRowAtIndexPath:indexPath andData:data];
        
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:didEndEditingRowAtIndexPath:andData:)]) {
        SBaseTabelViewData fromData = [self getDataWithCurrentSection:sourceIndexPath.section andCurrentRow:sourceIndexPath.row];
        SBaseTabelViewData toData = [self getDataWithCurrentSection:proposedDestinationIndexPath.section andCurrentRow:proposedDestinationIndexPath.row];
        return [self.tableViewDelegate tableView:tableView targetIndexPathForMoveFromRowAtIndexPath:sourceIndexPath toProposedIndexPath:proposedDestinationIndexPath andFromData:fromData andToData:toData];
        
    }
    return proposedDestinationIndexPath;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0;
}

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(5_0) {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:shouldShowMenuForRowAtIndexPath:andData:)]) {
        SBaseTabelViewData data = [self getDataWithCurrentSection:indexPath.section andCurrentRow:indexPath.row];
        return [self.tableViewDelegate tableView:tableView shouldShowMenuForRowAtIndexPath:indexPath andData:data];
    }
    return false;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender NS_AVAILABLE_IOS(5_0) {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:canPerformAction:forRowAtIndexPath:withSender:andData:)]) {
        SBaseTabelViewData data = [self getDataWithCurrentSection:indexPath.section andCurrentRow:indexPath.row];
        return [self.tableViewDelegate tableView:tableView canPerformAction:action forRowAtIndexPath:indexPath withSender:sender andData:data];
    }
    return true;
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender NS_AVAILABLE_IOS(5_0) {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:performAction:forRowAtIndexPath:withSender:andData:)]) {
        SBaseTabelViewData data = [self getDataWithCurrentSection:indexPath.section andCurrentRow:indexPath.row];
        [self.tableViewDelegate tableView:tableView performAction:action forRowAtIndexPath:indexPath withSender:sender andData:data];
    }
}

- (BOOL)tableView:(UITableView *)tableView canFocusRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(9_0) {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:canFocusRowAtIndexPath:andData:)]) {
        SBaseTabelViewData data = [self getDataWithCurrentSection:indexPath.section andCurrentRow:indexPath.row];
        [self.tableViewDelegate tableView:tableView canFocusRowAtIndexPath:indexPath andData:data];
    }
    return true;
}

- (BOOL)tableView:(UITableView *)tableView shouldUpdateFocusInContext:(UITableViewFocusUpdateContext *)context NS_AVAILABLE_IOS(9_0) {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:canFocusRowAtIndexPath:andData:)]) {
        [self.tableViewDelegate tableView:tableView shouldUpdateFocusInContext:context];
    }
    return true;
}

- (void)tableView:(UITableView *)tableView didUpdateFocusInContext:(UITableViewFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator NS_AVAILABLE_IOS(9_0) {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:didUpdateFocusInContext:withAnimationCoordinator:)]) {
        [self.tableViewDelegate tableView:tableView didUpdateFocusInContext:context withAnimationCoordinator:coordinator];
    }
}

- (nullable NSIndexPath *)indexPathForPreferredFocusedViewInTableView:(UITableView *)tableView NS_AVAILABLE_IOS(9_0) {
    if ([self.tableViewDelegate respondsToSelector:@selector(indexPathForPreferredFocusedViewInTableView:)]) {
        return [self.tableViewDelegate indexPathForPreferredFocusedViewInTableView:tableView];
    }
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView shouldSpringLoadRowAtIndexPath:(NSIndexPath *)indexPath withContext:(id<UISpringLoadedInteractionContext>)context API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(tvos, watchos) {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:shouldSpringLoadRowAtIndexPath:withContext:)]) {
        return [self.tableViewDelegate tableView:tableView shouldSpringLoadRowAtIndexPath:indexPath withContext:context];
    }
    return false;
}

// MARK: - get || set

- (PYBaseScrollItemViewFrameHandler *)itemViewFrameHandler {
    if (!_itemViewFrameHandler) {
        _itemViewFrameHandler = [[PYBaseScrollItemViewFrameHandler alloc]initWithScrollView:self.tableView];
        __weak typeof(self)weakSelf = self;
        [_itemViewFrameHandler getSectionItemCount:^NSInteger(NSInteger section) {
            return [weakSelf tableView:weakSelf.tableView
                 numberOfRowsInSection:section];
        }];
        [_itemViewFrameHandler getHeaderH:^CGFloat(NSInteger section) {
            return [weakSelf tableView:weakSelf.tableView
              heightForHeaderInSection:section];
        }];
        [_itemViewFrameHandler getFooterH:^CGFloat(NSInteger section) {
            return [weakSelf tableView:weakSelf.tableView
              heightForFooterInSection:section];
        }];
        [_itemViewFrameHandler getItemH:^CGFloat(NSIndexPath * _Nonnull indexPath) {
            return [weakSelf tableView:weakSelf.tableView
               heightForRowAtIndexPath:indexPath];
        }];
    }
    return _itemViewFrameHandler;
}

- (CGRect) getHeaderFrameWithSection: (NSInteger) section {
    return [self.itemViewFrameHandler getHeaderFrameWithSection:section];
}

- (CGRect) getFooterFrameWithSection: (NSInteger) section {
    return [self.itemViewFrameHandler getFooterFrameWithSection:section];
}

- (CGRect) getItemFrameWithIndexPath: (NSIndexPath *)indexPath {
    return [self.itemViewFrameHandler getItemFrameWithIndexPath:indexPath];
}

- (void)shouldRecognizeSimultaneouslyWithGestureRecognizer:(BOOL (^)(UIGestureRecognizer * _Nonnull, UIGestureRecognizer * _Nonnull))block {
    [self.tableView shouldRecognizeSimultaneouslyWithGestureRecognizerFunc:block];
}
@end
