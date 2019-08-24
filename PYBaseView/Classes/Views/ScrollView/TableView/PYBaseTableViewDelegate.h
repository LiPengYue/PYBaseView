//
//  BaseTableViewDelegate.h
//  Test
//
//  Created by 衣二三 on 2019/4/15.
//  Copyright © 2019 衣二三. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PYTableMainView;
NS_ASSUME_NONNULL_BEGIN

typedef struct SBaseTabelViewData SBaseTabelViewData;

@protocol PYBaseTableViewDelegate <NSObject,UIScrollViewDelegate>
@optional
- (void)tableView:(PYTableMainView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath andData: (SBaseTabelViewData)data;

- (void)tableView:(PYTableMainView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section andData: (SBaseTabelViewData)data NS_AVAILABLE_IOS(6_0);

- (void)tableView:(PYTableMainView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section andData: (SBaseTabelViewData)data NS_AVAILABLE_IOS(6_0);

- (void)tableView:(PYTableMainView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath andData: (SBaseTabelViewData)data NS_AVAILABLE_IOS(6_0);

- (void)tableView:(PYTableMainView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section andData: (SBaseTabelViewData)data NS_AVAILABLE_IOS(6_0);

- (void)tableView:(PYTableMainView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section andData: (SBaseTabelViewData)data NS_AVAILABLE_IOS(6_0);

// Variable height support

- (CGFloat)tableView:(PYTableMainView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath andData: (SBaseTabelViewData)data;

- (CGFloat)tableView:(PYTableMainView *)tableView heightForHeaderInSection:(NSInteger)section andData: (SBaseTabelViewData)data;

- (CGFloat)tableView:(PYTableMainView *)tableView heightForFooterInSection:(NSInteger)section andData: (SBaseTabelViewData)data;

// Section header & footer information. Views are preferred over title should you decide to provide both

//- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section andData: (SBaseTabelViewData)data;   // custom view for header. will be adjusted to default or specified header height
//- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section andData: (SBaseTabelViewData)data;   // custom view for footer. will be adjusted to default or specified footer height


- (void)tableView:(PYTableMainView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath andData: (SBaseTabelViewData)data;

// Selection

// -tableView:shouldHighlightRowAtIndexPath: is called when a touch comes down on a row.
// Returning NO to that message halts the selection process and does not cause the currently selected row to lose its selected look while the touch is down.
- (BOOL)tableView:(PYTableMainView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath andData: (SBaseTabelViewData)data NS_AVAILABLE_IOS(6_0);

- (void)tableView:(PYTableMainView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath andData: (SBaseTabelViewData)data NS_AVAILABLE_IOS(6_0);

- (void)tableView:(PYTableMainView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath andData: (SBaseTabelViewData)data NS_AVAILABLE_IOS(6_0);

// Called before the user changes the selection. Return a new indexPath, or nil, to change the proposed selection.
- (nullable NSIndexPath *)tableView:(PYTableMainView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath andData: (SBaseTabelViewData)data;

- (nullable NSIndexPath *)tableView:(PYTableMainView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath andData: (SBaseTabelViewData)data NS_AVAILABLE_IOS(3_0);

// Called after the user changes the selection.
- (void)tableView:(PYTableMainView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath andData: (SBaseTabelViewData)data;

- (void)tableView:(PYTableMainView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath andData: (SBaseTabelViewData)data NS_AVAILABLE_IOS(3_0);

// Editing

// Allows customization of the editingStyle for a particular cell located at 'indexPath'. If not implemented, all editable cells will have UITableViewCellEditingStyleDelete set for them when the table has editing property set to YES.
- (UITableViewCellEditingStyle)tableView:(PYTableMainView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath andData: (SBaseTabelViewData)data;

- (nullable NSString *)tableView:(PYTableMainView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath andData: (SBaseTabelViewData)data NS_AVAILABLE_IOS(3_0) __TVOS_PROHIBITED;

// Use -tableView:trailingSwipeActionsConfigurationForRowAtIndexPath: instead of this method, which will be deprecated in a future release.
// This method supersedes -tableView:titleForDeleteConfirmationButtonForRowAtIndexPath: if return value is non-nil
- (nullable NSArray<UITableViewRowAction *> *)tableView:(PYTableMainView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath andData: (SBaseTabelViewData)data NS_AVAILABLE_IOS(8_0) __TVOS_PROHIBITED;

// Swipe actions
// These methods supersede -editActionsForRowAtIndexPath: if implemented
// return nil to get the default swipe actions
- (nullable UISwipeActionsConfiguration *)tableView:(PYTableMainView *)tableView leadingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath andData: (SBaseTabelViewData)data API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(tvos);

- (nullable UISwipeActionsConfiguration *)tableView:(PYTableMainView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath andData: (SBaseTabelViewData)data API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(tvos);

// Controls whether the background is indented while editing.  If not implemented, the default is YES.  This is unrelated to the indentation level below.  This method only applies to grouped style table views.
- (BOOL)tableView:(PYTableMainView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath andData: (SBaseTabelViewData)data;

// The willBegin/didEnd methods are called whenever the 'editing' property is automatically changed by the table (allowing insert/delete/move). This is done by a swipe activating a single row
- (void)tableView:(PYTableMainView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath andData: (SBaseTabelViewData)data __TVOS_PROHIBITED;
- (void)tableView:(PYTableMainView *)tableView didEndEditingRowAtIndexPath:(nullable NSIndexPath *)indexPath andData: (SBaseTabelViewData)data __TVOS_PROHIBITED;

// Moving/reordering

// Allows customization of the target row for a particular row as it is being moved/reordered
- (NSIndexPath *)tableView:(PYTableMainView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath andFromData: (SBaseTabelViewData)fromData andToData:(SBaseTabelViewData) toData;

// Indentation

- (NSInteger)tableView:(PYTableMainView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath andData: (SBaseTabelViewData)data; // return 'depth' of row for hierarchies

// Copy/Paste.  All three methods must be implemented by the delegate.

- (BOOL)tableView:(PYTableMainView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath andData: (SBaseTabelViewData)data NS_AVAILABLE_IOS(5_0);
- (BOOL)tableView:(PYTableMainView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender andData: (SBaseTabelViewData)data NS_AVAILABLE_IOS(5_0);
- (void)tableView:(PYTableMainView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender andData: (SBaseTabelViewData)data NS_AVAILABLE_IOS(5_0);

// Focus

- (BOOL)tableView:(PYTableMainView *)tableView canFocusRowAtIndexPath:(NSIndexPath *)indexPath andData: (SBaseTabelViewData)data NS_AVAILABLE_IOS(9_0);
- (BOOL)tableView:(PYTableMainView *)tableView shouldUpdateFocusInContext:(UITableViewFocusUpdateContext *)context NS_AVAILABLE_IOS(9_0);
- (void)tableView:(PYTableMainView *)tableView didUpdateFocusInContext:(UITableViewFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator NS_AVAILABLE_IOS(9_0);
- (nullable NSIndexPath *)indexPathForPreferredFocusedViewInTableView:(PYTableMainView *)tableView NS_AVAILABLE_IOS(9_0);

// Spring Loading

// Allows opting-out of spring loading for an particular row.
// If you want the interaction effect on a different subview of the spring loaded cell, modify the context.targetView property. The default is the cell.
// If this method is not implemented, the default is YES except when the row is part of a drag session.
- (BOOL)tableView:(PYTableMainView *)tableView shouldSpringLoadRowAtIndexPath:(NSIndexPath *)indexPath withContext:(id<UISpringLoadedInteractionContext>)context API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(tvos, watchos);
@required


@end

@interface PYBaseTableViewDelegateHandler : NSObject

@end
NS_ASSUME_NONNULL_END
