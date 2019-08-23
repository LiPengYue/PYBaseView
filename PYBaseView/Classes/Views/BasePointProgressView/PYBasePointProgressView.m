//
//  BasePointProgress.m
//  yiapp
//
//  Created by 衣二三 on 2019/4/8.
//  Copyright © 2019年 yi23. All rights reserved.
//

#import "PYBasePointProgressView.h"
#import "PYBaseAnimationProxy.h"
@interface PYBasePointProgressView()
<
CAAnimationDelegate
>

@property (nonatomic,strong) PYBaseAnimationProxy <CAAnimationDelegate>*proxy;

@property (nonatomic,strong) CAShapeLayer *bgLineLayer;
@property (nonatomic,strong) CAShapeLayer *frontLineLayer;
@property (nonatomic,strong) CALayer *lineLayer;

@property (nonatomic,strong) NSMutableArray *array;

@property (nonatomic,assign) BOOL isFirstLayout;
@property (nonatomic,assign) CGRect lastBounds;
@property (nonatomic,assign) CGFloat lastProgress;
@property (nonatomic,assign) CGFloat currentProgressWidth;
@property (nonatomic,assign) CGFloat lastProgressWidth;

@property (nonatomic,strong) UIPanGestureRecognizer *currentProgressViewPan;
@end

static NSString *const KANIMATIONCURRENTPROGRESSVIEW = @"KAnimation_currentProgressView";

static NSString *const KANIMATIONFRONTLINELAYER = @"KAnimationFrontLineLayer";

@implementation PYBasePointProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        [self setupProperty];
        [self.layer addSublayer:self.bgLineLayer];
        [self.layer addSublayer:self.frontLineLayer];
        [self addSubview:self.currentProgressView];
    }
    return self;
}

- (void) setupProperty {
    self.isFirstLayout = true;
    self.pointViewScaleCenterY = 0.5;
    self.animationDuration = 0.34;
    
    self.normalLineStyle = PYBasePointProgressLineDataMakeNormalDefult();
    self.frontLineStyle = PYBasePointProgressLineDataMakeHighlightDefult();
}

- (BOOL) isNotChangeBounds {
    return CGRectEqualToRect(self.lastBounds, self.bounds);
}

- (BOOL) isReDrowLine {
    BOOL isChaged = ![self isNotChangeBounds];
    if (isChaged) {
        self.lastBounds = self.bounds;
    }
    return isChaged;
}

- (void) layoutSubviews {
    [super layoutSubviews];
   
    if (self.subviews.count <= 0) {        
        [self relayoutViews];
    }
    
    if ([self isReDrowLine]) {
        [self dashLineWithLayer:self.bgLineLayer andStyle:self.normalLineStyle];
        [self dashLineWithLayer:self.frontLineLayer andStyle:self.frontLineStyle];
        [self adjustFrontLineProgress];
        [self addCurrentProgressViewAnimation];
        [self adjustBgLineProgress];
        [self adjustHierarchy];
        [self adjustCurrentProgressViewFrame];
    }
}

- (void) adjustHierarchy {
    if (self.normalLineStyle.isMovePointViewTop) {
        [self.layer addSublayer:self.bgLineLayer];
        [self.layer addSublayer:self.frontLineLayer];
    }
    
    if (self.frontLineStyle.isMovePointViewTop) {
        [self.layer addSublayer:self.frontLineLayer];
    }
}

- (void) adjustCurrentProgressViewFrame {
    
    CGFloat minX = self.frontLineLayer.frame.origin.x;
    CGFloat x = self.currentProgressWidth + minX;
    x = MAX(x, minX);
    CGFloat y = self.frame.size.height * self.frontLineStyle.lineScaleY;
    self.currentProgressView.center = CGPointMake(x, y);
}

