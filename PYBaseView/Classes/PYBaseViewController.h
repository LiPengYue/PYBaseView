//
//  BaseViewHandler.h
//  PYKit
//
//  Created by 李鹏跃 on 2018/9/11.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYBaseView.h"
#import "PYBaseNavigationBarView.h"
#import "PYBaseNavigationController.h"
NS_ASSUME_NONNULL_BEGIN

@interface PYBaseViewController : UIViewController

@property (nonatomic,strong) PYBaseNavigationBarView *navBarView;
/// 是否穿透translucent
@property (nonatomic,assign) BOOL isTranslucent;

- (void)revertViewWillAppear;
- (void)revertViewDidAppear;
- (void)revertViewWillDisappear;
- (void)revertViewDidDisappear;
- (void)revertDealloc;
@end


NS_ASSUME_NONNULL_END
