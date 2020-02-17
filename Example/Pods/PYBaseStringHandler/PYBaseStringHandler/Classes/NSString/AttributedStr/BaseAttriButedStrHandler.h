//
//  BaseAttributedStrHandler.h
//  yiapp
//
//  Created by 衣二三 on 2019/2/27.
//  Copyright © 2019年 yi23. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseParagraphStyleHandler+Handler.h"
NS_ASSUME_NONNULL_BEGIN
@class BaseAttributedStrHandler;


@interface BaseAttributedStrHandler : NSObject
@property (nonatomic,assign) BOOL isHaveSyle;
+ (BaseAttributedStrHandler *(^)(NSString *str)) createWithStr;
+ (BaseAttributedStrHandler *(^)(NSAttributedString *str)) createWithAttributedStr;


/**
 创建一个 BaseAttributedStrHandler
 
 @ data 传入的需要转成NSAttributedString的数据
 @warning Data参数： 如果非NSString、NSAttributedString、那么那么执行[NSString stringWithFromart:@"%@",data] 函数，把data转成String
 @return BaseAttributedStrHandler 对象
 */
+ (BaseAttributedStrHandler *(^)(id data))handle;


/**
 创建一个 BaseAttributedStrHandler
 要处理的data信息 形成的富文本 中包含了 handler中设置的富文本信息
 @warning: 参数为 前面是handler对象 后面为data
 */
//+ (BaseAttributedStrHandler *(^)(BaseAttributedStrHandler *handler,id data)) handleDataWhitCopyHandler;
//判断是否为整形：
- (BOOL)isPureInt;
//判断是否为浮点形：
- (BOOL)isPureFloat;



/// attributedString
@property (nonatomic,strong) NSMutableAttributedString *str;
/// length
@property (nonatomic,assign,readonly) CGFloat length;

@end

NS_ASSUME_NONNULL_END
