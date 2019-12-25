//
//  PYBaseSegmentHandler.m
//  PYBaseViews_Example
//
//  Created by 衣二三 on 2019/12/25.
//  Copyright © 2019 LiPengYue. All rights reserved.
//

#import "PYBaseSegmentHandler.h"
#import <PYBaseView.h>

@interface PYBaseSegmentHandler()
<
UIScrollViewDelegate,
UIGestureRecognizerDelegate
>
/// 内容是否可以滑动
@property (nonatomic,assign) BOOL canScrollWithContentScrollView;
/// self 是否可以滑动
@property (nonatomic,assign) BOOL canScrollWithSegmentTableView;

@property (nonatomic,assign) CGFloat totalTopSpacing;

@property (nonatomic,strong) NSMutableArray <UIView *> *contentViewArray;
@property (nonatomic,strong) NSMutableDictionary <NSString *,ScrollViewPanDirectionHandler *> *contentScrollViewHandlerDic;
@property (nonatomic,strong) ScrollViewPanDirectionHandler *segmentTableViewPanHandler;
@end

@implementation PYBaseSegmentHandler

- (instancetype)init {
    self = [super init];
    if (self) {
        self.canScrollWithSegmentTableView = true;
    }
    return self;
}

/// 注册 透传 手势 事件【解决手势冲突】
- (BOOL) shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *) gestureRecognizer andOtherRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    UIView *view = otherGestureRecognizer.view;
    if (self.contentViewArray && ([self.contentViewArray containsObject:view] || [self.contentViewArray containsObject:[view superview]])) {
        return true;
    }
    return false;
}

- (void)setSegmentTableView:(UITableView *)segmentTableView {
    if ([segmentTableView isEqual:self.segmentTableView]) {
        return;
    }
    _segmentTableView = segmentTableView;
    self.segmentTableViewPanHandler.scrollView = segmentTableView;
}

- (ScrollViewPanDirectionHandler *)segmentTableViewPanHandler {
    if (!_segmentTableViewPanHandler) {
        _segmentTableViewPanHandler = [ScrollViewPanDirectionHandler new];
        __weak typeof(self)weakSelf = self;
        [_segmentTableViewPanHandler scrollViewDidScrollCallBack:^(CGPoint lodOffset, CGPoint newOffset) {
            [weakSelf segmentTableViewDidScroll];
        }];
    }
    return _segmentTableViewPanHandler;
}

/// 容器视图滚动
- (void) segmentTableViewDidScroll {
    UIScrollView *scrollView = self.segmentTableView;
    CGFloat contentOffset = self.totalTopSpacing;

    if (!self.canScrollWithSegmentTableView && !CGPointEqualToPoint(scrollView.contentOffset, CGPointMake(0, contentOffset))) {
        // 这里通过固定contentOffset的值，来实现不滚动
        scrollView.contentOffset = CGPointMake(0, contentOffset);
    } else if (scrollView.contentOffset.y > contentOffset) {
        scrollView.contentOffset = CGPointMake(0, contentOffset);
        self.canScrollWithSegmentTableView = NO;
        // 横向内容 开始可以滚动
        self.canScrollWithContentScrollView = true;
    }
    scrollView.showsVerticalScrollIndicator = self.canScrollWithSegmentTableView;
}

/// 内容视图滚动
- (void) contentScrollViewDidScroll: (UIScrollView *)scrollView {
    if (!self.canScrollWithContentScrollView && CGPointEqualToPoint(scrollView.contentOffset, CGPointZero)) {
        /// 防止循环
       } else if (!self.canScrollWithContentScrollView) {
           /// 这里通过固定contentOffset，来实现不滚动
           scrollView.contentOffset = CGPointZero;
       } else if (scrollView.contentOffset.y < 0) {
           /// 内容 禁止 滚动
           self.canScrollWithContentScrollView = NO;
           /// self 开启 滚动
           self.canScrollWithSegmentTableView = true;
       }
       scrollView.showsVerticalScrollIndicator = self.canScrollWithContentScrollView;
}

// MARK: - get || set

- (NSMutableDictionary<NSString *, ScrollViewPanDirectionHandler*> *)contentScrollViewHandlerDic {
    if (!_contentScrollViewHandlerDic) {
        _contentScrollViewHandlerDic = [NSMutableDictionary new];
    }
    return _contentScrollViewHandlerDic;
}

- (NSString *) getcontentScrollViewHandlerDicKeyWithView:(UIView *)view {
    if (!view) {
        return @"ERROR";
    }
    NSInteger i = [self.contentViewArray indexOfObject:view];
    return [NSString stringWithFormat:@"%ld,%@",i,view];
}

- (UIScrollView *)getContentInnerScrollViewWithView: (UIView *)view {
    NSString *key = [self getcontentScrollViewHandlerDicKeyWithView:view];
    return self.contentScrollViewHandlerDic[key].scrollView;
}

- (NSArray<UIView *> *)contentViewArray {
    if (!_contentViewArray) {
        _contentViewArray = [NSMutableArray new];
    }
    return _contentViewArray;
}

- (void) registerContentWithView:(UIView *)contentView
       andContentInnerScrollView:(UIScrollView *)contentScrollView {
    [self.contentViewArray addObject:contentView];
    NSString *key = [self getcontentScrollViewHandlerDicKeyWithView:contentView];
    
    if (contentScrollView) {
        ScrollViewPanDirectionHandler *handler = [ScrollViewPanDirectionHandler new];
        handler.scrollView = contentScrollView;
        self.contentScrollViewHandlerDic[key] = handler;
        __weak typeof(self) weakSelf = self;
        __weak typeof(contentScrollView) weakScrollView = contentScrollView;
        /// 监听滚动
        [handler scrollViewDidScrollCallBack:^(CGPoint lodOffset, CGPoint newOffset) {
            [weakSelf contentScrollViewDidScroll:weakScrollView];
        }];
    }
}

- (void)setTopSpacing:(CGFloat)topSpacing {
    _topSpacing = topSpacing;
    self.totalTopSpacing = topSpacing - self.itemsHeight;
}

- (void)setItemsHeight:(CGFloat)itemsHeight {
    _itemsHeight = itemsHeight;
    self.totalTopSpacing = self.topSpacing + itemsHeight;
}

@end
