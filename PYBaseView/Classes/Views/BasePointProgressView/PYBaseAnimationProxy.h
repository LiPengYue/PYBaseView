//
//  BaseAnimationProxy.h
//  BaseProgress
//
//  Created by 衣二三 on 2019/4/8.
//  Copyright © 2019年 衣二三. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PYBaseAnimationProxy : NSProxy

@property (weak,nonatomic,readonly)id target;

- (PYBaseAnimationProxy *) initWithTarget: (id)target;

+ (PYBaseAnimationProxy *(^)(id target)) createWithTarget;
@end

NS_ASSUME_NONNULL_END
