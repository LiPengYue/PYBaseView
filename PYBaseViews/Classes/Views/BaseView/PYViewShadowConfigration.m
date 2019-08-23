//
//  PYViewShadowConfigration.m
//  PYKit
//
//  Created by 李鹏跃 on 2018/9/11.
//  Copyright © 2018年 13lipengyue. All               rights reserved.
//

#import "PYViewShadowConfigration.h"
@interface PYViewShadowConfigration ()
@property (nonatomic,strong) CABasicAnimation *offsetAnimation;
@property (nonatomic,strong) CABasicAnimation *opacityAnimation;
@property (nonatomic,strong) CABasicAnimation *colorAnimation;

@property (nonatomic,weak) CALayer *layer;
@end

@implementation PYViewShadowConfigration

+ (PYViewShadowConfigration *(^)(CALayer *layer)) create {
    return ^(CALayer *layer) {
        PYViewShadowConfigration *handler = [PYViewShadowConfigration new];
        handler.layer = layer;
        return handler;
    };
}

// MARK: -
- (CAAnimationGroup *(^)(CGFloat duration)) beginAnimationWithDuration {
    return ^(CGFloat duration) {
        CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
        
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:3];
        
        self.offsetAnimation
        ?[array addObject:self.offsetAnimation] : nil;
        self.opacityAnimation
        ?[array addObject:self.opacityAnimation] : nil;
        self.colorAnimation
        ?[array addObject:self.colorAnimation] : nil;
        
        groupAnimation.animations = array.copy;
        groupAnimation.removedOnCompletion = false;
        groupAnimation.fillMode = kCAFillModeBackwards;
        groupAnimation.duration = duration;
        groupAnimation.beginTime = 0;
        
        return groupAnimation;
    };
}

// from
- (PYViewShadowConfigration *(^)(CGSize size)) setUpFromShadowOffset {
    return ^(CGSize size) {
        self.shadowFromOffset = size;
        return self;
    };
}
- (PYViewShadowConfigration *(^)(CGFloat opacity)) setUpFromShadowOpacity {
    return ^(CGFloat opacity) {
        self.shadowFromOpacity = opacity;
        return self;
    };
}
- (PYViewShadowConfigration *(^)(UIColor *color)) setUpFromShadowColor {
    return ^(UIColor *color) {
        self.shadowFromColor = color;
        return self;
    };
}

//MARK: to
- (PYViewShadowConfigration *(^)(CGSize size)) setUpToShadowOffset {
    return ^(CGSize size) {
        self.shadowToOffset = size;
        return self;
    };
}
- (PYViewShadowConfigration *(^)(CGFloat opacity)) setUpToShadowOpacity {
    return ^(CGFloat opacity) {
        self.shadowToOpacity = opacity;
        return self;
    };
}
- (PYViewShadowConfigration *(^)(UIColor *color)) setUpToShadowColor {
    return ^(UIColor *color) {
        self.shadowToColor = color;
        return self;
    };
}

//MARK: - get && set
-(CABasicAnimation *)offsetAnimation {
    if (!_offsetAnimation) {
        _offsetAnimation = [self createBasicAnimationWithKey:@"shadowOffset"];
    }
    return _offsetAnimation;
}
-(CABasicAnimation *)opacityAnimation {
    if (!_opacityAnimation) {
        _opacityAnimation = [self createBasicAnimationWithKey:@"shadowOpacity"];
    }
    return _opacityAnimation;
}
-(CABasicAnimation *)colorAnimation {
    if (!_colorAnimation) {
        _colorAnimation = [self createBasicAnimationWithKey:@"shadowColor"];
    }
    return _colorAnimation;
}
- (CABasicAnimation *) createBasicAnimationWithKey: (NSString *)key {
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:key];
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    return anim;
}

- (CABasicAnimation *) animationOffset {
    return self.offsetAnimation;
}
- (CABasicAnimation *) animationColor {
    return self.colorAnimation;
}
- (CABasicAnimation *) animationOpacity {
    return self.opacityAnimation;
}

- (void) setShadowFromColor:(UIColor *)shadowFromColor {
    _shadowFromColor = shadowFromColor;
    self.colorAnimation.fromValue = shadowFromColor;
}
- (void) setShadowToColor:(UIColor *)shadowToColor {
    _shadowToColor = shadowToColor;
    self.colorAnimation.toValue = shadowToColor;
}
- (void) setShadowFromOffset:(CGSize)shadowFromOffset {
    _shadowFromOffset = shadowFromOffset;
    self.offsetAnimation.fromValue = [NSValue valueWithCGSize: shadowFromOffset];
}
- (void) setShadowToOffset:(CGSize)shadowToOffset {
    _shadowToOffset = shadowToOffset;
    self.offsetAnimation.toValue = [NSValue valueWithCGSize: _shadowToOffset];
}
- (void) setShadowFromOpacity:(CGFloat)shadowFromOpacity {
    _shadowFromOpacity = shadowFromOpacity;
    self.opacityAnimation.fromValue = @(shadowFromOpacity);
}

- (void) setShadowToOpacity:(CGFloat)shadowToOpacity {
    _shadowToOpacity = shadowToOpacity;
    self.opacityAnimation.toValue = @(shadowToOpacity);
}
@end
