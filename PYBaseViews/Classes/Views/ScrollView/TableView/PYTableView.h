//
//  PYTableView.h
//  FBSnapshotTestCase
//
//  Created by 衣二三 on 2019/8/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PYTableView : UITableView
- (void) reloadDataEventCallBack: (void(^)(void))block;
/// 是否可以相应相应
- (void) shouldRecognizeSimultaneouslyWithGestureRecognizerFunc: (BOOL (^)(UIGestureRecognizer *gestureRecognizer, UIGestureRecognizer *otherGestureRecognizer))block;
@end

NS_ASSUME_NONNULL_END
