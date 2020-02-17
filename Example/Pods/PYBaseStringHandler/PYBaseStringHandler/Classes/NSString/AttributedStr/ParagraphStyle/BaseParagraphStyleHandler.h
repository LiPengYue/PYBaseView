//
//  BaseParagraphStyleHandler.h
//  yiapp
//
//  Created by 衣二三 on 2019/2/27.
//  Copyright © 2019年 yi23. All rights reserved.
//
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface BaseParagraphStyleHandler : NSObject

+ (BaseParagraphStyleHandler *) createWithStyle;
+ (BaseParagraphStyleHandler *(^)(void)) handler;

/// NSMutableParagraphStyle
@property (nonatomic,strong) NSMutableParagraphStyle *style;
@end

NS_ASSUME_NONNULL_END
