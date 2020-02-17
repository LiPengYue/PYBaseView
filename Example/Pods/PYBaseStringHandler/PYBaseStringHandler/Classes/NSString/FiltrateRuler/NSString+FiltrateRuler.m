//
//  NSString+FiltrateRuler.m
//  AttributedString
//
//  Created by 李鹏跃 on 2018/8/27.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

#import "NSString+FiltrateRuler.h"

@implementation NSString (FiltrateRuler)
/// 根据多个 AttributedStrFiltrateRuler 查询匹配
- (NSArray <AttributedStrFiltrateRuler *>*) filtrates: (NSArray <AttributedStrFiltrateRuler *>*)filtrateRulerArray {
    
    NSMutableArray *rulerArray = [filtrateRulerArray mutableCopy];
    [rulerArray enumerateObjectsUsingBlock:^(AttributedStrFiltrateRuler * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self filtrate:obj];
    }];
    return rulerArray;
}

/// 查询匹配

- (AttributedStrFiltrateRuler *) filtrate: (AttributedStrFiltrateRuler *)ruler {
    
    NSString *string = [self copy];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:ruler.expressionString options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray <NSTextCheckingResult *>* matches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    
    NSMutableArray <NSValue *> *resultRangeArray = [[NSMutableArray alloc]init];
    
    for (NSTextCheckingResult *match in matches) {
        [resultRangeArray addObject: [NSValue valueWithRange:match.range]];
    }
    
    ruler.resultRangeArray = resultRangeArray;
    ruler.textCheckingResultArray = matches;
    return ruler;
}
@end
