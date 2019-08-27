//
//  BaseButton.h
//  PYKit
//
//  Created by 李鹏跃 on 2018/9/11.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYBaseButtonHandler.h"

NS_ASSUME_NONNULL_BEGIN

@interface PYBaseButton : UIButton
@property (nonatomic,assign) BOOL isShowHighlighted;
- (void) setupHandler: (void(^)(PYBaseButtonHandler *handler))block;

/// handler
@property (nonatomic,strong) PYBaseButtonHandler *handler;
@end

NS_ASSUME_NONNULL_END
