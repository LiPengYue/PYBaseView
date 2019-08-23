//
//  BaseLabel.h
//  AttributedString
//
//  Created by 李鹏跃 on 2018/8/27.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

NS_ASSUME_NONNULL_BEGIN

@interface PYBaseLabel : UILabel
/// 如果baseLabel没有宽度，在计算size的时候，就会以这个宽度为标准
@property (nonatomic,assign) CGFloat maxWidth;
@property (nonatomic,assign) CGSize currentTextSize;
@property (nonatomic,assign) CGSize allTextSize;

/**
 * @brief  获取从第一行到某一行的size，
 *
 * @param numberOfLines 从第一行到第numberOfLines行的size，（如果numberOfLines<=0 那么返回到text最后一行size）
 * @warning 警告:中间的代码在引用外部的变量的时候，需要用weak修饰 否则会导致循环引用
 * @return 如果没有text，或者attributedString，返回CGSizeZero,
 */
- (CGSize)getNumberOfLineFrame:(NSInteger)numberOfLines;

/// 获取某一行的frame
- (CGRect)getLineFrame:(NSInteger)numberOfLine;

- (CGRect)getLineBounds:(CTLineRef)line point:(CGPoint)point;

/// 把 framestter 与 ctFrame release，并在用到时自动生成
- (void)reloadFramestter;
@end

NS_ASSUME_NONNULL_END
