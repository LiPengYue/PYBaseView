//
//  BaseParagraphStyleHandler+Handler.h
//  AttributedString
//
//  Created by 李鹏跃 on 2018/9/11.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

#import "BaseParagraphStyleHandler.h"

@interface BaseParagraphStyleHandler (Handler)

/**
 * 字体的行间距
 * @warning CGFloat 类型
 */
- (BaseParagraphStyleHandler *(^)(CGFloat spacing)) setUpLineSpacing;

/**
 * 首行缩进
 * @warning CGFloat 类型
 */
- (BaseParagraphStyleHandler *(^)(CGFloat firstLineHeadIndent)) setUpFirstLineHeadIndent;

/**
 *（两端对齐的）文本对齐方式：（左，中，右，两端对齐，自然）
 * @warning NSTextAlignment 类型
 */
- (BaseParagraphStyleHandler *(^)(NSTextAlignment alignment)) setUpAlignment;

/**
 * 结尾部分的内容以……方式省略 ( "...wxyz" ,"abcd..." ,"ab...yz")
 * @warning NSLineBreakMode 类型
 */
- (BaseParagraphStyleHandler *(^)(NSLineBreakMode lineBreakMode)) setUpLineBreakMode;

/**
 * 整体缩进(首行除外)
 * @warning CGFloat 类型
 */
- (BaseParagraphStyleHandler *(^)(CGFloat headIndent)) setUpHeadIndent;

/**
 * 可调整文字尾端的缩排距离。
 * @warning 需要注意的是，这里指定的值可以当作文字显示的宽、而也可当作右边 padding 使用，依据输入的正负值而定：
 * @warning CGFloat 类型
 */
- (BaseParagraphStyleHandler *(^)(CGFloat tailIndent)) setUpTailIndent;

/**
 * 最低行高
 * @warning CGFloat 类型
 */
- (BaseParagraphStyleHandler *(^)(CGFloat height)) setUpMinimumLineHeight;

/**
 * 最大行高
 * @warning CGFloat 类型
 */
- (BaseParagraphStyleHandler *(^)(CGFloat height)) setUpMaximumLineHeight;

/**
 * 段与段之间的间距
 * @warning CGFloat 类型
 */
- (BaseParagraphStyleHandler *(^)(CGFloat spacing)) setUpParagraphSpacing;

/**
 * 段首行空白空间
 Distance between the bottom of the previous paragraph (or the end of its paragraphSpacing, if any)and the top of this paragraph.
 * @warning CGFloat 类型
 */
- (BaseParagraphStyleHandler *(^)(CGFloat spacing)) setUpParagraphSpacingBefore;


/**
 * 从左到右的书写方向（一共三种）
 * @warning NSWritingDirection 类型
 */
- (BaseParagraphStyleHandler *(^)(NSWritingDirection direction)) setUpBaseWritingDirection;

/**
 Natural line height is multiplied by this factor (if positive)
 before being constrained by minimum and maximum line height.
 * @warning CGFloat 类型
 */
- (BaseParagraphStyleHandler *(^)(CGFloat height)) setUpLineHeightMultiple;

/**
 * 连字属性 在iOS，唯一支持的值分别为0和1
 * @warning CGFloat 类型
 */
- (BaseParagraphStyleHandler *(^)(CGFloat hyphenationFactor)) setUpHyphenationFactor;

@end
