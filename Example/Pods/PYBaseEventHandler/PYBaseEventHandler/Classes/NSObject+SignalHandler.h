//
//  NSObject+signalHandler.h
//  PYSegmentView
//
//  Created by 李鹏跃 on 2018/9/10.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+T.h"

typedef id(^SignalCallBack)(NSString *key, id message);

static BOOL NSObject_signalHandlerIsLog = true;
@interface NSObject (signalHandler)

- (id) send: (NSString *)key andData: (id) message;
- (void) receivedWithSender:(NSObject *)sender andSignal: (SignalCallBack) signal;
+ (void) stitchSignalWithSender: (NSObject *)sender andReceiver: (NSObject *)receiver;
@end
