//
//  BaseParagraphStyleHandler.m
//  yiapp
//
//  Created by 衣二三 on 2019/2/27.
//  Copyright © 2019年 yi23. All rights reserved.
//

#import "BaseParagraphStyleHandler.h"

@implementation BaseParagraphStyleHandler

+ (BaseParagraphStyleHandler *) createWithStyle {
    return [self new];
}

+ (BaseParagraphStyleHandler *(^)(void)) handler {
    return ^{
        return [self createWithStyle];
    };
}

- (NSMutableParagraphStyle *)style {
    if (!_style) {
        _style = [NSMutableParagraphStyle new];
    }
    return _style;
}
@end
