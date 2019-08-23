//
//  AppDelegate.h
//  StarAnimation
//
//  Created by 李鹏跃 on 17/1/24.
//  Copyright © 2017年 13lipengyue. All rights reserved.
//
#import "PYBaseGradientView.h"

@interface PYBaseGradientView()

@property (nonatomic,strong) PYBaseGradientViewDrawRadialConfig *drawRadialConfig;
@property (nonatomic,strong) PYBaseGradientViewLineConfig *drawLineConfig;
@property (nonatomic,assign) BOOL isFirstLayout;
@property (nonatomic,assign) BOOL isDrawLine;
@end


@implementation PYBaseGradientView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isFirstLayout = true;
    }
    return self;
}
- (void) drawLineGradient: (void(^)(PYBaseGradientViewLineConfig *lineConfig))drawLine {
    if (drawLine) {
        drawLine(self.drawLineConfig);
        self.isDrawLine = true;
    }
    [self setNeedsDisplay];
}
- (void) drawRadialGradient: (void(^)(PYBaseGradientViewDrawRadialConfig *radialConfig))drawRadial {
    if (drawRadial) {
        drawRadial(self.drawRadialConfig);
        self.isDrawLine = false;
    }
    [self setNeedsDisplay];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.isFirstLayout) {
        [self setNeedsDisplay];
        self.isFirstLayout = false;
    }
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (self.drawRadialConfig.colorArray.count > 0 && !self.isDrawLine) {
        [self drawRadialGradientWithContext:context];
    }
    if (self.drawLineConfig.colorArray.count > 0 && self.isDrawLine) {
        [self drawLineGradientWithContext: context];
    }
}

#pragma mark 线性渐变
- (void) drawLineGradientWithContext: (CGContextRef)context {
    //2.创建色彩空间
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    
    //3.创建渐变对象
    NSInteger count = self.drawLineConfig.colorArray.count;
    CGFloat *components = [self parseColorArray:self.drawLineConfig.colorArray];
    CGFloat *locations = [self parseLocationWithArray:self.drawLineConfig.locationArray andLenth:count];
    CGGradientRef gradientRef = CGGradientCreateWithColorComponents(colorSpaceRef,components,locations,count);
    PYBaseGradientViewLineConfig *config = self.drawLineConfig;
    CGPoint startCenter = [self getCenterWithCenter:config.startCenter andScaleCenter:config.startScaleCenter];
    CGPoint endCenter = [self getCenterWithCenter:config.endCenter andScaleCenter:config.endScaleCenter];
    
    CGContextDrawLinearGradient(context,
                                gradientRef,
                                startCenter,
                                endCenter,
                                config.options);
    [self freeArray:components];
    [self freeArray:locations];
    CFRelease(colorSpaceRef);
    CFRelease(gradientRef);
}


#pragma mark 径向渐变
-(void)drawRadialGradientWithContext:(CGContextRef)context{
    //使用rgb颜色空间
    CGColorSpaceRef colorSpace=CGColorSpaceCreateDeviceRGB();
    
    /*指定渐变色
     space:颜色空间
     components:颜色数组,注意由于指定了RGB颜色空间，那么四个数组元素表示一个颜色（red、green、blue、alpha），
     如果有三个颜色则这个数组有4*3个元素
     locations:颜色所在位置（范围0~1），这个数组的个数不小于components中存放颜色的个数
     count:渐变个数，等于locations的个数
     */
    /// 分析color的ARGB
    NSInteger count = self.drawRadialConfig.colorArray.count;
     CGFloat *compoents = [self parseColorArray:self.drawRadialConfig.colorArray];

    CGFloat *locations= [self parseLocationWithArray:self.drawRadialConfig.locationArray andLenth:count];
    CGGradientRef gradient= CGGradientCreateWithColorComponents(colorSpace, compoents, locations, count);
    
    /*绘制径向渐变
     context:图形上下文
     gradient:渐变色
     startCenter:起始点位置
     startRadius:起始半径（通常为0，否则在此半径范围内容无任何填充）
     endCenter:终点位置（通常和起始点相同，否则会有偏移）
     endRadius:终点半径（也就是渐变的扩散长度）
     options:绘制方式,kCGGradientDrawsBeforeStartLocation 开始位置之前就进行绘制，但是到结束位置之后不再绘制，
     kCGGradientDrawsAfterEndLocation开始位置之前不进行绘制，但到结束点之后继续填充
     */
    PYBaseGradientViewDrawRadialConfig *config = self.drawRadialConfig;
    CGPoint startCenter = [self getCenterWithCenter:config.startCenter andScaleCenter:config.startScaleCenter];
    CGPoint endCenter = [self getCenterWithCenter:config.endCenter andScaleCenter:config.endScaleCenter];
    
   
    CGContextDrawRadialGradient(context,
                                gradient,
                                startCenter,
                                config.startRadius,
                                endCenter,
                                config.endRadius,
                                config.options);
    //释放颜色空间
    CGColorSpaceRelease(colorSpace);
    //释放变色对象
    CGGradientRelease(gradient);
    //释放开辟的颜色数组内存空间
    [self freeArray: compoents];
    [self freeArray:locations];
}

