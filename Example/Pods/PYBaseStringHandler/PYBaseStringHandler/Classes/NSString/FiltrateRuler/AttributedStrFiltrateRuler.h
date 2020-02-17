//
//  AttributedStrFiltrateRuler.h
//  AttributedString
//
//  Created by 李鹏跃 on 2018/8/25.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttributedStrFiltrateRuler : NSObject

/// 正则表达式
@property (nonatomic,copy) NSString *expressionString;

/// 所有的符合条件的 range集合
@property (nonatomic,strong) NSMutableArray <NSValue *>*resultRangeArray;

/// NSTextCheckingResult
@property (nonatomic,strong) NSArray <NSTextCheckingResult *>*textCheckingResultArray;
@property (nonatomic,strong) UIColor *color;
@end
