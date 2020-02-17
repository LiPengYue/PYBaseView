//
//  NSObject+T.m
//  PYSegmentView
//
//  Created by 李鹏跃 on 2018/9/10.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

#import "NSObject+T.h"

@implementation NSObject (T)

+ (void)ObjType:(id)obj is: (Class)t success: (void(^)(id obj))success {
    [obj is:t success:success];
}

- (id) asType: (Class)t Do: (id(^)(id obj))Do {
    __weak typeof(self) weakSelf = self;
    if ([self isKindOfClass:t] && Do) {
        return Do(weakSelf);
    }else{
        NSLog(@"   🌶🌶🌶：《%@》 不能转化为 《%@》 类型",NSStringFromClass([self class]),NSStringFromClass(t));
        return nil;
    }
}

- (void)ifIs: (Class)t Do: (void(^)(id obj))Do {
    [self is:t success:Do];
}

- (void)is: (Class)t success: (void(^)(id obj))success {
    __weak typeof(self) weakSelf = self;
    if ([self isKindOfClass:t] && success) {
        success(weakSelf);
    }else{
        NSLog(@"   🌶🌶🌶：《%@》 不能转化为 《%@》 类型",NSStringFromClass([self class]),NSStringFromClass(t));
    }
}
@end
