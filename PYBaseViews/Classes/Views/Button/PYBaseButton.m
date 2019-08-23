//
//  BaseButton.m
//  PYKit
//
//  Created by 李鹏跃 on 2018/9/11.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

#import "PYBaseButton.h"
@interface PYBaseButton()
/// handler
@property (nonatomic,strong) PYBaseButtonHandler *handler;

@end

@implementation PYBaseButton

- (void)setHighlighted:(BOOL)highlighted {
    if (self.isShowHighlighted) {
        [super setHighlighted:highlighted];
    }
}
- (void) setupHandler: (void(^)(PYBaseButtonHandler *handler))block {
    if (block) {
        block(self.handler);
    }
}

- (PYBaseButtonHandler *)handler {
    if (!_handler) {
        _handler = PYBaseButtonHandler.handle(self);
    }
    return _handler;
}
@end
