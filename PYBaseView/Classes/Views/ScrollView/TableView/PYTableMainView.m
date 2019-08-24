
#import "PYTableMainView.h"

#import "PYBaseTableViewCell.h"

#ifdef DEBUG
#    define DLOG(...) NSLog(__VA_ARGS__)
#else
#    define DLOG(...)
#endif

@interface PYTableMainView()
/// 已经注册的cell
@property (nonatomic,strong) NSMutableDictionary *registerCellDic;
@property (nonatomic,strong) NSMutableDictionary *registerHeaderDic;
@property (nonatomic,strong) NSMutableDictionary *registerFooterDic;

@property (nonatomic,assign) SBaseTabelViewData defaultData;

@property (nonatomic,strong) NSMutableDictionary <NSString *,NSValue *>* currentIndexPathFrameCache;
@property (nonatomic,strong) NSMutableDictionary <NSString *,NSValue *>* currentSectionHeaderFrameCache;
@property (nonatomic,strong) NSMutableDictionary <NSString *,NSValue *>* currentSectionFooterFrameCache;

@end
/// cellID
static NSString *const KBASETABLEVIEWDEFAULTCELLID = @"KBASETABLEVIEWDEFAULTCELLID";
/// headerID
static NSString *const KBASETABLEVIEWDEFAULTHEADERID = @"KBASETABLEVIEWDEFAULTHEADERID";
/// footerID
static NSString *const KBASETABLEVIEWDEFAULTFOOTERID = @"KBASETABLEVIEWDEFAULTFOOTERID";
@implementation PYTableMainView

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
    [self.currentIndexPathFrameCache removeAllObjects];
    [self.currentSectionHeaderFrameCache removeAllObjects];
    [self.currentSectionFooterFrameCache removeAllObjects];
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
            if (nib) {
                [self.tableView registerNib:nib forCellReuseIdentifier:data.rowIdentifier];
            }else{
                [self.tableView registerClass:class forCellReuseIdentifier:key];
            }
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

//- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    if ([self.tableViewDataSource respondsToSelector:@selector(tableView:titleForHeaderInSection:andData:)]) {
//        SBaseTabelViewData data = [self getDataWithCurrentSection:section andCurrentRow:0];
//        return [self.tableViewDataSource tableView:tableView titleForHeaderInSection:section andData:data];
//    }
//    return nil;
//}
//
//- (nullable NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
//    if ([self.tableViewDataSource respondsToSelector:@selector(tableView:titleForFooterInSection:andData:)]) {
//        SBaseTabelViewData data = [self getDataWithCurrentSection:section andCurrentRow:0];
//        return [self.tableViewDataSource tableView:tableView titleForFooterInSection:section andData:data];
//    }
//    return nil;
//}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    if ([self.tableViewDataSource respondsToSelector:@selector(tableView:canEditRowAtIndexPath:andData:)]) {
//        SBaseTabelViewData data = [self getDataWithCurrentSection:indexPath.section andCurrentRow:indexPath.row];
//        return [self.tableViewDataSource tableView:tableView canEditRowAtIndexPath:indexPath andData:data];
//    }
//    return true;
//}

//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
//    if ([self.tableViewDataSource respondsToSelector:@selector(tableView:canMoveRowAtIndexPath:andData:)]) {
//
//        SBaseTabelViewData data = [self getDataWithCurrentSection:indexPath.section andCurrentRow:indexPath.row];
//        [self.tableViewDataSource tableView:tableView canMoveRowAtIndexPath:indexPath andData:data];
//    }
//    return false;
//}

//- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    if ([self.tableViewDataSource respondsToSelector:@selector(sectionIndexTitlesForTableView:andData:)]) {
//        SBaseTabelViewData data = [self getDataWithCurrentSection:0 andCurrentRow:0];
//     return [self.tableViewDataSource sectionIndexTitlesForTableView:tableView andData:data];
//    }
//    return nil;
//}

//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
//    if ([self.tableViewDataSource respondsToSelector:@selector(tableView:sectionForSectionIndexTitle:atIndex:andData:)]) {
//        SBaseTabelViewData data = [self getDataWithCurrentSection:index andCurrentRow:0];
//        return [self.tableViewDataSource tableView:tableView sectionForSectionIndexTitle:title atIndex:index andData:data];
//    }
//    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
//}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if ([self.tableViewDataSource respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:andData:)]) {
//        SBaseTabelViewData data = [self getDataWithCurrentSection:indexPath.section andCurrentRow:indexPath.row];
//        [self.tableViewDataSource tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath andData:data];
//    }
//}

