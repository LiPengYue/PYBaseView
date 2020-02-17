//
//  BaseAttributedStrHandler.m
//  yiapp
//
//  Created by 衣二三 on 2019/2/27.
//  Copyright © 2019年 yi23. All rights reserved.
//

#import "BaseAttriButedStrHandler.h"
#import "BaseStringHandler.h"
#ifdef DEBUG
#    define DLog(...) NSLog(__VA_ARGS__)
#else
#    define DLog(...)
#endif
@implementation BaseAttributedStrHandler

+ (BaseAttributedStrHandler * _Nonnull (^)(id _Nonnull))handle {
    return ^(id data) {
        BaseAttributedStrHandler *handler;
        if ([data isKindOfClass:NSString.class]) {
            handler = BaseAttributedStrHandler.createWithStr(data);
        } else if ([data isKindOfClass:NSAttributedString.class]) {
            handler = BaseAttributedStrHandler.createWithAttributedStr(data);
            
        }else {
            
            NSString *dataStr = BaseStringHandler.handler(data).getStr;
            handler = BaseAttributedStrHandler.createWithStr(dataStr);
        }
        return handler;
    };
}

+ (BaseAttributedStrHandler *(^)(NSString *str)) createWithStr {
    return ^(NSString *str) {
        NSString *string = str.length <= 0 ? @"" : str;
        BaseAttributedStrHandler *handler = [BaseAttributedStrHandler new];
        handler.str = [[NSMutableAttributedString alloc]initWithString:string];
        return handler;
    };
}

+ (BaseAttributedStrHandler *(^)(NSAttributedString *str)) createWithAttributedStr {
    return ^(NSAttributedString *str) {
        BaseAttributedStrHandler *handler = [BaseAttributedStrHandler new];
        handler.str = str.mutableCopy;
        if ((str.length) <= 0) {
            handler.str = [[NSMutableAttributedString alloc]initWithString:@""];
        }
        return handler;
    };
}

- (CGFloat) length {
    return self.str.length;
}

- (NSMutableAttributedString *)str {
    if (!_str) {
        _str = [[NSMutableAttributedString alloc] initWithString:@""];
    }
    return _str;
}

//判断是否为整形：
- (BOOL)isPureInt{
    NSScanner* scan = [NSScanner scannerWithString:self.str.string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形：
- (BOOL)isPureFloat{
    NSScanner* scan = [NSScanner scannerWithString:self.str.string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

- (void)dealloc {
//    DLog(@"✅ 销毁 BaseAttributedStrHandler");
}

@end
