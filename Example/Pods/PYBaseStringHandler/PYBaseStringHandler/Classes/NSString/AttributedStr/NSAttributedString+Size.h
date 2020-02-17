//
//  NSAttributedString+Size.h
//  yiapp
//
//  Created by 李鹏跃 on 2018/10/23.
//  Copyright © 2018年 yi23. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface NSAttributedString (Size)

/**
 * 获取最大行数
 */
- (NSInteger) getMaxLineWithSize: (CGSize)maxSize ;
//- (NSInteger (^)(CGSize maxSize)) getMaxLineWithMaxSize;

/**
 获取高度
 
 @param w 约定宽度
 @return 特定w下的H
 */
- (CGFloat) getHeightWithWidth: (CGFloat)w;
//- (CGFloat(^)(CGFloat w)) getHeightWithMaxW;
/**
 获取宽度
 
 @param H 高度
 @return 特定H下的W
 */
- (CGFloat) getWidthWithHeight: (CGFloat)H;
//- (CGFloat(^)(CGFloat H)) getWidthtWithMaxH;

/**
 获取size
 
 @param size 约束的size
 @return size
 */
- (CGSize) getSizeWithSize: (CGSize) size;

/**
 * @brief  获取某一行的frame，
 
 * @param numberOfLines ，第numberOfLines的frame，
 * @warning numberOfLines 从0 开始计数 而不是1
 * @warning 如果numberOfLines > 最大行数，那么返回最后一行的frame
 * @return 如果没有text，或者attributedString，返回CGRectZero,
 */
- (CGRect) getNumberOfLineFrame:(NSInteger)numberOfLines
                        andSize:(CGSize)maxSize;

- (CGRect)getLineBounds:(CTLineRef)line
                  point:(CGPoint)point;

/**
 根据 self.attributedString 的length 获取缩放后的font与当前宽度
 @param maxWidth 最大宽度
 @param maxFont 最大的font
 @return 计算后的近似font值与对应的width
 @warning 返回的是能全部显示情况下的 最大的Width，与最大font，
 @warning self.font 必须是统一字体。不能多字体
 */
- (NSMutableAttributedString *) scaleFontByMaxWidth: (CGFloat)maxWidth
                                     andMaxFont: (UIFont *)maxFont
                                       andBlock: (void(^)(UIFont *font, CGFloat currentWidth))block ;
@end