//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
//    if ([self.tableViewDataSource respondsToSelector:@selector(tableView:moveRowAtIndexPath:toIndexPath:andFromData:andToData:)]) {
//            SBaseTabelViewData fromData = [self getDataWithCurrentSection:sourceIndexPath.section andCurrentRow:sourceIndexPath.row];
//        SBaseTabelViewData toData = [self getDataWithCurrentSection:destinationIndexPath.section andCurrentRow:destinationIndexPath.row];
//        return [self.tableViewDataSource tableView:tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath andFromData:fromData andToData:toData];
//    }
//}


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
        [self.tableViewDelegate tableView:self willDisplayHeaderView:view forSection:section andData:data];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:willDisplayFooterView:forSection:andData:)]) {
        SBaseTabelViewData data = [self getDataWithCurrentSection:section andCurrentRow:0];
        [self.tableViewDelegate tableView:self willDisplayFooterView:view forSection:section andData:data];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath {
    
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:didEndDisplayingCell:forRowAtIndexPath:andData:)]) {
        SBaseTabelViewData data = [self getDataWithCurrentSection:indexPath.section andCurrentRow:indexPath.row];
        return [self.tableViewDelegate tableView:self didEndDisplayingCell:cell forRowAtIndexPath:indexPath andData:data];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:didEndDisplayingHeaderView:forSection:andData:)]) {
        SBaseTabelViewData data = [self getDataWithCurrentSection:section andCurrentRow:0];
        return [self.tableViewDelegate tableView:self didEndDisplayingHeaderView:view forSection:section andData:data];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:didEndDisplayingFooterView:forSection:andData:)]) {
        SBaseTabelViewData data = [self getDataWithCurrentSection:section andCurrentRow:0];
        return [self.tableViewDelegate tableView:self didEndDisplayingFooterView:view forSection:section andData:data];
    }
}

// Variable height support

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SBaseTabelViewData data = [self getDataWithCurrentSection:indexPath.section andCurrentRow:indexPath.row];
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:andData:)]) {
        return [self.tableViewDelegate tableView:self heightForRowAtIndexPath:indexPath andData:data];
    }
    return data.rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    SBaseTabelViewData data = [self getDataWithCurrentSection:section andCurrentRow:0];
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:heightForHeaderInSection:andData:)]) {
        return [self.tableViewDelegate tableView:self heightForHeaderInSection:section andData:data];
    }
    return data.headerHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    SBaseTabelViewData data = [self getDataWithCurrentSection:section andCurrentRow:0];
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:heightForFooterInSection:andData:)]) {
        return [self.tableViewDelegate tableView:self heightForFooterInSection:section andData:data];
    }
    return data.footerHeight;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SBaseTabelViewData data = [self getDataWithCurrentSection:section andCurrentRow:0];
    NSString *key = data.headerIdentifier;
    if (key.length <= 0) {
        key = NSStringFromClass(data.headerType);
    }
    if (key.length <= 0) {
        return nil;
    }
    if (![self.registerHeaderDic valueForKey:key]) {
        [self.registerHeaderDic setValue:data.headerType forKey:key];
        if (data.isXibHeader) {
            UINib *nib = [UINib nibWithNibName:NSStringFromClass(data.headerType) bundle:nil];
            if (nib) {
                [self.tableView registerNib:nib forHeaderFooterViewReuseIdentifier:key];
            }else{
                [tableView registerClass:data.headerType forHeaderFooterViewReuseIdentifier:key];
            }
        }else{
            [tableView registerClass:data.headerType forHeaderFooterViewReuseIdentifier:key];
        }
    }
    UIView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:key];
    return view;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    SBaseTabelViewData data = [self getDataWithCurrentSection:section andCurrentRow:0];
    NSString *key = data.footerIdentifier;
    if (key.length <= 0) {
        key = NSStringFromClass(data.footerType);
    }
    if (key.length <= 0) {return nil;}
    if (![self.registerFooterDic valueForKey:key]) {
        [self.registerFooterDic setValue:data.footerType forKey:key];
        
        if (data.isXibFooter) {
            UINib *nib = [UINib nibWithNibName:NSStringFromClass(data.footerType) bundle:nil];
            if (nib) {
                [self.tableView registerNib:nib forHeaderFooterViewReuseIdentifier:key];
            }else{
                [tableView registerClass:data.footerType forHeaderFooterViewReuseIdentifier:key];
            }
        }else{
            
            [tableView registerClass:data.footerType forHeaderFooterViewReuseIdentifier:key];
        }
    }
    UIView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:key];
    
    return view;
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:accessoryButtonTappedForRowWithIndexPath:andData:)]) {
        SBaseTabelViewData data = [self getDataWithCurrentSection:indexPath.section andCurrentRow:indexPath.row];
        [self.tableViewDelegate tableView:self accessoryButtonTappedForRowWithIndexPath:indexPath andData:data];
    }
}


- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:shouldHighlightRowAtIndexPath:andData:)]) {
        SBaseTabelViewData data = [self getDataWithCurrentSection:indexPath.section andCurrentRow:indexPath.row];
        return [self.tableViewDelegate tableView:self shouldHighlightRowAtIndexPath:indexPath andData:data];
    }
    return true;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:didHighlightRowAtIndexPath:andData:)]) {
        SBaseTabelViewData data = [self getDataWithCurrentSection:indexPath.section andCurrentRow:indexPath.row];
        [self.tableViewDelegate tableView:self didHighlightRowAtIndexPath:indexPath andData:data];
    }
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:didUnhighlightRowAtIndexPath:andData:)]) {
        SBaseTabelViewData data = [self getDataWithCurrentSection:indexPath.section andCurrentRow:indexPath.row];
        [self.tableViewDelegate tableView:self didUnhighlightRowAtIndexPath:indexPath andData:data];
    }
}

- (nullable NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:didUnhighlightRowAtIndexPath:andData:)]) {
        SBaseTabelViewData data = [self getDataWithCurrentSection:indexPath.section andCurrentRow:indexPath.row];
        [self.tableViewDelegate tableView:self didUnhighlightRowAtIndexPath:indexPath andData:data];
    }
    return indexPath;
}

- (nullable NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:willDeselectRowAtIndexPath:andData:)]) {
        SBaseTabelViewData data = [self getDataWithCurrentSection:indexPath.section andCurrentRow:indexPath.row];
        [self.tableViewDelegate tableView:self willDeselectRowAtIndexPath:indexPath andData:data];
    }
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:andData:)]) {
        SBaseTabelViewData data = [self getDataWithCurrentSection:indexPath.section andCurrentRow:indexPath.row];
        [self.tableViewDelegate tableView:self didSelectRowAtIndexPath:indexPath andData:data];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:didDeselectRowAtIndexPath:andData:)]) {
        SBaseTabelViewData data = [self getDataWithCurrentSection:indexPath.section andCurrentRow:indexPath.row];
        [self.tableViewDelegate tableView:self  didDeselectRowAtIndexPath:indexPath andData:data];
    }
}

//// Allows customization of the editingStyle for a particular cell located at 'indexPath'. If not implemented, all editable cells will have UITableViewCellEditingStyleDelete set for them when the table has editing property set to YES.
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:editingStyleForRowAtIndexPath:andData:)]) {
        SBaseTabelViewData data = [self getDataWithCurrentSection:indexPath.section andCurrentRow:indexPath.row];
        return [self.tableViewDelegate tableView:self  editingStyleForRowAtIndexPath:indexPath andData:data];
    }
    return UITableViewCellEditingStyleNone;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:titleForDeleteConfirmationButtonForRowAtIndexPath:andData:)]) {
        SBaseTabelViewData data = [self getDataWithCurrentSection:indexPath.section andCurrentRow:indexPath.row];
        return [self.tableViewDelegate tableView:self  titleForDeleteConfirmationButtonForRowAtIndexPath:indexPath andData:data];
    }
    return nil;
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:editActionsForRowAtIndexPath:andData:)]) {
        SBaseTabelViewData data = [self getDataWithCurrentSection:indexPath.section andCurrentRow:indexPath.row];
        [self.tableViewDelegate tableView:self  editActionsForRowAtIndexPath:indexPath andData:data];
    }
    return nil;
}

- (nullable UISwipeActionsConfiguration *)tableView:(UITableView *)tableView leadingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath  API_AVAILABLE(ios(11.0)){
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:leadingSwipeActionsConfigurationForRowAtIndexPath:andData:)]) {
        SBaseTabelViewData data = [self getDataWithCurrentSection:indexPath.section andCurrentRow:indexPath.row];
        if (@available(iOS 11.0, *)) {
            return [self.tableViewDelegate tableView:self  leadingSwipeActionsConfigurationForRowAtIndexPath:indexPath andData:data];
            
        }
    }
    return nil;
}

