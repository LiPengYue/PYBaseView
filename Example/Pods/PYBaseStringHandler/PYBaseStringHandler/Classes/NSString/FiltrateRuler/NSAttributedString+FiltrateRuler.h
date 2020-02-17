//
//  NSAttributedString+FiltrateRuler.h
//  AttributedString
//
//  Created by 李鹏跃 on 2018/8/27.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AttributedStrFiltrateRuler.h"
/// 查询
@interface NSAttributedString (FiltrateRuler)

/// 根据多个 AttributedStrFiltrateRuler 查询匹配
- (NSArray <AttributedStrFiltrateRuler *>*) filtrates: (NSArray <AttributedStrFiltrateRuler *>*)filtrateRulerArray;

/// 查询匹配
- (AttributedStrFiltrateRuler *) filtrate: (AttributedStrFiltrateRuler *)ruler;
@end
