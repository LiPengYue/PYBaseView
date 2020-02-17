//
//  PYBaseSegmentCollectionView.m
//  PYBaseViews_Example
//
//  Created by 衣二三 on 2019/12/26.
//  Copyright © 2019 LiPengYue. All rights reserved.
//

#import "PYBaseSegmentCollectionView.h"
#import "PYBaseSegmentHandler.h"


@interface PYBaseSegmentCollectionView()
<UIGestureRecognizerDelegate>

@property (nonatomic,strong) PYBaseSegmentHandler *segmentHandler;
@end

@implementation PYBaseSegmentCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        [self baseSetUp];
    }
    return self;
}

- (void) baseSetUp {
    self.panGestureRecognizer.cancelsTouchesInView = NO;
}


- (PYBaseSegmentHandler *)segmentHandler {
    if (!_segmentHandler) {
        _segmentHandler = [PYBaseSegmentHandler new];
        _segmentHandler.segmentScrollView = self;
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


#pragma mark - UIGestureRecognizerDelegate

// 返回YES表示可以继续传递触摸事件，这样两个嵌套的scrollView才能同时滚动
- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return [self.segmentHandler shouldRecognizeSimultaneouslyWithGestureRecognizer:gestureRecognizer andOtherRecognizer:otherGestureRecognizer];
}

@end