- (nullable UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(tvos) {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:trailingSwipeActionsConfigurationForRowAtIndexPath:andData:)]) {
        SBaseTabelViewData data = [self getDataWithCurrentSection:indexPath.section andCurrentRow:indexPath.row];
        if (@available(iOS 11.0, *)) {
            return [self.tableViewDelegate tableView:self  trailingSwipeActionsConfigurationForRowAtIndexPath:indexPath andData:data];
            
        }
    }
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:shouldIndentWhileEditingRowAtIndexPath:andData:)]) {
        
        SBaseTabelViewData data = [self getDataWithCurrentSection:indexPath.section andCurrentRow:indexPath.row];
        return [self.tableViewDelegate tableView:self  shouldIndentWhileEditingRowAtIndexPath:indexPath andData:data];
        
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:willBeginEditingRowAtIndexPath:andData:)]) {
        SBaseTabelViewData data = [self getDataWithCurrentSection:indexPath.section andCurrentRow:indexPath.row];
        [self.tableViewDelegate tableView:self  willBeginEditingRowAtIndexPath:indexPath andData:data];
        
    }
}
- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(nullable NSIndexPath *)indexPath {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:didEndEditingRowAtIndexPath:andData:)]) {
        SBaseTabelViewData data = [self getDataWithCurrentSection:indexPath.section andCurrentRow:indexPath.row];
        [self.tableViewDelegate tableView:self  didEndEditingRowAtIndexPath:indexPath andData:data];
        
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:didEndEditingRowAtIndexPath:andData:)]) {
        SBaseTabelViewData fromData = [self getDataWithCurrentSection:sourceIndexPath.section andCurrentRow:sourceIndexPath.row];
        SBaseTabelViewData toData = [self getDataWithCurrentSection:proposedDestinationIndexPath.section andCurrentRow:proposedDestinationIndexPath.row];
        return [self.tableViewDelegate tableView:self  targetIndexPathForMoveFromRowAtIndexPath:sourceIndexPath toProposedIndexPath:proposedDestinationIndexPath andFromData:fromData andToData:toData];
        
    }
    return proposedDestinationIndexPath;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0;
}

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(5_0) {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:shouldShowMenuForRowAtIndexPath:andData:)]) {
        SBaseTabelViewData data = [self getDataWithCurrentSection:indexPath.section andCurrentRow:indexPath.row];
        return [self.tableViewDelegate tableView:self  shouldShowMenuForRowAtIndexPath:indexPath andData:data];
    }
    return false;
}
- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender NS_AVAILABLE_IOS(5_0) {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:canPerformAction:forRowAtIndexPath:withSender:andData:)]) {
        SBaseTabelViewData data = [self getDataWithCurrentSection:indexPath.section andCurrentRow:indexPath.row];
        return [self.tableViewDelegate tableView:self  canPerformAction:action forRowAtIndexPath:indexPath withSender:sender andData:data];
    }
    return true;
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender NS_AVAILABLE_IOS(5_0) {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:performAction:forRowAtIndexPath:withSender:andData:)]) {
        SBaseTabelViewData data = [self getDataWithCurrentSection:indexPath.section andCurrentRow:indexPath.row];
        [self.tableViewDelegate tableView:self  performAction:action forRowAtIndexPath:indexPath withSender:sender andData:data];
    }
}

- (BOOL)tableView:(UITableView *)tableView canFocusRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(9_0) {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:canFocusRowAtIndexPath:andData:)]) {
        SBaseTabelViewData data = [self getDataWithCurrentSection:indexPath.section andCurrentRow:indexPath.row];
        [self.tableViewDelegate tableView:self  canFocusRowAtIndexPath:indexPath andData:data];
    }
    return true;
}

- (BOOL)tableView:(UITableView *)tableView shouldUpdateFocusInContext:(UITableViewFocusUpdateContext *)context NS_AVAILABLE_IOS(9_0) {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:canFocusRowAtIndexPath:andData:)]) {
        [self.tableViewDelegate tableView:self  shouldUpdateFocusInContext:context];
    }
    return true;
}
- (void)tableView:(UITableView *)tableView didUpdateFocusInContext:(UITableViewFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator NS_AVAILABLE_IOS(9_0) {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:didUpdateFocusInContext:withAnimationCoordinator:)]) {
        [self.tableViewDelegate tableView:self  didUpdateFocusInContext:context withAnimationCoordinator:coordinator];
    }
}

