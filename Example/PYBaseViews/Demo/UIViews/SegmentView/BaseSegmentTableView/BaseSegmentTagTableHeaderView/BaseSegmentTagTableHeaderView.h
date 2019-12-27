//
//  BaseSegmentTagTableHeaderView.h
//  PYBaseViews_Example
//
//  Created by 李鹏跃 on 2019/12/24.
//  Copyright © 2019 Lyman Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSegmentTagView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseSegmentTagTableHeaderView : UITableViewHeaderFooterView
@property (nonatomic,strong) BaseSegmentTagView *tagView;
@property (nonatomic,assign) UIEdgeInsets tagViewEdgeInsets;

@property (nonatomic,weak) id<BaseSegmentTagViewDelegate>delegate;
/// modelArray 直接传递到 tagView中 然后 reloadData
@property (nonatomic,strong) NSArray <id> *modelArray;

/// 是否可以重复点击 默认为 NO
@property (nonatomic,assign) BOOL isRepeatSetIndex;

/// 需要通过 scrollToIndex: 设置
@property (nonatomic,assign,readonly) NSInteger currentSelectedIndex;
@property (nonatomic,assign,readonly) NSInteger lastSelectedIndex;

- (void) scrollToIndex:(NSInteger) index andAnimated:(BOOL)isAnimated;
/// 是否应该 选中点击到index 如果返回是 则 调用·scrollToIndex：·
- (void) shouldSelectedIndex: (BOOL(^)(NSInteger selectedIndex))block;
@end
NS_ASSUME_NONNULL_END
