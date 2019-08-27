//
//  BaseButton+Handler.h
//  AttributedString
//
//  Created by 李鹏跃 on 2018/9/11.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PYBaseButtonHandler: NSObject

+ (PYBaseButtonHandler *(^)(UIButton *button)) handle;

///
@property (nonatomic,strong) UIButton *button;

/**
 * @brief 设置state对应的button样式
 *
 * 当调用adjustButtonStyleWithState方法时，button才会改变到相应的样式
 * @warning 注意: 非线程安全，到主线程更新参数
 */
- (void)setUpStyle:(NSInteger) state style:(void(^)(PYBaseButtonHandler *handler))callBack;

/**
 * @brief 改变通过 setUpStyle:do: 方法设置好的button样式
 *
 * @warning 注意: 如果某个样式没有找到相应state下的值，就会设置成normal状态下的样式 如果normal状态下仍未找到，则保持当前状态
 */
- (void) adjustButtonStyleWithState: (NSInteger) state;
    
- (PYBaseButtonHandler *(^)(CGFloat)) setUpCornerRadius;

#pragma mark - font
/**
 * @brief 设置normal 状态下的Font
 *
 * @return 返回 一个返回self的block.
 *
 * @warning 注意: 在 setUpStyle:setUp: 方法中 设置state对应的font
 * @bug 需要保证 self != nil
 */
- (PYBaseButtonHandler *(^)(UIFont *)) setUpFont;


/**
 * @brief UIColor 设置normal 状态下的titleColor
 * @warning 注意: 在 setUpStyle:setUp: 方法中 设置state对应的titleColor
 * @warning 注意: 设置的是button 当前状态下的color
 * @warning 参数类型: UIColor
 * @bug 需要保证 self != nil
 */
- (PYBaseButtonHandler *(^)(UIColor *)) setUpTitleColor;

/**
 * @brief UIColor 设置normal 状态下的背景色
 * @warning 注意: 在 setUpStyle:setUp: 方法中 设置state对应的backgroundColor
 * @warning 注意: 设置的是button 当前状态下的color
 * @warning 参数类型: UIColor
 * @bug 需要保证 self != nil
 */
- (PYBaseButtonHandler *(^)(UIColor *)) setUpBackgroundColor;

/**
 * @brief NSString 设置normal 状态下的Font
 * @warning 注意: 在 setUpStyle:setUp: 方法中 设置state对应的title
 * @warning 参数类型: NSString
 * @bug 需要保证 self != nil
 */
- (PYBaseButtonHandler *(^)(NSString *)) setUpTitle;

/**
 * @brief NSAttributedString 设置normal 状态下的 AttributedString
 * @warning 注意: 在 setUpStyle:setUp: 方法中 设置state对应的AttributedString
 * @warning 参数类型: NSAttributedString
 * @bug 需要保证 self != nil
 */
- (PYBaseButtonHandler *(^)(NSAttributedString *)) setUpAttributedString;


/**
 * @brief 设置normal 状态下的image
 * @warning 注意: 在 setUpStyle:setUp: 方法中 设置的是对应state的image
 * @warning 参数类型: UIImage
 * @bug 需要保证 self != nil
 */
- (PYBaseButtonHandler *(^)(UIImage *)) setUpImage;
/**
 * @brief NSString 设置normal 状态下的image
 * @warning 注意: 在 setUpStyle:setUp: 方法中 设置的是对应state的image
 * @warning 参数类型: NSString
 */
- (PYBaseButtonHandler *(^)(NSString *name)) setUpImageName;

/**
 * @brief UIImage 设置normal 状态下的backgroundImage
 * @warning 注意: 在 setUpStyle:setUp: 方法中 设置的是对应state的backgroundImage
 * @warning 参数类型: UIImage
 * @bug 需要保证 self != nil
 */
- (PYBaseButtonHandler *(^)(UIImage *)) setUpBackgroundImage;
/**
 * @brief NSString 设置normal 状态下的backgroundImage
 * @warning 注意: 在 setUpStyle:setUp: 方法中 设置的是对应state的backgroundImage
 * @warning 参数类型: NSString
 * @bug 需要保证 self != nil
 */
- (PYBaseButtonHandler *(^)(NSString *)) setUpBackgroundImageName;
/**
 * @brief CGFloat 设置normal 状态下的layer BorderWidth
 *
 * @warning 注意: 在 setUpStyle:setUp: 方法中 设置的是对应state的BorderWidth
 * @warning 参数类型: CGFloat
 * @bug 需要保证 self != nil
 */
- (PYBaseButtonHandler *(^)(CGFloat)) setUpBorderWidth;

/**
 * @brief UIColor 设置normal 状态下的layer border color
 * @warning 注意: 在 setUpStyle:setUp: 方法中 设置的是对应state的BorderColor
 * @warning 参数类型: UIColor
 * @bug 需要保证 self != nil
 */
- (PYBaseButtonHandler *(^)(UIColor *)) setUpBorderColor;
/**
 * @brief UIEdgeInsets 设置normal 状态下的imageEdgeInsets
 * @warning 注意: 在 setUpStyle:setUp: 方法中 设置的是对应state的imageEdgeInsets
 * @warning 参数类型:  上左下右 四个CGFloat
 */
//- (BaseButton *(^)(CGFloat,CGFloat,CGFloat,CGFloat)) setUpImageEdgeInsets;
/**
 * @brief UIEdgeInsets 设置normal 状态下的titleEdgeInsets
 * @warning 注意: 在 setUpStyle:setUp: 方法中 设置的是对应state的titleEdgeInsets
 * @warning 参数类型: 上左下右 四个CGFloat
 */
//- (BaseButton *(^)(CGFloat,CGFloat,CGFloat,CGFloat)) setUpTitleEdgeInsets;

@property (nonatomic,assign) NSInteger state;
@property (nonatomic,strong) NSMutableDictionary <NSNumber *,UIColor *>*backgroundColorDictionaryM;
@property (nonatomic,strong) NSMutableDictionary <NSNumber *,UIColor *>*borderColorDictionaryM;
@property (nonatomic,strong) NSMutableDictionary <NSNumber *,NSNumber *>*borderWidthDictionaryM;
@property (nonatomic,strong) NSMutableDictionary <NSNumber *,UIFont *>*fontDictionaryM;
@property (nonatomic,strong) NSMutableDictionary <NSNumber *, NSNumber *> *cornerRadiusDictionaryM;
    

@property (nonatomic,strong) NSMutableDictionary <NSNumber *,UIColor *>*titleColorDictionaryM;
@property (nonatomic,strong) NSMutableDictionary <NSNumber *,UIImage *>*imageDictionaryM;
@property (nonatomic,strong)  NSMutableDictionary<NSNumber *,NSString *> *titleDictionaryM;
@property (nonatomic,strong)  NSMutableDictionary<NSNumber *,NSAttributedString *> *titleAttriStrDictionaryM;
@property (nonatomic,strong)  NSMutableDictionary<NSNumber *,UIImage *> *bgImageDictionaryM;
    
@property (nonatomic,assign) BOOL py_isSetupingState;
@end