- (CGPoint) getCenterWithCenter:(CGPoint)center andScaleCenter: (CGPoint)scaleCenter {
    if(!CGPointEqualToPoint(center, BaseGradientViewConfigPointDefault)) {
        return center;
    }
    if (!CGPointEqualToPoint(scaleCenter, BaseGradientViewConfigPointDefault)) {
        CGFloat x = self.frame.size.width * scaleCenter.x;
        CGFloat y = self.frame.size.height * scaleCenter.y;
        return CGPointMake(x, y);
    }
    NSLog(@". \n 🌶  %@: 获取Center失败",[self class]);
    return CGPointMake(0, 0);
}

- (CGFloat *)parseColorArray: (NSArray <UIColor *>*)colorArray {
    NSInteger count = colorArray.count;
    CGFloat *compoents = [self createArrayWithLenth:4 * count];
    for (int idx = 0; idx < count; idx ++) {
        UIColor *color = colorArray[idx];
        CGFloat r,g,b,a = 0;
        [color getRed:&r green:&g blue:&b alpha:&a];
        NSInteger currentIMinValue = idx * 4;
        CGFloat RGBA[4] = {r,g,b,a};
        for (NSInteger i = currentIMinValue; i < 4 * (idx + 1); i ++) {
            /// 获取ARGB
            compoents[i] = RGBA[i-currentIMinValue];
        }
    }
    return compoents;
}


- (CGFloat *) parseLocationWithArray: (NSArray <NSNumber *>*)array andLenth: (NSInteger)lenth{
    NSInteger count = lenth;
    CGFloat *locations = [self createArrayWithLenth:count];
    
    for (int i = 0; i < count; i++) {
        CGFloat value = 1;
        if (array.count <= i) {
            value = array.lastObject.floatValue;
        }else{
            value = array[i].floatValue;
        };
        locations[i] = value;
        
    }
    return locations;
}


/**
 创建c数组

 @param len 长度
 @return 返回c数组
 */
- (CGFloat *)createArrayWithLenth: (NSInteger)len {
    return malloc(sizeof(CGFloat) * len);
}

- (void) freeArray: (CGFloat *)array {
    free(array);
}

- (CGFloat *)arrayAddLenth: (NSInteger)len andArray: (CGFloat *)array{
    len = sizeof(array)/sizeof(*array) + len;
    CGFloat *array_old = array;
    
    array = (CGFloat *)realloc(array,sizeof(CGFloat)*len);
    
    /**
     *如果地址改变，代表内存在另一个地方划分了一个新的内存空间，
     *要释放旧的内存空间
     */
    if(array_old != array)
        free(array_old);
    return array;
}

- (PYBaseGradientViewDrawRadialConfig *)drawRadialConfig {
    if (!_drawRadialConfig) {
        _drawRadialConfig = [PYBaseGradientViewDrawRadialConfig new];
    }
    return _drawRadialConfig;
}
- (PYBaseGradientViewLineConfig *)drawLineConfig {
    if (!_drawLineConfig) {
        _drawLineConfig = [PYBaseGradientViewLineConfig new];
    }
    return _drawLineConfig;
}
@end
