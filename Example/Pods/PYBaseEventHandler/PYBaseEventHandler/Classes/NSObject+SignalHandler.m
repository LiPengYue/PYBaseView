//
//  NSObject+SignalHandler.m
//  PYSegmentView
//
//  Created by 李鹏跃 on 2018/9/10.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

#import "NSObject+SignalHandler.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>


#ifdef DEBUG
# define DLog(...) NSLog(__VA_ARGS__);
#else
# define DLog(...);
#endif

@interface NSObject()
@property (nonatomic,copy) SignalCallBack signalCallBack;
@end

static NSString * const k_signalCallBack = @"k_signalCallBack";
@implementation NSObject (SignalHandler)

- (void) logNotRegisterBlock {
    
}

- (id) send: (NSString *)key andData: (id) message {
    
#ifdef DEBUG
    // 找到当前控制器：并打印
    UIViewController *vc = [NSObject getTopVC];
    NSString *vcName = NSStringFromClass([vc class]);
    NSString *currentClassName = NSStringFromClass([self class]);
    
    if (!self.signalCallBack) {
        DLog(@"\n 🌶🌶🌶\
              \n 【%@】： 暂时没有 注册block \
              \n 【key】：%@  \
              \n 【顶层VC】：%@\n",currentClassName,key,vcName);
        return nil;
    }
    DLog(@"\n  👌【key】： %@\
          \n  👌【sender】： %@\
          \n  👌【顶层VC】： %@\
          \n",key, currentClassName, vcName);
#endif
    if (!self.signalCallBack) return nil;
    return self.signalCallBack(key, message);
}

- (void) receivedWithSender:(NSObject *)sender andSignal: (SignalCallBack) signal{
    if (!sender) {
        DLog(@"\n  🌶🌶🌶 接收数据的时候，sender 为 nil\n  方法：receivedWithSender:andSignal:");
        return;
    }
    sender.signalCallBack = signal;
}

+ (void) stitchSignalWithSender: (NSObject *)sender andReceiver: (NSObject *)receiver {
    if (!sender) {
       DLog(@"\n  🌶🌶🌶 sender 为 nil\n  方法：stitchSignalWithSender:andReceiver:");
        return;
    }
    if (!receiver) {
        DLog(@"\n  🌶🌶🌶 receiver 为 nil\n  方法：stitchSignalWithSender:andReceiver:");
        return;
    }
    //restrict
    __weak typeof(receiver) weakReceiver = receiver;
    [NSObject receivedWithSender:sender andSignal:^id(NSString *key, id message) {
        return [weakReceiver send:key andData:message];
    }];
}


// MARK: - get && set
- (void) setSignalCallBack:(SignalCallBack)signalCallBack {
    objc_setAssociatedObject(self, &k_signalCallBack, signalCallBack, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (SignalCallBack)signalCallBack {
  SignalCallBack callBack = objc_getAssociatedObject(self, &k_signalCallBack);
    return callBack;
}

///获取Window当前显示的ViewController
+ (UIViewController *) getTopVC{
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (1) {
        //顶层控制器 可能是 UITabBarController的跟控制器
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        
        //顶层控制器 可能是 push出来的 或者是跟控制器
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        
        //顶层控制器 可能是 modal出来的
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
    }
    
    return vc;
}
@end