- (nullable NSIndexPath *)indexPathForPreferredFocusedViewInTableView:(UITableView *)tableView NS_AVAILABLE_IOS(9_0) {
    if ([self.tableViewDelegate respondsToSelector:@selector(indexPathForPreferredFocusedViewInTableView:)]) {
        return [self.tableViewDelegate indexPathForPreferredFocusedViewInTableView:self];
    }
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView shouldSpringLoadRowAtIndexPath:(NSIndexPath *)indexPath withContext:(id<UISpringLoadedInteractionContext>)context API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(tvos, watchos) {
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:shouldSpringLoadRowAtIndexPath:withContext:)]) {
        return [self.tableViewDelegate tableView:self shouldSpringLoadRowAtIndexPath:indexPath withContext:context];
    }
    return false;
}

- (NSDictionary <NSString *, NSValue *>*) getCurrentIndexPathAnchorPointsCache {
    NSInteger sectionCount = [self numberOfSectionsInTableView:self.tableView];
    
    NSInteger rowCount = [self tableView:self.tableView numberOfRowsInSection:MAX(0,sectionCount-1)];
    
    NSIndexPath *index = [NSIndexPath indexPathForRow:rowCount inSection:sectionCount];
    [self getYIndexPathWithIndexPath:index];
    return self.currentIndexPathFrameCache;
}

- (NSMutableDictionary<NSString *,NSValue *> *)currentIndexPathFrameCache {
    if (!_currentIndexPathFrameCache) {
        _currentIndexPathFrameCache = [NSMutableDictionary new];
    }
    return _currentIndexPathFrameCache;
}

- (NSMutableDictionary<NSString *,NSValue *> *)currentSectionFooterFrameCache {
    if (!_currentSectionFooterFrameCache) {
        _currentSectionFooterFrameCache = [NSMutableDictionary new];
    }
    return _currentSectionFooterFrameCache;
}

- (NSMutableDictionary<NSString *,NSValue *> *)currentSectionHeaderFrameCache {
    if (!_currentSectionHeaderFrameCache) {
        _currentSectionHeaderFrameCache = [NSMutableDictionary new];
    }
    return _currentSectionHeaderFrameCache;
}

- (CGRect) getAnchorPointWithIndexPath: (NSIndexPath *)indexPath {
    [self getYIndexPathWithIndexPath:indexPath];
    CGRect rect = [self getCurrentIndexPathFrameCacheWithIndex:indexPath].CGRectValue;
    return rect;
}

- (CGRect) getHeaderFrameWithSection: (NSInteger) section {
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:section];
    if (![self getCurrentSectionHeaderFrameCacheWithIndex:index]) {
        CGRect footerRect = CGRectZero;
        CGFloat currentHeaderH = [self tableView:self.tableView heightForHeaderInSection:section];
        CGFloat currentHeaderY;
        if (section > 0) {
            section = section-1;
            if (section == 1) {
                
            }
            footerRect = [self getFooterFrameWithSection:section];
            currentHeaderY = CGRectGetMaxY(footerRect);
        }else{
            currentHeaderY = self.tableView.contentInset.top;
            currentHeaderY += self.tableView.tableHeaderView.frame.size.height;
        }
        
        CGFloat tableViewW = self.tableView.frame.size.width;
        
        [self setCurrentSectionHeaderFrameCache:index andHeaderRect:CGRectMake(0, currentHeaderY, tableViewW, currentHeaderH)];
    }
    return [self getCurrentSectionHeaderFrameCacheWithIndex:index].CGRectValue;
}

- (CGRect) getFooterFrameWithSection: (NSInteger) section {
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:section];
    if (![self getCurrentSectionFooterFrameCacheWithIndex:index]) {
        NSInteger rowCount = [self tableView:self.tableView  numberOfRowsInSection:section];
        NSIndexPath *index = [NSIndexPath indexPathForRow:rowCount - 1 inSection:section];
        [self getYIndexPathWithIndexPath:index];
        CGRect rowFrame = [self getCurrentIndexPathFrameCacheWithIndex:index].CGRectValue;
        CGFloat y = CGRectGetMaxY(rowFrame);
        CGFloat h = [self tableView:self.tableView heightForFooterInSection:section];
        [self setCurrentSectionFooterFrameCacheWithIndex:index andFooterRect:CGRectMake(0, y, self.tableView.frame.size.width, h)];
    }
    return [self getCurrentSectionFooterFrameCacheWithIndex:index].CGRectValue;
}

- (CGFloat) getYWithIndex: (NSIndexPath *) indexPath {
    return [self getYIndexPathWithIndexPath:indexPath];
}

