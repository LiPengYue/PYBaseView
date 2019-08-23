//
//  BaseButton+Handler.m
//  AttributedString
//
//  Created by 李鹏跃 on 2018/9/11.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

#import "PYBaseButtonHandler.h"
#import <objc/runtime.h>

@implementation PYBaseButtonHandler
+ (PYBaseButtonHandler *(^)(UIButton *button)) handle {
    return ^(UIButton *button) {
        PYBaseButtonHandler *handler = [PYBaseButtonHandler new];
        handler.button = button;
        return handler;
    };
}

- (PYBaseButtonHandler *(^)(UIFont *)) setUpFont {
    __weak typeof (self)weakSelf = self;
    return ^(UIFont *font) {
        if (!self.py_isTagState || weakSelf.state == weakSelf.state) {
            weakSelf.button.titleLabel.font = font;
        }
        weakSelf.fontDictionaryM[@(weakSelf.state)] = font;
        return weakSelf;
    };
}

- (PYBaseButtonHandler *(^)(CGFloat)) setUpCornerRadius {
    __weak typeof (self) weakSelf = self;
    return ^(CGFloat radius) {
        if (!self.py_isTagState || weakSelf.state == weakSelf.state) {
            weakSelf.button.layer.cornerRadius = radius;
        }
        weakSelf.cornerRadiusDictionaryM[@(weakSelf.state)] = @(radius);
        return weakSelf;
    };
}

- (void)setUpStyle:(NSInteger) state style:(void(^)(PYBaseButtonHandler *handler))callBack {
    self.state = state;
    self.py_isTagState = true;
    callBack(self);
    self.state = 0;
    self.py_isTagState = false;
}

- (PYBaseButtonHandler *(^)(UIColor *)) setUpTitleColor {
    __weak typeof (self)weakSelf = self;
    return ^(UIColor *color) {
        [weakSelf.button setTitleColor:color forState:weakSelf.state];
        return weakSelf;
    };
}

- (PYBaseButtonHandler *(^)(UIColor *)) setUpBackgroundColor {
    __weak typeof (self)weakSelf = self;
    return ^(UIColor *color) {
        weakSelf.button.backgroundColor = color;
        weakSelf.backgroundColorDictionaryM[@(weakSelf.state)] = color;
        return weakSelf;
    };
}

- (PYBaseButtonHandler *(^)(NSString *)) setUpTitle {
    __weak typeof (self)weakSelf = self;
    return ^(NSString *title) {
        [weakSelf.button setTitle:title forState:weakSelf.state];
        return weakSelf;
    };
}

- (PYBaseButtonHandler *(^)(NSAttributedString *)) setUpAttributedString {
    __weak typeof (self)weakSelf = self;
    return ^(NSAttributedString *attributedString) {
        [weakSelf.button setAttributedTitle:attributedString forState:weakSelf.state];
        return weakSelf;
    };
}

- (PYBaseButtonHandler *(^)(UIImage *))setUpImage {
    __weak typeof (self)weakSelf = self;
    return ^(UIImage *image) {
        [weakSelf.button setImage:image forState:weakSelf.state];
        return weakSelf;
    };
}
- (PYBaseButtonHandler *(^)(NSString *name)) setUpImageName {
    __weak typeof (self)weakSelf = self;
    return ^(NSString *image) {
        return weakSelf.setUpImage([UIImage imageNamed:image]);
    };
}

- (PYBaseButtonHandler *(^)(UIImage *))setUpBackgroundImage {
    __weak typeof (self)weakSelf = self;
    return ^(UIImage *image) {
        [weakSelf.button setBackgroundImage:image forState:weakSelf.state];
        return weakSelf;
    };
}

- (PYBaseButtonHandler *(^)(NSString *)) setUpBackgroundImageName {
    __weak typeof (self)weakSelf = self;
    return ^(NSString *imageName) {
        UIImage *image = [UIImage imageNamed:imageName];
        return weakSelf.setUpBackgroundImage(image);
    };
}

- (PYBaseButtonHandler *(^)(CGFloat)) setUpBorderWidth {
    __weak typeof (self)weakSelf = self;
    return ^(CGFloat borderW) {

        if (!self.py_isTagState || weakSelf.state == weakSelf.state) {
            weakSelf.button.layer.borderWidth = borderW;
        }
        weakSelf.borderWidthDictionaryM[@(weakSelf.state)] = @(borderW);
        return weakSelf;
    };
}

- (PYBaseButtonHandler *(^)(UIColor *)) setUpBorderColor {
    __weak typeof (self)weakSelf = self;
    return ^(UIColor *color) {
        if (!self.py_isTagState || weakSelf.state == weakSelf.state) {
            weakSelf.button.layer.borderColor = color.CGColor;
        }
        weakSelf.borderColorDictionaryM[@(weakSelf.state)] = color;
        return weakSelf;
    };
}