- (void) relayoutViews {
    if ([self.frontLineAnimationDelegate respondsToSelector:@selector(createPointContentViewWithProgressView:)]) {
        [_allPointViewArray enumerateObjectsUsingBlock:^(PYBasePointProgressContentView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        _allPointViewArray = [self.frontLineAnimationDelegate createPointContentViewWithProgressView:self];
    }
    [self relayoutPointViews];
}

- (void) relayoutPointViews {
    
    __block CGFloat totalW = 0;
    [self.allPointViewArray enumerateObjectsUsingBlock:^(PYBasePointProgressContentView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGSize size = obj.bounds.size;
        BOOL isZero = CGSizeEqualToSize(CGSizeZero, size);
        if (isZero) {
            size = self.pointViewSize;
        }
        totalW += size.width;
    }];
    
    CGFloat maxW = self.frame.size.width;
    CGFloat margin = (maxW - totalW) / (self.allPointViewArray.count - 1);
   
    __block CGFloat left = 0;
    CGFloat y = self.frame.size.height * self.pointViewScaleCenterY;
    CGFloat currentProgressX = self.frame.size.width * self.currentProgress;
    
    [self.allPointViewArray enumerateObjectsUsingBlock:^(PYBasePointProgressContentView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        obj.frame = CGRectMake(left, y - obj.frame.size.height/2.0, obj.frame.size.width, obj.frame.size.height);
        
        if([self.frontLineAnimationDelegate respondsToSelector:@selector(willDisplayPointView:andIsSected:andIndexPath:)]) {
            CGFloat x = left;
            if (self.selectedType == PYBasePointProgressSelectedCenter) {
                x = obj.center.x;
            }
            BOOL isSelected = currentProgressX <= x;
            [self.frontLineAnimationDelegate willDisplayPointView:obj andIsSected:isSelected andIndexPath:idx];
        }
        
        left += margin;
        left += obj.frame.size.width;
        [self insertSubview:obj belowSubview:self.currentProgressView];
    }];
    
}

- (void) adjustBgLineProgress {
    CGFloat duration = self.bgAnimationDuration < 0 ? 0 : self.bgAnimationDuration;
    [self addAnimationBgLineWithDuration:duration];
}

- (void) adjustFrontLineProgress {
    CGFloat duration = self.animationDuration < 0 ? 0 : self.animationDuration;
    [self addAnimationFrontLineWithDuration:duration];
}

- (void) addAnimationBgLineWithDuration: (CGFloat) duration {
    //  设置路径
    self.bgLineLayer.strokeStart = 0.0f;   // 设置起点为 0
    self.bgLineLayer.strokeEnd = 1.0f;     // 设置终点为 0
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL,self.bgLineLayer.bounds.size.width, 0);
    self.bgLineLayer.path = path;
    CGPathRelease(path);
    
    CGFloat fromeValue = 0;
    CGFloat toValue = 1;
    NSString *animationKey = @"strokeEnd";
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:animationKey];
    animation.delegate = self.proxy;
    animation.duration = duration;   // 持续时间
    
    animation.fromValue = @(fromeValue); // 从 0 开始
    // 到 1 结束
    animation.toValue = @(toValue);
    
    // 保持动画结束时的状态
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    // 动画缓慢的进入，中间加速，然后减速的到达目的地。
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.bgLineLayer addAnimation:animation forKey:@"bgshapeLayer"];
}

- (void) addAnimationFrontLineWithDuration: (CGFloat)duration {
    //  设置路径
    self.frontLineLayer.strokeStart = 0.0f;   // 设置起点为 0
    self.frontLineLayer.strokeEnd = 1.0f;     // 设置终点为 0
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL,self.frontLineLayer.bounds.size.width, 0);
    self.frontLineLayer.path = path;
    CGPathRelease(path);
    
    CGFloat fromeValue = self.lastProgress;
    CGFloat toValue = self.currentProgress;
    
    
    NSString *animationKey = @"strokeEnd";
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:animationKey];
    animation.delegate = self.proxy;
    animation.duration = duration;   // 持续时间
    
    animation.fromValue = @(fromeValue); // 从 0 开始
    // 到 1 结束
    animation.toValue = @(toValue);
    
    // 保持动画结束时的状态
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    // 动画缓慢的进入，中间加速，然后减速的到达目的地。
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.frontLineLayer addAnimation:animation forKey:KANIMATIONFRONTLINELAYER];
}

- (void) addCurrentProgressViewAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.x"];

    CGFloat maxX = CGRectGetMaxX(self.frontLineLayer.frame);
    CGFloat minX = self.frontLineLayer.frame.origin.x;

    CGFloat frome = self.lastProgressWidth + minX;
    frome = MIN(frome,maxX);
    frome = MAX(frome, minX);
    
    CGFloat to = self.currentProgressWidth + minX;
    to = MIN(to,maxX);
    to = MAX(to, minX);
    
    animation.delegate = self.proxy;
    animation.duration = self.animationDuration;
    animation.fromValue = @(frome);
    animation.toValue = @(to);
    
    // 保持动画结束时的状态
//    animation.removedOnCompletion = NO;
//    animation.fillMode = kCAFillModeForwards;
    // 动画缓慢的进入，中间加速，然后减速的到达目的地。
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [self.currentProgressView.layer addAnimation:animation forKey:KANIMATIONCURRENTPROGRESSVIEW];
    self.currentProgressView.center = CGPointMake(self.currentProgressWidth + minX, self.currentProgressView.center.y);
}

