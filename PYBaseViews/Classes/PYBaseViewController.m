//
//  BaseViewHandler.h
//  PYKit
//
//  Created by 李鹏跃 on 2018/9/11.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

#import "PYBaseViewController.h"
#import "PYBaseNavigationBarView.h"
#ifdef DEBUG
#    define DLog(...) NSLog(__VA_ARGS__)
#else
#    define DLog(...)
#endif

@interface PYBaseViewController ()
@end

@implementation PYBaseViewController

// MARK: systom functions
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self baseSetupNav];
}

- (void) baseSetupNav {
    self.navBarView.titleButtonHeight = 40;
    self.navBarView.isHiddenBottomLine = false;
    self.navBarView.itemHeight = 40;
    
    __weak typeof (self)weakSelf = self;
    
    [self.navBarView clickLeftButtonFunc:^(UIButton *button, NSInteger index) {
        [weakSelf.navigationController popViewControllerAnimated:true];
    }];
    
    CGRect statusBarRect = [[UIApplication sharedApplication] statusBarFrame];
    CGRect navRect = self.navigationController.navigationBar.frame;
    CGFloat h = statusBarRect.size.height+navRect.size.height;
    
    [self.view addSubview:self.navBarView];
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    self.navBarView.frame = CGRectMake(0, 0, w, h);
    [self.navBarView reloadView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:true ];
    self.navigationController.navigationBar.translucent = self.isTranslucent;
    if (![self.view.subviews.lastObject isEqual:self.navBarView]) {
        [self.view addSubview: self.navBarView];
    }
    [self revertViewWillAppear];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self revertViewDidAppear];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self revertViewWillDisappear];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self revertViewDidDisappear];
}
- (void)dealloc {
    DLog(@"✅ 已销毁：%@",NSStringFromClass([self class]));
    if ([self respondsToSelector:@selector(revertDealloc)]) {
        [self revertDealloc];
    }
}

- (void)revertViewWillAppear {}
- (void)revertViewDidAppear {}
- (void)revertViewWillDisappear {}
- (void)revertViewDidDisappear {}
- (void)revertDealloc {};

- (void) hiddenNavBarBottomLine: (BOOL) isHidden {
    CGSize naviBarSize = self.navigationController.navigationBar.frame.size;
    CGRect imageFrame = CGRectMake(0, naviBarSize.height - .5, naviBarSize.width, 1);
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:imageFrame];
    lineImageView.backgroundColor = [UIColor whiteColor];
    if (isHidden) {
        lineImageView.backgroundColor = [UIColor whiteColor];
        lineImageView.image = [[UIImage imageNamed:@"nav_border_line_write.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0.5];
        [self.navigationController.navigationBar addSubview:lineImageView];
    }
    else {
        
        lineImageView.image = [[UIImage imageNamed:@"nav_border_line.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0.5];
    }
    [self.navigationController.navigationBar addSubview:lineImageView];
}


- (PYBaseNavigationBarView *)navBarView {
    if (!_navBarView) {
        _navBarView = [PYBaseNavigationBarView new];
    }
    return _navBarView;
}

// MARK:life cycles

@end
