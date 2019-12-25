//
//  PYTableView.m
//  FBSnapshotTestCase
//
//  Created by 衣二三 on 2019/8/16.
//

#import "PYTableView.h"

@interface PYTableView()
<
UIGestureRecognizerDelegate
>
@property (nonatomic,copy) void(^reloadDataBlock)(void);
@property (nonatomic,copy) BOOL (^shouldRecognizeSimultaneouslyWithGestureRecognizerBlock)(UIGestureRecognizer *gestureRecognizer, UIGestureRecognizer *otherGestureRecognizer);
@end

@implementation PYTableView


- (instancetype)init {
    
    self = [super init];
    if (self) {
        [self baseSetup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGFLOAT_MIN, CGFLOAT_MIN)];
        self.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGFLOAT_MIN, CGFLOAT_MIN)];
        [self baseSetup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self baseSetup];
    }
    return self;
}

- (void) baseSetup {
    // 在某些情况下，contentView中的点击事件会被panGestureRecognizer拦截，导致不能响应，
    // 这里设置cancelsTouchesInView表示不拦截
    self.panGestureRecognizer.cancelsTouchesInView = NO;
}

- (void)reloadData {
    [super reloadData];
    if (self.reloadDataBlock) {
        self.reloadDataBlock();
    }
}

- (void) reloadDataEventCallBack: (void(^)(void))block {
    self.reloadDataBlock = block;
}

- (void) shouldRecognizeSimultaneouslyWithGestureRecognizerFunc: (BOOL (^)(UIGestureRecognizer *gestureRecognizer, UIGestureRecognizer *otherGestureRecognizer))block {
    self.shouldRecognizeSimultaneouslyWithGestureRecognizerBlock =  block;
}

#pragma mark - UIGestureRecognizerDelegate

// 返回YES表示可以继续传递触摸事件，这样两个嵌套的scrollView才能同时滚动
- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (self.shouldRecognizeSimultaneouslyWithGestureRecognizerBlock) {
        return self.shouldRecognizeSimultaneouslyWithGestureRecognizerBlock(gestureRecognizer,otherGestureRecognizer);
    }
    return false;
}
@end
