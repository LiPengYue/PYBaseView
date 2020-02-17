//
//  BaseColor.h
//  PYKit
//
//  Created by 李鹏跃 on 2018/9/11.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef struct {
    CGFloat R;
    CGFloat G;
    CGFloat B;
    CGFloat A;
}STRUCT_ColorRGBA;


@interface BaseColorHandler : NSObject

/**
 创建color 根据字符串或者number 或者color
 */
+ (BaseColorHandler *(^)(id color)) handle;

/// 被编辑的color
@property (nonatomic,strong) UIColor *color;

/// 黑色 blackColor
@property(class, nonatomic, readonly) UIColor *cBlack;
/// 深灰 grayColor
@property(class, nonatomic, readonly) UIColor *cGrayD;
/// 浅灰 lightGrayColor
@property(class, nonatomic, readonly) UIColor *cGrayL;


/// 获取self red 值 [0,1];
@property (nonatomic,assign,readonly) CGFloat r;
/// 获取self green 值 [0,1];
@property (nonatomic,assign,readonly) CGFloat g;
/// 获取self blue 值 [0,1];
@property (nonatomic,assign,readonly) CGFloat b;
/// 获取self alpha 值 [0,1];
@property (nonatomic,assign,readonly) CGFloat a;


/// 颜色转换：iOS中（以#开头）十六进制的颜色转换为UIColor(RGB)
+ (UIColor *(^)(NSString *hexStr)) cHexStr;
+ (UIColor *(^)(NSInteger hex)) cHex;
+ (UIColor *(^)(NSInteger hex, CGFloat alpha)) cHexWithAlpha;

/// rgb 相同，a为1的 颜色（element: [0,255]）
+ (UIColor *(^)(NSInteger element)) cElement;

/**
 获取self的rgba
 */
- (STRUCT_ColorRGBA (^)(void)) getRGBA;
/**
 根据 self的gba 以及传入的r 创建一个color
 */
- (UIColor *(^)(CGFloat r)) copyByR;
/**
 根据 self的rba 以及传入的g 创建一个color
 */
- (UIColor *(^)(CGFloat g)) copyByG;
/**
 根据 self的aga 以及传入的b 创建一个color
 */
- (UIColor *(^)(CGFloat b)) copyByB;
/**
 根据 self的rgb 以及传入的a 创建一个color
 */
- (UIColor *(^)(CGFloat a)) copyByA;
@end

NS_ASSUME_NONNULL_END
