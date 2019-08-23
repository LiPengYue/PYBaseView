//
//  ScrollViewPanDirectionHandler.m
//  PYKit
//
//  Created by 李鹏跃 on 2018/9/11.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

#import "ScrollViewPanDirectionHandler.h"

@interface ScrollViewPanDirectionHandler()<UIGestureRecognizerDelegate>
@property (nonatomic,copy) void(^scrollViewDidScrollCallBack)(CGPoint lodOffset, CGPoint newOffset);
@property (nonatomic,strong) UIPanGestureRecognizer *pan;
@end


@implementation ScrollViewPanDirectionHandler

static NSString *const ScrollViewPanDirectionHandlerObserveContext = @"ScrollViewPanDirectionHandlerObserveContext";

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.horizontalOffset = 10;
        self.verticalOffset = 10;
    }
    return self;
}

- (void)setScrollView:(UIScrollView *)scrollView {
    if (_scrollView) {
        [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
    }
    _scrollView = scrollView;
    [_scrollView addGestureRecognizer:self.pan];
    [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionNew context:@"ScrollViewPanDirectionHandlerObserveContext"];
}
- (void)dealloc {
    if (self.scrollView) {
        [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    }
}

- (UIPanGestureRecognizer *)pan {
    if (!_pan) {
        _pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
        _pan.delegate = self;
        _pan.minimumNumberOfTouches = 1;
    }
    return _pan;
}

// MARK: 兼容其他手势
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void) panAction: (UIPanGestureRecognizer *)pan {
    pan = self.scrollView.panGestureRecognizer;
    UIView *inView = self.scrollView.superview ? self.scrollView.superview : self.scrollView;
    CGPoint translation = [pan translationInView:inView];
    // 向上
    if (translation.y >= self.verticalOffset) {
        if (self.down) self.down();
    }
    // 向下
    if (translation.y <= -self.verticalOffset) {
        if (self.up) self.up();
    }
    
    // 向右
    if (translation.y >= self.horizontalOffset) {
        if (self.right) self.right();
    }
    // 向左
    if (translation.y <= -self.horizontalOffset) {
        if (self.left) self.left();
    }
}

- (void) scrollViewDidScrollCallBack:(void (^)(CGPoint, CGPoint))block {
    self.scrollViewDidScrollCallBack = block;
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if (![keyPath isEqualToString:@"contentOffset"] ||  context != @"ScrollViewPanDirectionHandlerObserveContext" || ![object isKindOfClass:UIScrollView.class] || ![object isEqual:self.scrollView]) {
        return;
    }
    
    if (!self.scrollViewDidScrollCallBack) return;
    
    NSNumber *newOffsetNumber = (NSNumber *)change[NSKeyValueChangeNewKey];
    CGPoint offsetNew = newOffsetNumber.CGPointValue;
    
    NSNumber *oldOffsetNumber = (NSNumber *)change[NSKeyValueChangeOldKey];
    CGPoint offsetOld = oldOffsetNumber.CGPointValue;
    self.scrollViewDidScrollCallBack(offsetOld, offsetNew);
}
@end