//- (PYBaseButtonHandler *(^)(CGFloat,CGFloat,CGFloat,CGFloat)) setUpTitleEdgeInsets {
//    __weak typeof (self)weakSelf = self;
//    return ^(CGFloat top,CGFloat left,CGFloat bottom,CGFloat right) {
//        if (weakSelf.state == weakSelf.state) {
//
//        }
//        weakSelf.borderColorDictionaryM[@(weakSelf.state)] = color;
//        return weakSelf;
//    };
//}
//- (PYBaseButtonHandler *(^)(CGFloat,CGFloat,CGFloat,CGFloat)) setUpImageEdgeInsets;

- (void) adjustButtonStyleWithState: (NSInteger) state {
    [self adjustBackgroundColorWithState:state];
    [self adjustBorderColorWithState:state];
    [self adjustBorderWidthWithState:state];
    [self adjustFontWithState:state];
    [self adjustCornerRadiusWithState:state];
}

- (void) adjustBackgroundColorWithState:(NSInteger)state {
    NSNumber *currenState = @(state);
    NSNumber *normalState = @(0);
    UIColor *backgroundColor = self.backgroundColorDictionaryM[currenState];
    
    /// backgroundColor
    if (!backgroundColor) {
        backgroundColor = self.backgroundColorDictionaryM[normalState];
    }
    if (backgroundColor) {
        self.button.backgroundColor = backgroundColor;
    }
    
}
- (void) adjustBorderColorWithState:(NSInteger)state {
    NSNumber *currenState = @(state);
    NSNumber *normalState = @(0);
    // borderColor
    UIColor *borderColor = self.borderColorDictionaryM[currenState];
    if (!borderColor) {
        borderColor = self.borderColorDictionaryM[normalState];
    }
    if (borderColor) {
        self.button.layer.borderColor = borderColor.CGColor;
    }
}
- (void) adjustBorderWidthWithState:(NSInteger)state {
    NSNumber *currenState = @(state);
    NSNumber *normalState = @(0);
    //borderWidth
    NSNumber *borderWidthNumbser = self.borderWidthDictionaryM[currenState];
    if (!borderWidthNumbser) {
        borderWidthNumbser = self.borderWidthDictionaryM[normalState];
    }
    CGFloat borderWidth = borderWidthNumbser.floatValue;
    self.button.layer.borderWidth = borderWidth;
}
- (void) adjustFontWithState:(NSInteger)state {
    NSNumber *currenState = @(state);
    NSNumber *normalState = @(0);
    //borderWidth
    UIFont *font = self.fontDictionaryM[currenState];
    if (!font) {
        font = self.fontDictionaryM[normalState];
    }
    if (font) {
        self.button.titleLabel.font = font;
    }
}
- (void) adjustCornerRadiusWithState:(NSInteger)state {
    NSNumber *currenState = @(state);
    NSNumber *normalState = @(0);
    //borderWidth
    NSNumber *value = self.cornerRadiusDictionaryM[currenState];
    if (!value) {
        value = self.cornerRadiusDictionaryM[normalState];
    }
    self.button.layer.cornerRadius = value.floatValue;
}




//MAKR: - get && set

- (NSMutableDictionary<NSNumber *,UIColor *> *)backgroundColorDictionaryM {
    if (!_backgroundColorDictionaryM) {
        _backgroundColorDictionaryM = [NSMutableDictionary new];
    }
    return _backgroundColorDictionaryM;
}


- (NSMutableDictionary<NSNumber *,UIColor *> *)borderColorDictionaryM {
    if (!_borderColorDictionaryM) {
        _borderColorDictionaryM = [NSMutableDictionary new];
    }
    return _borderColorDictionaryM;
}


- (NSMutableDictionary<NSNumber *,NSNumber *> *)borderWidthDictionaryM {
    if (!_borderWidthDictionaryM) {
        _borderWidthDictionaryM = [NSMutableDictionary new];
    }
    return _borderWidthDictionaryM;
}


- (NSMutableDictionary<NSNumber *,UIFont *> *)fontDictionaryM {
    
    if (!_fontDictionaryM) {
        _fontDictionaryM = [NSMutableDictionary new];
    }
    return _fontDictionaryM;
}


- (NSMutableDictionary<NSNumber *,NSNumber *> *)cornerRadiusDictionaryM {
    if (!_cornerRadiusDictionaryM) {
        _cornerRadiusDictionaryM = [NSMutableDictionary new];
    }
    return _cornerRadiusDictionaryM;
}

@end
