//
//  NSMutableAttributedString+ChangeStyle.h
//  AttributedString
//
//  Created by 李鹏跃 on 2018/8/25.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

#import "BaseFiltrateRulerHeader.h"

#import "BaseAttriButedStrHandler.h"
#import "BaseParagraphStyleHandler.h"
#import "BaseStringHandler.h"
#import "NSAttributedString+Size.h"


typedef void(^SingleCallBack)(void);

@interface BaseAttributedStrHandler (ChangeStyle)
- (void) setUpWeakSelfFunc: (void(^)(BaseAttributedStrHandler *weak))block;
+ (BaseAttributedStrHandler *) createWithImage: (UIImage *)image andBounds: (CGRect)bounds;
+ (BaseAttributedStrHandler *) createWithImageName: (NSString *)name andBounds: (CGRect)bounds;

- (NSRange) range;
- (CFRange) getCfRange;

/**
 拼接attributedString
 */
- (BaseAttributedStrHandler *(^)(BaseAttributedStrHandler *str)) append;
/**
 拼接attributedString
 */
- (BaseAttributedStrHandler *(^)(NSAttributedString *str)) appendStr;
/**
 * 设置 AttributedString 指定range的属性
 */
- (instancetype) setupInRange:(NSRange)range andCallBack: (void(^)(BaseAttributedStrHandler *attributedStr))callBack;



// MARK: - 基础类型设置
// MARK: 链式方法
/**
 * 设置text foregroundColor
 */
- (BaseAttributedStrHandler *(^)(UIColor *)) setUpColor;
/**
 * 设置font
 */
- (BaseAttributedStrHandler *(^)(UIFont *)) setUpFont;
/**
 * 添加link
 */
- (BaseAttributedStrHandler *(^)(NSString *)) setUpLink;
/**
 * 字间距
 */
- (BaseAttributedStrHandler *(^)(CGFloat)) setUpKern;
/**
 * 背景色
 */
- (BaseAttributedStrHandler *(^)(UIColor *color)) setUpBackgroundColor;
/**
 *字符连体，NSLigatureAttributeName
 */
- (BaseAttributedStrHandler *(^)(BOOL isLigature)) setUpIsLigature;
/**
 * 描绘边颜色
 */
- (BaseAttributedStrHandler *(^)(UIColor *color)) setUpStrokeColor;
/**
 * 描边宽度
 */
- (BaseAttributedStrHandler *(^)(CGFloat width)) setUpStrokeWidth;
/**
 * 阴影
 */
- (BaseAttributedStrHandler *(^)(NSShadow *shadow)) setUpShadow;
/**
 * 字体效果
 */
- (BaseAttributedStrHandler *(^)(NSAttStrChangeStyleLineStyleEffectEnum effect)) setUpTextEffect;

- (BaseAttributedStrHandler *(^)(NSTextAttachment *attachment)) setUpAttachment;

/**
 * 基础偏移量
 */
- (BaseAttributedStrHandler *(^)(CGFloat offset)) setUpBaselineOffset;

/**
 * 下划线颜色
 */
- (BaseAttributedStrHandler *(^)(UIColor *color)) setUpUnderLineColor;
/**
 * 删除线
 */
- (BaseAttributedStrHandler *(^)(NSAttStrChangeStyleLineStyleEnum style, UIColor *color,NSNumber *OffsetAttributeName))setUpStrikethrough;
/**
 * 字体倾斜度
 */
- (BaseAttributedStrHandler *(^)(CGFloat obliqueness)) setUpObliqueness;

/**
 * 字体扁平化 {NSExpansionAttributeName:@(1.0)}
 */
- (BaseAttributedStrHandler *(^)(CGFloat expansion)) setUpExpansion;
/**
 * 垂直或者水平，value是 NSNumber，0表示水平，1垂直
 */
- (BaseAttributedStrHandler *(^)(BOOL isVertical)) setUpIsVertical;

/**
 * 展示风格 绘图的风格（居中，换行模式，间距等诸多风格），
 * @warning value是NSParagraphStyle对象 NSMutableParagraphStyle
 */
- (BaseAttributedStrHandler *(^)(NSMutableParagraphStyle *style)) setUpMutableParagraphStyle;

- (BaseAttributedStrHandler *(^)(BaseParagraphStyleHandler *style)) setUpStyleHandler;

/**
 * @brief 添加下划线
 * color 颜色.  style
 * @return 返回self.
 */
- (BaseAttributedStrHandler *(^)(NSAttStrChangeStyleLineStyleEnum style, UIColor *color)) setUpAddBottomLine;

/// 描边
- (BaseAttributedStrHandler *(^)(CGFloat width, UIColor *color)) setUpStroke;

/**
 * @brief    简要描述.
 *
 * 详细描述或其他.
 * @warning 警告:中间的代码在引用外部的变量的时候，需要用weak修饰 否则会导致循环引用
 *
 * 代码:
 *
 *     [NSMutebleAttributedString 对象]
 *     .registerSingleClick(^{
 *      注意中间引用对象 需要用weak修饰
 *      [weakSelf singleEventFunc];
 *      });
 */
- (BaseAttributedStrHandler *(^)(SingleCallBack singleCallBack)) setUpRegisterSingleClick;


// MARK: 对象方法
/// 文字颜色，
- (instancetype) foregroundColor: (UIColor *)color;
- (instancetype) font: (UIFont *)font;
/// 背景色，
- (instancetype) backgroundColor: (UIColor *)color;
/// 字符连体
- (instancetype) ligature: (BOOL)isLigature;
/// 字符间隔
- (instancetype) kern: (CGFloat)kern;
/// 删除线
- (instancetype) strikethroughStyle: (NSNumber *)value;
/// 下划线
- (instancetype) underlineStyle: (NSNumber *)value;
/// 描绘边颜色
- (instancetype) strokeColor: (UIColor *)color;
/// 描边宽度
- (instancetype) strokeWidth: (CGFloat) width;
/// 阴影
- (instancetype) shadow: (NSShadow *)shadow;
/// 文字效果
- (instancetype) textEffect: (NSString *)effect;
/// 附属
- (instancetype) attachment: (NSTextAttachment *)value;
/// 链接
- (instancetype) linkString: (NSString *)string;
/// 基础偏移量
- (instancetype) baselineOffset: (CGFloat)offset;
/// 下划线颜色
- (instancetype) underLineColor: (UIColor *)color;
/// 删除线颜色
- (instancetype) strikethroughColor: (UIColor *)color;
/// 字体倾斜
- (instancetype) obliqueness: (CGFloat)value;
/// 字体扁平化
- (instancetype) expansion: (CGFloat)value;
/// 垂直或者水平 0表示水平，1垂直
- (instancetype) verticalGlyph: (BOOL) isVertical;
/// 展示风格 绘图的风格（居中，换行模式，间距等诸多风格）
- (instancetype) mutableParagraphStyle: (NSMutableParagraphStyle *)style;
/**
 * @brief 添加下划线
 *
 * @param  color 颜色.
 * @param  style NSUnderlineStyleSingle、 NSUnderlineStyleDouble、 NSUnderlineStyleThick、NSUnderlineStyleNone
 * @return 返回self.
 */
- (instancetype) addBottomLineWithColor: (UIColor *)color
                               andStyle: (NSAttStrChangeStyleLineStyleEnum)style;

- (instancetype) strokeWithWidth: (CGFloat)w
                        andColor: (UIColor *)color;

//@property (nonatomic,weak) NSObject *eventTarget;
@end