- (void) setCurrentProgress:(CGFloat)currentProgress {
    if (_currentProgress == currentProgress) {
        return;
    }
    [self adjustProgressDataWithCurrentProgress:currentProgress];
    [self adjustFrontLineProgress];
    [self addCurrentProgressViewAnimation];
}

- (void) adjustProgressDataWithCurrentProgress: (CGFloat)currentProgress {
    _lastProgress = _currentProgress;
    _currentProgress = currentProgress;
    
    self.lastProgressWidth = self.currentProgressWidth;
    self.currentProgressWidth = self.frontLineLayer.frame.size.width * currentProgress;
}

/// 更新进度
- (void) reloadProgressToViewCenter: (PYBasePointProgressContentView *) view andOffset: (CGFloat) offsetX {
    
    CGFloat w = view.center.x + offsetX - self.frontLineLayer.frame.origin.x;
    [self adjustProgressDataWithCurrentProgress:w/self.frontLineLayer.frame.size.width];
    [self adjustFrontLineProgress];
    [self addCurrentProgressViewAnimation];
    
}

- (void) setCurrentProgressWithWidth:(CGFloat)width andAnimation:(BOOL)animation {
    CGFloat w = width;
    [self adjustProgressDataWithCurrentProgress:w/self.frontLineLayer.frame.size.width];
    CGFloat duration = self.animationDuration < 0 ? 0 : self.animationDuration;
    duration = animation ? duration : 0;
    [self addAnimationFrontLineWithDuration:duration];
}

- (void) setCurrentProgress:(CGFloat)currentProgress andAnimation:(BOOL)isAnimation {
    [self adjustProgressDataWithCurrentProgress:currentProgress];
    CGFloat duration = self.animationDuration < 0 ? 0 : self.animationDuration;
    duration = isAnimation ? duration : 0;
    [self addAnimationFrontLineWithDuration:duration];
}

/// 画虚线
- (void) dashLineWithLayer:(CAShapeLayer *)shapeLayer  andStyle: (PYBasePointProgressLineData)style {
    CGFloat y = self.frame.size.height * style.lineScaleY;
    CGFloat x = self.allPointViewArray.firstObject.frame.size.width/2.0;
    CGFloat right = self.allPointViewArray.lastObject.frame.size.width/2.0;
    CGFloat w = self.frame.size.width - x - right;
    shapeLayer.frame = CGRectMake(x, y, w, style.lineHeight);
    
    shapeLayer.fillColor = UIColor.clearColor.CGColor;
    shapeLayer.strokeColor = style.lineColor.CGColor;
    shapeLayer.lineWidth = style.lineHeight;
    shapeLayer.lineJoin = kCALineCapRound;
    
    if (style.marginLength >= 0.01) {
        shapeLayer.lineDashPattern = @[@(style.drowLength),@(style.marginLength)];
    }
}

- (void) setNormalLineStyle:(PYBasePointProgressLineData)normalLineStyle {
    _normalLineStyle = normalLineStyle;
    [self relayoutViews];
    [self dashLineWithLayer:self.bgLineLayer andStyle:normalLineStyle];
}

- (void) setfrontLineStyle:(PYBasePointProgressLineData)frontLineStyle {
    _frontLineStyle = frontLineStyle;
    [self relayoutViews];
    [self dashLineWithLayer:self.frontLineLayer andStyle:frontLineStyle];
}

- (PYBaseAnimationProxy *)proxy {
    if (!_proxy) {
        _proxy = [[PYBaseAnimationProxy <CAAnimationDelegate> alloc]initWithTarget:self];
    }
    return _proxy;
}

- (CAShapeLayer *)frontLineLayer {
    if (!_frontLineLayer) {
        _frontLineLayer = [CAShapeLayer new];
    }
    return _frontLineLayer;
}

- (CAShapeLayer *)bgLineLayer {
    if (!_bgLineLayer) {
        _bgLineLayer = [CAShapeLayer new];
    }
    return _bgLineLayer;
}

- (PYBasePointProgressContentView *)currentProgressView {
    if (!_currentProgressView) {
        _currentProgressView = [PYBasePointProgressContentView new];
        [_currentProgressView addGestureRecognizer:self.currentProgressViewPan];
    }
    return _currentProgressView;
}

- (UIPanGestureRecognizer *)currentProgressViewPan {
    if (!_currentProgressViewPan) {
        _currentProgressViewPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(currentProgressViewPanAction:)];
    }
    return _currentProgressViewPan;
}