- (CGFloat) getYIndexPathWithIndexPath: (NSIndexPath *)indexPath {
    CGFloat y = 0;
    CGFloat tableViewW = self.tableView.frame.size.width;
    NSInteger rowMaxCount = [self tableView:self.tableView numberOfRowsInSection:indexPath.section];
    
    if(indexPath.row <= 0 && indexPath.section <= 0) {
        CGRect headerFrame = [self getHeaderFrameWithSection:MAX(0, 0)];
        y = CGRectGetMaxY(headerFrame);
        
        CGFloat currentCellH = [self tableView:self.tableView heightForRowAtIndexPath:indexPath];
        
        [self setCurrentIndexPathFrameCacheWithIndex:indexPath andRowRect: CGRectMake(0, y, self.tableView.frame.size.width, currentCellH)];
        return y;
    }
    
    if ([self getCurrentIndexPathFrameCacheWithIndex:indexPath] != nil) {
        y = [self getCurrentIndexPathFrameCacheWithIndex:indexPath].CGRectValue.origin.y;
    }else{
        NSInteger section = indexPath.section;
        NSInteger row = indexPath.row;
        CGFloat rowHeight = [self tableView:self.tableView heightForRowAtIndexPath:indexPath];
        
        if (row <= 0) {
            // 计算header高度
            CGRect currentHeaderRect =
            [self getHeaderFrameWithSection:section];
            CGFloat currentHeaderBottom = CGRectGetMaxY(currentHeaderRect);
            y = currentHeaderBottom;
            
            
        } else{
            if (row >= rowMaxCount) {
                row = rowMaxCount - 1;
            }
            row = MAX(row - 1,0);
            NSIndexPath *frontIndex = [NSIndexPath indexPathForRow:row inSection:section];
            [self getYIndexPathWithIndexPath:frontIndex];
            CGRect frontFrame = [self getCurrentIndexPathFrameCacheWithIndex:frontIndex].CGRectValue;
            y = CGRectGetMaxY(frontFrame);
        }
        CGRect rowRect = CGRectMake(0, y, tableViewW, rowHeight);
        [self setCurrentIndexPathFrameCacheWithIndex:indexPath andRowRect:rowRect];
    }
    return y;
}

- (void) setCurrentIndexPathFrameCacheWithIndex:(NSIndexPath *)index andRowRect:(CGRect) rowRect {
    self.currentIndexPathFrameCache[[self indexCellConvertString:index]] = [NSValue valueWithCGRect:rowRect];
}

- (NSValue *) getCurrentIndexPathFrameCacheWithIndex:(NSIndexPath *)index {
    return self.currentIndexPathFrameCache[[self indexCellConvertString:index]];
}

- (void)setCurrentSectionFooterFrameCacheWithIndex:(NSIndexPath *)index andFooterRect:(CGRect) footerRect {
    self.currentSectionFooterFrameCache[[self indexFooterConvertString:index]] = [NSValue valueWithCGRect:footerRect];
}

- (NSValue *) getCurrentSectionFooterFrameCacheWithIndex: (NSIndexPath *)index {
    return self.currentSectionFooterFrameCache[[self indexFooterConvertString:index]];
}

- (void)setCurrentSectionHeaderFrameCache:(NSIndexPath *)index andHeaderRect:(CGRect) headerRect {
    self.currentSectionHeaderFrameCache[[self indexHeaderConvertString:index]] = [NSValue valueWithCGRect:headerRect];
}

- (NSValue *) getCurrentSectionHeaderFrameCacheWithIndex:(NSIndexPath *)index {
    return self.currentSectionHeaderFrameCache[[self indexHeaderConvertString:index]];
}

- (NSString *) indexHeaderConvertString: (NSIndexPath *)indexPath {
    NSString *str = [NSString stringWithFormat:@"Header:---:%ld",indexPath.section];
    return str;
}

- (NSString *) indexFooterConvertString: (NSIndexPath *)indexPath {
    NSString *str = [NSString stringWithFormat:@"Footer:---:%ld",indexPath.section];
    return str;
}

- (NSString *) indexCellConvertString: (NSIndexPath *)indexPath {
    NSString *str = [NSString stringWithFormat:@"CELL:-%ld:---:%ld",indexPath.row,indexPath.section];
    return str;
}

- (NSString *) indexCellConvertString:(NSInteger)row andSection: (NSInteger)section {
    NSString *str = [NSString stringWithFormat:@"%ld:---:%ld",row,section];
    return str;
}

@end
