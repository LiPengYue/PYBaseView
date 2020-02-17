//
//  BaseParagraphStyleHandler+Handler.m
//  AttributedString
//
//  Created by 李鹏跃 on 2018/9/11.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

#import "BaseParagraphStyleHandler+Handler.h"

@implementation BaseParagraphStyleHandler (Handler)
- (void) setUp: (void(^)(BaseParagraphStyleHandler *weak))block {
    if (block) {
        __weak typeof(self)weakSelf = self;
        block(weakSelf);
    }
}
/// 字体的行间距
- (BaseParagraphStyleHandler *(^)(CGFloat spacing)) setUpLineSpacing {
    __weak typeof(self) weakSelf = self;
    return ^(CGFloat spacing) {
        weakSelf.style.lineSpacing = spacing;
        return weakSelf;
    };
}

///首行缩进
- (BaseParagraphStyleHandler *(^)(CGFloat firstLineHeadIndent)) setUpFirstLineHeadIndent {
    __weak typeof(self) weakSelf = self;
    return ^(CGFloat firstLineHeadIndent) {
        weakSelf.style.firstLineHeadIndent = firstLineHeadIndent;
        return weakSelf;
    };
}

///（两端对齐的）文本对齐方式：（左，中，右，两端对齐，自然）
- (BaseParagraphStyleHandler *(^)(NSTextAlignment alignment)) setUpAlignment {
    __weak typeof(self) weakSelf = self;
    return ^(NSTextAlignment alignment) {
        weakSelf.style.alignment = alignment;
        return weakSelf;
    };
}

///结尾部分的内容以……方式省略 ( "...wxyz" ,"abcd..." ,"ab...yz")
- (BaseParagraphStyleHandler *(^)(NSLineBreakMode lineBreakMode)) setUpLineBreakMode {
    __weak typeof(self) weakSelf = self;
    return ^(NSLineBreakMode lineBreakMode) {
        weakSelf.style.lineBreakMode = lineBreakMode;
        return weakSelf;
    };
}

///整体缩进(首行除外)
- (BaseParagraphStyleHandler *(^)(CGFloat headIndent)) setUpHeadIndent {
    __weak typeof(self) weakSelf = self;
    return ^(CGFloat headIndent) {
        weakSelf.style.headIndent = headIndent;
        return weakSelf;
    };
}

/// 可调整文字尾端的缩排距离。需要注意的是，这里指定的值可以当作文字显示的宽、而也可当作右边 padding 使用，依据输入的正负值而定：
- (BaseParagraphStyleHandler *(^)(CGFloat tailIndent)) setUpTailIndent {
    __weak typeof(self) weakSelf = self;
    return ^(CGFloat tailIndent) {
        weakSelf.style.tailIndent = tailIndent;
        return weakSelf;
    };
}

///最低行高
- (BaseParagraphStyleHandler *(^)(CGFloat height)) setUpMinimumLineHeight {
    __weak typeof(self) weakSelf = self;
    return ^(CGFloat height) {
        weakSelf.style.minimumLineHeight = height;
        return weakSelf;
    };
}

///最大行高
- (BaseParagraphStyleHandler *(^)(CGFloat height)) setUpMaximumLineHeight {
    __weak typeof(self) weakSelf = self;
    return ^(CGFloat height) {
        weakSelf.style.maximumLineHeight = height;
        return weakSelf;
    };
}

///段与段之间的间距
- (BaseParagraphStyleHandler *(^)(CGFloat spacing)) setUpParagraphSpacing {
    __weak typeof(self) weakSelf = self;
    return ^(CGFloat spacing) {
        weakSelf.style.paragraphSpacing = spacing;
        return weakSelf;
    };
}

///段首行空白空间/* Distance between the bottom of the previous paragraph (or the end of its paragraphSpacing, if any)and the top of this paragraph. */
- (BaseParagraphStyleHandler *(^)(CGFloat spacing)) setUpParagraphSpacingBefore {
    __weak typeof(self) weakSelf = self;
    return ^(CGFloat spacing) {
        weakSelf.style.paragraphSpacingBefore = spacing;
        return weakSelf;
    };
}


///从左到右的书写方向（一共➡️三种）
- (BaseParagraphStyleHandler *(^)(NSWritingDirection direction)) setUpBaseWritingDirection {
    __weak typeof(self) weakSelf = self;
    return ^(NSWritingDirection direction) {
        weakSelf.style.baseWritingDirection = direction;
        return weakSelf;
    };
}

/**
 Natural line height is multiplied by this factor (if positive)
 before being constrained by minimum and maximum line height.
 */
- (BaseParagraphStyleHandler *(^)(CGFloat height)) setUpLineHeightMultiple {
    __weak typeof(self) weakSelf = self;
    return ^(CGFloat height) {
        weakSelf.style.lineHeightMultiple = height;
        return weakSelf;
    };
}


///连字属性 在iOS，唯一支持的值分别为0和1
- (BaseParagraphStyleHandler *(^)(CGFloat hyphenationFactor)) setUpHyphenationFactor {
    __weak typeof(self) weakSelf = self;
    return ^(CGFloat hyphenationFactor) {
        weakSelf.style.hyphenationFactor = hyphenationFactor;
        return weakSelf;
    };
}
@end
