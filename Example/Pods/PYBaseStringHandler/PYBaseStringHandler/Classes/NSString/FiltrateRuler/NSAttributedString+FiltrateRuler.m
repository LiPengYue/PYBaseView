//
//  NSAttributedString+FiltrateRuler.m
//  AttributedString
//
//  Created by 李鹏跃 on 2018/8/27.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

#import "NSAttributedString+FiltrateRuler.h"
#import "NSString+FiltrateRuler.h"

@implementation NSAttributedString (FiltrateRuler)
/// 根据多个 AttributedStrFiltrateRuler 查询匹配
- (NSArray <AttributedStrFiltrateRuler *>*) filtrates: (NSArray <AttributedStrFiltrateRuler *>*)filtrateRulerArray {
    return [self.string filtrates:filtrateRulerArray];
}

/// 查询匹配
- (AttributedStrFiltrateRuler *) filtrate: (AttributedStrFiltrateRuler *)ruler {
    return [self filtrate:ruler];
}
@end
