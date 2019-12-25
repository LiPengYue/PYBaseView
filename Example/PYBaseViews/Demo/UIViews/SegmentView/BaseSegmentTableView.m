//
//  BaseSegmentTableView.m
//  PYBaseViews_Example
//
//  Created by 李鹏跃 on 2019/12/24.
//  Copyright © 2019 Lyman Li. All rights reserved.

//** 核心借鉴 【MFNestTableView】 感谢 **/
//git: https://github.com/lmf12/MFNestTableView

#import "BaseSegmentTableView.h"
#import <PYBaseView.h>
#import "PYBaseSegmentHandler.h"
@interface BaseSegmentTableView()
<UIGestureRecognizerDelegate>

@property (nonatomic,strong) PYBaseSegmentHandler *segmentHandler;
@end

@implementation BaseSegmentTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self registerShouldRecognizeEvent];
    }
    return self;
}

- (void) registerShouldRecognizeEvent {
    __weak typeof(self)weakSelf = self;
    [self shouldRecognizeSimultaneouslyWithGestureRecognizer:^BOOL(UIGestureRecognizer * _Nonnull gestureRecognizer, UIGestureRecognizer * _Nonnull otherGestureRecognizer) {
        return [weakSelf.segmentHandler shouldRecognizeSimultaneouslyWithGestureRecognizer:gestureRecognizer andOtherRecognizer:otherGestureRecognizer];
    }];
}

- (PYBaseSegmentHandler *)segmentHandler {
    if (!_segmentHandler) {
        _segmentHandler = [PYBaseSegmentHandler new];
        _segmentHandler.segmentTableView = self.tableView;
    }
    return _segmentHandler;
}

- (void) setTopSpacing:(CGFloat)topSpacing {
    _topSpacing = topSpacing;
    self.segmentHandler.topSpacing = topSpacing;
}

- (void) setItemsHeight:(CGFloat)itemsHeight {
    _itemsHeight = itemsHeight;
    self.segmentHandler.itemsHeight = itemsHeight;
}

- (void) registerContentWithView:(UIView *)contentView
       andContentInnerScrollView:(UIScrollView *)scrollView {
    [self.segmentHandler registerContentWithView:contentView andContentInnerScrollView:scrollView];
}


@end
