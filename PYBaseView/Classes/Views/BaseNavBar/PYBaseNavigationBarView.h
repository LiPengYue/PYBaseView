//
//  PYBaseNavigationBarView.h
//  FBSnapshotTestCase
//
//  Created by 衣二三 on 2019/8/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ClickNavTitle)(UIButton *button);
typedef void(^CliekNavItem)(UIButton *button,NSInteger index);

@interface PYBaseNavigationBarView : UIView

/**
 刷新UI
 */
- (void) reloadView;

- (void) setUpWeakSelfFunc: (void(^)(PYBaseNavigationBarView *weak))block;

/** 左边的buttons */
@property (nonatomic,strong,readonly) NSArray <UIButton *>*leftItems;
/** 右边的buttons */
@property (nonatomic,strong,readonly) NSArray <UIButton *>*rightItems;
/**
 title
 替换 这个view 来 自定义 titleLabel
 */
@property (nonatomic,strong) UIButton *titleButton;

#pragma mark - 插入item
- (PYBaseNavigationBarView *(^)(UIButton *button)) addLeftItem;
- (PYBaseNavigationBarView *(^)(UIButton *button)) addRightItem;

// MARK: 根据 str 与 image 创建Button 并添加到数组
- (PYBaseNavigationBarView *(^)(NSString *str,UIImage *image)) addLeftItemWithTitleAndImg;
- (PYBaseNavigationBarView *(^)(NSString *str,UIImage *image)) addRightItemWithTitleAndImg;
- (PYBaseNavigationBarView *(^)(NSString *str,UIImage *image)) addTitleItemWithTitleAndImg;

// MARK: 根据 attributedStr 创建button 并添加到数组
- (PYBaseNavigationBarView *(^)(NSAttributedString *str)) addLeftItemWithAttributedStr;
- (PYBaseNavigationBarView *(^)(NSAttributedString *str)) addRightItemWithAttributedStr;
- (PYBaseNavigationBarView *(^)(NSAttributedString *str)) addTitleItemWithAttributedStr;


- (PYBaseNavigationBarView *) insertLeftItem: (UIButton *)button
                                    andIndex: (NSInteger)index;
- (PYBaseNavigationBarView *) insertRightItem: (UIButton *)button
                                     andIndex: (NSInteger)index;

- (PYBaseNavigationBarView *) removeLeftItemWithIndex: (NSInteger) index;
- (PYBaseNavigationBarView *) removeRightItemWithIndex: (NSInteger) index;
- (PYBaseNavigationBarView *) removeLeftAll;
- (PYBaseNavigationBarView *) removeRightAll;

#pragma mark - 点击事件
/** 点击了左边的按钮 */
- (void) clickLeftButtonFunc: (CliekNavItem) clickLeftItem;
/** 点击了右边的按钮 */
- (void) clickRightButtonFunc: (CliekNavItem) clickRightItem;
/** 点击了中间title的按钮 */
- (void) clickTitleButtonFunc: (ClickNavTitle) clickTitle;

#pragma layout

/** 最左边item左边的间距  默认为14*/
@property (nonatomic,assign) CGFloat leftItemLeftSpacing;

/** 最右边item右边的间距  默认为14*/
@property (nonatomic,assign) CGFloat rightItemRightSpacing;

/** title 底部的间距 默认为5 */
@property (nonatomic,assign) CGFloat titleBottomSpacing;

/** item 底部的间距，默认为-1（如果小于0 则 与title conter.y对齐）*/
@property (nonatomic,assign) CGFloat itemBottomSpacing;

/** item 之间最小的间距 默认为14pt */
@property (nonatomic,assign) CGFloat itemsMinMargin;

/** item 的高度 默认为24pt */
@property (nonatomic,assign) CGFloat itemHeight;
/**item 的最小宽度 默认为44*/
@property (nonatomic,assign) CGFloat itemMinWidth;
/** titleButton 的size */
@property (nonatomic,assign)CGFloat  titleButtonWidth;
@property (nonatomic,assign) CGFloat titleButtonHeight;

- (UIButton *) getLeftItemWithIndex: (NSInteger) index;
- (UIButton *) getRightItemWithIndex: (NSInteger) index;

#pragma mark - bottom line
@property (nonatomic,strong) UIView *bottomLineView;
@property (nonatomic,assign) BOOL isHiddenBottomLine;
/// bottomLineH
@property (nonatomic,assign) CGFloat bottomLineH;
@property (nonatomic,assign) CGFloat bottomLineRightSpacing;
@property (nonatomic,assign) CGFloat bottomLineLeftSpacing;

#pragma mark - 阴影
@property (nonatomic,assign) BOOL isHiddenShadow;
@property (nonatomic,strong) CALayer *shadowLayer;


@property (nonatomic,strong) UIFont *titleFont;
@property (nonatomic,strong) UIFont *leftItemTextFont;
@property (nonatomic,strong) UIFont *rightItemTextFont;

/// item 子view 的对齐方式
@property (nonatomic,assign) UIControlContentVerticalAlignment leftVericalAlignment;
@property (nonatomic,assign) UIControlContentVerticalAlignment rightVericalAlignment;
@property (nonatomic,assign) UIControlContentVerticalAlignment titleVericalAlignment;

@property (nonatomic,assign) UIControlContentHorizontalAlignment leftHorizontalAlignment;
@property (nonatomic,assign) UIControlContentHorizontalAlignment rightHorizontalAlignment;
@property (nonatomic,assign) UIControlContentHorizontalAlignment titleHorizontalAlignment;

@end

NS_ASSUME_NONNULL_END
