//
//  BaseAnimationProxy.m
//  BaseProgress
//
//  Created by 衣二三 on 2019/4/8.
//  Copyright © 2019年 衣二三. All rights reserved.
//

#import "PYBaseAnimationProxy.h"
#import <objc/runtime.h>

@implementation PYBaseAnimationProxy

- (PYBaseAnimationProxy *) initWithTarget: (id)target {
    _target = target;
    objc_setAssociatedObject(target, (__bridge const void *)(self), self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return self;
}

+ (PYBaseAnimationProxy *(^)(id))createWithTarget {
    return ^(id target) {
        return [[self alloc] initWithTarget:target];
    };
}

- (BOOL)respondsToSelector:(SEL)aSelector{
    return [self.target respondsToSelector:aSelector];
}

/**
 根据Invocation 调用方法
 @param invocation 消息发送的核心类
 */
- (void)forwardInvocation:(NSInvocation *)invocation{
    SEL sel = invocation.selector;
    if ([self.target respondsToSelector:sel]) {
        [invocation invokeWithTarget:self.target];
    }else{
        
    }
}


/**
 根据selector 生成方法签名，为创建NSInvocation做准备
 @param sel selector 选择器
 @return 方法签名
 */
- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel{
    if (self.target && [self.target respondsToSelector:sel]) {
        return [self.target methodSignatureForSelector:sel];
    } else {
        return [NSObject instanceMethodSignatureForSelector:@selector(init)];
    }
}
@end
