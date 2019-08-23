//
//  PYBaseNavigationController.m
//  FBSnapshotTestCase
//
//  Created by 衣二三 on 2019/8/22.
//

#import "PYBaseNavigationController.h"

@interface PYBaseNavigationController ()
/// interictave
@property (nonatomic,strong) NSArray <Class>*closeInteractivePopClassArray;
@end

@implementation PYBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDelegate];
}

- (void) setupDelegate {
    __weak typeof(self) weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        self.delegate = weakSelf;
    }
}

- (NSArray <UIViewController *> *) popToTopVCWithClass: (Class) viewControllerClass andAnimated: (BOOL) animated {
    UIViewController *result = nil;
    for (NSInteger i = self.viewControllers.count - 1;  i >= 0; i--) {
        UIViewController *vc = [self.viewControllers objectAtIndex:i];
        if ([vc.class isEqual:viewControllerClass]) {
            result = vc;
            break;
        }
    }
    return [self popToViewController:result animated:animated];
}

// MARK: lazy loads
- (NSArray<NSString *> *)closeInteractivePopClassStrArray {
    if (!_closeInteractivePopClassArray) {
        _closeInteractivePopClassArray
        = @[//禁止返回手势交互的控制机名
            
            ];
    }
    return _closeInteractivePopClassArray;
}

- (NSArray<Class> *)closeInteractivePopClassArray {
    if (!_closeInteractivePopClassArray) {
        NSMutableArray <Class> *array = [[NSMutableArray alloc]initWithCapacity:self.closeInteractivePopClassStrArray.count];
        [self.closeInteractivePopClassStrArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            Class vc = NSClassFromString(obj);
            if ([vc isKindOfClass:UIViewController.class]) {
                [array addObject:vc];
            }
        }];
        _closeInteractivePopClassArray = array.copy;
    }
    return _closeInteractivePopClassArray;
}

// MARK: systom functions
/**
 当我们调用setNeedsStatusBarAppearanceUpdate时，系统会调用application.window.rootViewController的preferredStatusBarStyle方法，而不是当前控制器的preferredStatusBarStyle方法。
 */
- (UIViewController *) childViewControllerForStatusBarStyle{
    return self.topViewController;
}

- (void) adjustInteractivePopGestureRecognizer: (BOOL) enable andAnimated: (BOOL) animated {
    if ( [self respondsToSelector:@selector(interactivePopGestureRecognizer)] && animated ) {
        self.interactivePopGestureRecognizer.enabled = enable;
    }
}

- (void) pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ( [self respondsToSelector:@selector(interactivePopGestureRecognizer)] && animated == YES )  {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    [super pushViewController:viewController animated:animated];
}


- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if( [self respondsToSelector:@selector(interactivePopGestureRecognizer)] )
    {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    return [super popToViewController:viewController animated:animated];
}

- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    if( [self respondsToSelector:@selector(interactivePopGestureRecognizer)] ) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    return [super popToRootViewControllerAnimated:animated];
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animate {
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        BOOL isEnabel = ![self.closeInteractivePopClassArray containsObject:viewController.class];
        self.interactivePopGestureRecognizer.enabled = isEnabel;
    }
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        if ( self.viewControllers.count < 2 || self.visibleViewController == [self.viewControllers objectAtIndex:0] ) {
            return NO;
        }
    }
    return YES;
}

// MARK:life cycles






@end
