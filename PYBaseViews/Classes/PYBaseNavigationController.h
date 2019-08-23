//
//  PYBaseNavigationController.h
//  FBSnapshotTestCase
//
//  Created by 衣二三 on 2019/8/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PYBaseNavigationController : UINavigationController
<
UIGestureRecognizerDelegate,
UINavigationControllerDelegate
>

/// 跳转到 堆栈 从上向下遍历 第一次出现的 class为 viewControllerClass 的vc
- (NSArray <UIViewController *> *) popToTopVCWithClass: (Class) viewControllerClass andAnimated: (BOOL) animated;

/// 进制手势返回的 数组
@property (nonatomic,strong) NSArray <NSString *>*closeInteractivePopClassStrArray;
@end

NS_ASSUME_NONNULL_END
