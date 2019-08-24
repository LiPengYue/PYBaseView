
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PYTableMainView;
struct SBaseTabelViewData {
    /// 扩展key
    NSString * key;
    NSInteger sectionCount;
    NSInteger rowCount;
    
    Class rowType;
    Class headerType;
    Class footerType;
    
    NSString *rowIdentifier;
    NSString *headerIdentifier;
    NSString *footerIdentifier;
    
    CGFloat rowHeight;
    CGFloat rowWidth;
    CGFloat headerHeight;
    CGFloat headerWidth;
    CGFloat footerHeight;
    CGFloat footerWidth;
    
    BOOL isXibCell;
    BOOL isXibFooter;
    BOOL isXibHeader;
/// 如果 (isXibCell && length<= 0) 那么cellNibName = NSStringFromClass(rowType)
    NSString *cellNibName;
};
typedef struct SBaseTabelViewData  SBaseTabelViewData;


@protocol PYBaseTableViewDataSource <NSObject>
@required
/// 获取tableView 的布局数据 (将会频繁调用)
- (SBaseTabelViewData) getTableViewData: (PYTableMainView *)baseTableView
                      andCurrentSection: (NSInteger) section
                          andCurrentRow: (NSInteger) row;

/// cell 将要出现的时候调用
- (void) baseTableView:(PYTableMainView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath andData: (SBaseTabelViewData)data;

@optional
// fixed font style. use custom view (UILabel) if you want something different
- (nullable NSString *)tableView:(PYTableMainView *)tableView titleForHeaderInSection:(NSInteger)section  andData: (SBaseTabelViewData)data;

- (nullable NSString *)tableView:(PYTableMainView *)tableView titleForFooterInSection:(NSInteger)section  andData: (SBaseTabelViewData)data;

// Editing

// Individual rows can opt out of having the -editing property set for them. If not implemented, all rows are assumed to be editable.
- (BOOL)tableView:(PYTableMainView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath andData: (SBaseTabelViewData)data;

// Moving/reordering

// Allows the reorder accessory view to optionally be shown for a particular row. By default, the reorder control will be shown only if the datasource implements -tableView:moveRowAtIndexPath:toIndexPath:
- (BOOL)tableView:(PYTableMainView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath andData: (SBaseTabelViewData)data;

// Index
/// 右边的索引 return list of section titles to display in section index view (e.g. "ABCD...Z#")
- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(PYTableMainView *)tableView  andData: (SBaseTabelViewData)data;

/// 点击 或滑动右边的索引 需要偏移到哪一组
- (NSInteger)tableView:(PYTableMainView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index  andData: (SBaseTabelViewData)data;


- (void)tableView:(PYTableMainView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath andData: (SBaseTabelViewData)data;

- (void)tableView:(PYTableMainView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath andFromData:(SBaseTabelViewData)fromData andToData: (SBaseTabelViewData)toData;
@end


NS_INLINE SBaseTabelViewData SBaseTabelViewDataMakeDefault() {
    SBaseTabelViewData data;
    data.rowHeight = CGFLOAT_MIN;
    data.rowWidth = CGFLOAT_MIN;
    data.headerHeight = CGFLOAT_MIN;
    data.headerWidth = CGFLOAT_MIN;
    data.footerHeight = CGFLOAT_MIN;
    data.footerWidth = CGFLOAT_MIN;
    
    data.rowType = UITableViewCell.class;
    data.headerType = UITableViewHeaderFooterView.class;
    data.footerType = UITableViewHeaderFooterView.class;
    
    data.rowCount = 0;
    data.sectionCount = 1;
    data.key = @"";
    data.rowIdentifier = @"";
    data.headerIdentifier = @"";
    data.footerIdentifier = @"";
    data.isXibCell = false;
    data.isXibHeader = false;
    data.isXibFooter = false;
    data.cellNibName = @"";
    return data;
}

NS_INLINE SBaseTabelViewData SBaseTabelViewDataMake(NSInteger rowCount,CGFloat rowHeight, Class cellType, NSString *key) {
    SBaseTabelViewData data = SBaseTabelViewDataMakeDefault();
    
    data.rowWidth = CGFLOAT_MIN;
    data.headerHeight = CGFLOAT_MIN;
    data.headerWidth = CGFLOAT_MIN;
    data.footerHeight = CGFLOAT_MIN;
    data.footerWidth = CGFLOAT_MIN;
    data.isXibCell = false;
    data.cellNibName = @"";
    
    data.rowHeight = rowHeight;
    data.sectionCount = 1;
    data.rowType = cellType;
    data.rowCount = rowCount;
    data.key = key;
    return data;
}

NS_INLINE BOOL SBaseTableViewDataEqualto(SBaseTabelViewData data1,SBaseTabelViewData data2) {
    return
    data1.rowHeight == data2.rowHeight &&
    data1.rowWidth == data2.rowWidth &&
    data1.headerHeight == data2.headerHeight &&
    data1.headerWidth == data2.headerWidth &&
    data1.footerHeight == data2.footerHeight &&
    data1.footerWidth == data2.footerWidth &&
    
    [data1.rowType isEqual: data2.rowType] &&
    [data1.headerType isEqual: data2.headerType] &&
    [data1.footerType isEqual: data2.footerType] &&
    
    data1.rowCount == data2.rowCount &&
    data1.sectionCount == data2.sectionCount &&
    
    data1.isXibCell == data2.isXibCell &&
    data1.isXibFooter == data2.isXibFooter&&
    data1.isXibHeader == data2.isXibHeader&&
    
    [data1.key  isEqualToString: data2.key] &&
    [data1.rowIdentifier isEqualToString:data2.rowIdentifier] &&
    [data1.headerIdentifier isEqualToString:data2.headerIdentifier] &&
    [data1.footerIdentifier isEqualToString:data2.footerIdentifier]
    &&
    [data1.cellNibName isEqualToString:data2.cellNibName];
}

NS_INLINE BOOL SBaseTableViewDataIsDefault(SBaseTabelViewData data) {
    return SBaseTableViewDataEqualto(SBaseTabelViewDataMakeDefault(), data);
}

@interface PYBaseTableViewDataSource : UIView

@end

NS_ASSUME_NONNULL_END