- (void) currentProgressViewPanAction: (UIPanGestureRecognizer *)pan {
    CGFloat centerY = self.currentProgressView.center.y;
    CGPoint currentPoint;
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged:
           
            currentPoint = [pan translationInView:self.currentProgressView];
            currentPoint.x += self.currentProgressView.center.x;
          
            CGFloat centerX = currentPoint.x;

            centerX = MIN(centerX,CGRectGetMaxX(self.frontLineLayer.frame));
            centerX = MAX(centerX, self.frontLineLayer.frame.origin.x);
            
            self.currentProgressView.center = CGPointMake(centerX, centerY);
             [self setCurrentProgressWithWidth:centerX-self.frontLineLayer.frame.origin.x andAnimation:false];
            
            SEL selecter = @selector(panChangedWithProgressView:
                                     andSelectedPointViews:
                                     andNormalPointViews:);
            BOOL isResponseSel = [self.frontLineAnimationDelegate respondsToSelector:selecter];
            if (isResponseSel) {
                
                NSRange range = [self getPointViewSelectedMaxCount:self.allPointViewArray.count];
                _selectedPointArray = [self.allPointViewArray subarrayWithRange:range];
                
                NSInteger selectedCount = _selectedPointArray.count;
                
                NSInteger normalViewArrayCount = _allPointViewArray.count - selectedCount;
                NSArray *normalViewArray = [self.allPointViewArray subarrayWithRange:NSMakeRange(selectedCount, normalViewArrayCount)];
                
                [self.frontLineAnimationDelegate panChangedWithProgressView:self andSelectedPointViews:self.selectedPointArray andNormalPointViews:normalViewArray];
            }

            break;
        case UIGestureRecognizerStateEnded:
            break;
        case UIGestureRecognizerStateCancelled:
            break;
        case UIGestureRecognizerStateFailed:
            break;
        default:
            break;
    }
    [pan setTranslation:CGPointZero inView:self.currentProgressView];
}

- (void)dealloc {
    NSLog(@"✅ 销毁：%@",NSStringFromClass(self.class));
}

// animation delegate
- (void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    
    BOOL isFrontLayerAnimation = [anim isEqual:[self.frontLineLayer animationForKey:KANIMATIONFRONTLINELAYER]];
    
    if(isFrontLayerAnimation) {
        
        SEL selecter = @selector(animationDidStopWithProgressView:
                                 andSelectedPointViews:
                                 andNormalPointViews:);
        BOOL isRespondsSelecter = [self.frontLineAnimationDelegate respondsToSelector:selecter];
        
        if (!isRespondsSelecter) {
            return;
        }
        
        NSRange range = [self getPointViewSelectedMaxCount:self.allPointViewArray.count];
        _selectedPointArray = [self.allPointViewArray subarrayWithRange:range];
        
        NSInteger selectedCount = _selectedPointArray.count;
        
    
        NSInteger normalViewArrayCount = _allPointViewArray.count - selectedCount;
        NSArray *normalViewArray = [self.allPointViewArray subarrayWithRange:NSMakeRange(selectedCount, normalViewArrayCount)];
        
        [self.frontLineAnimationDelegate  animationDidStopWithProgressView:self andSelectedPointViews:self.selectedPointArray andNormalPointViews:normalViewArray];
        return;
    }
    
    BOOL isCurrentProgressViewAnimation = [anim isEqual:[self.currentProgressView.layer animationForKey:KANIMATIONCURRENTPROGRESSVIEW]];
    if (isCurrentProgressViewAnimation) {
    }
}

- (NSRange) getPointViewSelectedMaxCount: (NSInteger) maxCount {
    __block NSInteger index = -1;
    CGFloat maxWidth = self.frontLineLayer.frame.size.width;
    NSInteger rangeLength = 0;
    CGFloat currentProgressW = self.currentProgress * maxWidth;
    if (maxWidth > 0 && currentProgressW > 0) {
       
        [self.allPointViewArray enumerateObjectsUsingBlock:^(PYBasePointProgressContentView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGFloat x = obj.frame.origin.x;
            x = self.selectedType == PYBasePointProgressSelectedCenter ? obj.center.x : x;
            x -= self.frontLineLayer.frame.origin.x;
            if (x <= currentProgressW) {
                index = idx;
            }else{
                *stop = true;
            }
        }];
        
        rangeLength = MIN(index + 1, self.allPointViewArray.count);
    }
    
    return NSMakeRange(0, rangeLength);
}
@end



@implementation PYBasePointProgressContentView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview: self.button];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.button.frame = self.bounds;
}
- (UIButton *) button {
    if (!_button) {
        _button = [UIButton new];
        [_button addTarget:self action:@selector(click_buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}
- (void) click_buttonAction:(UIButton *)button {
    
}
- (void)dealloc {
    NSLog(@"✅ 销毁：%@",NSStringFromClass(self.class));
}
@end
