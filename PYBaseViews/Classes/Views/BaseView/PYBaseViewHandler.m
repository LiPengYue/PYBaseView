//
//  PYBaseViewHandler.m
//  PYKit
//
//  Created by 李鹏跃 on 2018/9/11.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

#import "PYBaseViewHandler.h"
@interface PYBaseViewHandler()
/// view
@property (nonatomic,strong) UIView *view;

@property (nonatomic,assign) UILayoutPriority huggingPriority;
@property (nonatomic,assign) UILayoutPriority compressionPriority;

@property (nonatomic,assign) UILayoutConstraintAxis huggingConstraint;
@property (nonatomic,assign) UILayoutConstraintAxis compressionConstraint;
@end

@implementation PYBaseViewHandler

+ (PYBaseViewHandler *(^)(UIView *view)) handle {
    return ^(UIView *view) {
        PYBaseViewHandler *handler = [self new];
        handler.view =view;
        return handler;
    };
}

- (instancetype)init {
    if (self = [super init]) {
        _huggingConstraint = UILayoutConstraintAxisHorizontal;
        _compressionConstraint = UILayoutConstraintAxisHorizontal;
        _huggingPriority = UILayoutPriorityDefaultLow;
        _compressionPriority = UILayoutPriorityDefaultHigh;
    }
    return self;
}
- (PYBaseViewHandler *(^)(UIView *)) addSubView {
    return ^(UIView *view){
        [self.view addSubview:view];
        return self;
    };
}

- (PYBaseViewHandler *(^)(BOOL)) setUpHidden {
    return ^(BOOL isHidden) {
        self.view.hidden = isHidden;
        return self;
    };
}

- (PYBaseViewHandler *(^)(CGFloat)) setUpCornerRadius {
    __weak typeof (self) weakSelf = self;
    return ^(CGFloat radius) {
        weakSelf.view.layer.cornerRadius = radius;
        return weakSelf;
    };
}
- (PYBaseViewHandler *(^)(BOOL)) setUpMasksToBounds {
    __weak typeof (self) weakSelf = self;
    return ^(BOOL masksToBounds) {
        weakSelf.view.layer.masksToBounds = masksToBounds;
        return weakSelf;
    };
}

- (PYBaseViewHandler *(^)(CGFloat)) setUpBorderWidth {
    __weak typeof (self) weakSelf = self;
    return ^(CGFloat borderWidth) {
        weakSelf.view.layer.borderWidth = borderWidth;
        return weakSelf;
    };
}
- (PYBaseViewHandler *(^)(UIColor *)) setUpBorderColor {
    __weak typeof (self) weakSelf = self;
    return ^(UIColor *borderColor) {
        weakSelf.view.layer.borderColor = borderColor.CGColor;
        return weakSelf;
    };
}

- (PYBaseViewHandler *(^)(UIColor *)) setUpBackgroundColor {
    __weak typeof (self) weakSelf = self;
    return ^(UIColor *backgroundColor) {
        weakSelf.view.backgroundColor = backgroundColor;
        return weakSelf;
    };
}


// MARK: - shadow
- (PYBaseViewHandler *(^)(CGFloat Y)) setUpShadowOffsetY {
    return ^(CGFloat value) {
        CGSize offset = self.view.layer.shadowOffset;
        offset.height = value;
        self.view.layer.shadowOffset = offset;
        return self;
    };
}

- (PYBaseViewHandler *(^)(CGFloat X)) setUpShadowOffsetX {
    return ^(CGFloat value) {
        CGSize offset = self.view.layer.shadowOffset;
        offset.width = value;
        self.view.layer.shadowOffset = offset;
        return self;
    };
}

- (PYBaseViewHandler *(^)(CGSize offset)) setUpShadowOffset {
    return ^(CGSize value) {
        self.view.layer.shadowOffset = value;
        return self;
    };
}

- (PYBaseViewHandler *(^)(CGFloat opacity)) setUpShadowOpacity {
    return ^(CGFloat opacity) {
        self.view.layer.shadowOpacity = opacity;
        return self;
    };
}

- (PYBaseViewHandler *(^)(UIColor *color)) setUpShadowColor {
    return ^(UIColor *color) {
        self.view.layer.shadowColor = color.CGColor;
        return self;
    };
}

- (PYBaseViewHandler *(^)(CGFloat radius)) setUpShadowRadius {
    return ^(CGFloat radius) {
        self.view.layer.shadowRadius = radius;
        return self;
    };
}




// MARK: - 关于约束

/**
 * @brief 抗拉伸 设置优先级 默认为750
 *
 * @warning 如果有空余，那么优先级越高 越不容易被拉伸
 * @warning 参数类型： UILayoutPriority
 * @bug 需要保证 self != nil
 */
- (PYBaseViewHandler *(^)(UILayoutPriority priority)) setUpHuggingPriority {
    return ^(UILayoutPriority priority) {
        self.huggingPriority = priority;
        return self;
    };
}
/**
 * @brief 抗压缩 设置优先级 默认为251
 *
 * @warning 如果有没有空余，那么优先级越高 越不容易被压缩
 * @warning 参数类型： UILayoutPriority
 * @bug 需要保证 self != nil
 */
- (PYBaseViewHandler *(^)(UILayoutPriority priority)) setUpCompressionPriority {
    return ^(UILayoutPriority priority) {
        self.compressionPriority = priority;
        return self;
    };
}

/**
 * @brief 抗拉伸（有空余的情况下，谁不容易被拉伸）
 *
 * @warning 横向还是纵向进行优先级限制
 * @warning 参数类型： UILayoutConstraintAxis
 * @bug 需要保证 self != nil
 */
- (PYBaseViewHandler *(^)(UILayoutConstraintAxis constraint)) setUpHuggingAxis {
    return ^(UILayoutConstraintAxis constraint) {
        self.huggingConstraint = constraint;
        return self;
    };
}

/**
 * @brief 抗压缩（没有空余的情况下，谁不容易被压缩）m
 *
 * @warning 横向还是纵向进行优先级限制
 * @warning 参数类型： UILayoutConstraintAxis
 * @bug 需要保证 self != nil
 */
- (PYBaseViewHandler *(^)(UILayoutConstraintAxis constraint)) setUpCompressionAxis {
    return ^(UILayoutConstraintAxis constraint) {
        self.compressionConstraint = constraint;
        return self;
    };
}





// MARK: - set && get
- (void) setHuggingPriority:(UILayoutPriority)huggingPriority {
    _huggingPriority = huggingPriority;
    [self setupHuggingLayoutPriority];
}

- (void) setHuggingConstraint:(UILayoutConstraintAxis)huggingConstraint {
    _huggingConstraint = huggingConstraint;
    [self setupHuggingLayoutPriority];
}

- (void) setCompressionPriority:(UILayoutPriority)compressionPriority {
    _compressionPriority = compressionPriority;
    [self setupCompressionLayoutPriority];
}

- (void) setCompressionConstraint:(UILayoutConstraintAxis)compressionConstraint {
    _compressionConstraint = compressionConstraint;
    [self setupCompressionLayoutPriority];
}


- (void) setupHuggingLayoutPriority {
    [self.view setContentHuggingPriority:self.huggingPriority forAxis:self.huggingConstraint];
}

- (void) setupCompressionLayoutPriority {
    [self.view setContentCompressionResistancePriority:self.compressionPriority forAxis:self.compressionConstraint];
}

@end

