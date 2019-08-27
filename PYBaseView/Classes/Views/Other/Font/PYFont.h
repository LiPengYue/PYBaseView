//
//  BaseFont.h
//  PYKit
//
//  Created by 李鹏跃 on 2018/9/11.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PYFont : NSObject

+ (UIFont *(^)(CGFloat size)) fontSCR;
+ (UIFont *(^)(CGFloat size)) fontSCL;
+ (UIFont *(^)(CGFloat size)) fontSCM;
+ (UIFont *(^)(CGFloat size)) fontSCB;

//平方字体PingFangSC-Medium
+ (UIFont *)pingFangSCLightFont:(CGFloat)size;
+ (UIFont *)pingFangSCMediumFont:(CGFloat)size;
+ (UIFont *)pingFangSCBoldFont:(CGFloat)size;

@end

NS_ASSUME_NONNULL_END
