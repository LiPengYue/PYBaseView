//
//  BaseGradientViewBaseConfig.m
//  LYPCALayer
//
//  Created by 李鹏跃 on 2018/11/27.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

#import "PYBaseGradientViewBaseConfig.h"

@implementation PYBaseGradientViewBaseConfig
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.startScaleCenter = BaseGradientViewConfigPointDefault;
        self.startCenter = BaseGradientViewConfigPointDefault;
        self.endCenter = BaseGradientViewConfigPointDefault;
        self.endScaleCenter = BaseGradientViewConfigPointDefault;
    }
    return self;
}
@end
