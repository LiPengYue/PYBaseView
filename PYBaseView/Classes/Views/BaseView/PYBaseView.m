//
//  BaseView.m
//  PYKit
//
//  Created by 李鹏跃 on 2018/9/11.
//  Copyright © 2018年 13lipengyue. All rights reserved.
//

#import "PYBaseView.h"


@interface PYBaseView()
@property (nonatomic,strong) BOOL(^revoertPointInsideBlock)(CGPoint point, UIEvent *event);

@property (nonatomic,strong) CAShapeLayer *shapeLayer;
@property (nonatomic,assign) BOOL isCut;
@property (nonatomic,assign) CGRect lastDrawFrame;
@property (nonatomic,strong) NSLayoutConstraint *containerViewLeft;
@property (nonatomic,strong) NSLayoutConstraint *containerViewRight;
@property (nonatomic,strong) NSLayoutConstraint *containerViewTop;
@property (nonatomic,strong) NSLayoutConstraint *containerViewBottom;

@property (nonatomic,strong) PYViewShadowConfigration *shadowConfig;
@end

@implementation PYBaseView

// MARK: - init
- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self baseSetupProperty];
        [self baseSetup];
    }
    return self;
}

- (void) baseSetupProperty {
    self.isDrawShadow = true;
}

- (void) baseSetup {
    self.backgroundColor = self.bgColor;
    [self.layer addSublayer:self.shadowLayer];
    [self addSubview:self.containerView];
    [self layoutContainerView];
}

#pragma mark - func
// MARK: reload data

// MARK: handle views
- (void) setupSubViewsFunc {
    
}

- (UIView *(^)(CGRect frame)) setupFrame {
    return ^(CGRect frame) {
        self.frame = frame;
        return self;
    };
}

- (void) setUpWeakSelf: (void(^)(UIView *weak))block {
    if (block) {
        __weak typeof(self)weakSelf = self;
        block(weakSelf);
    }
}

- (void) setupBaseViewHandler: (void(^)(PYBaseViewHandler *handler))block {
    
}


#pragma mark - cut

- (void) unCunt {
    self.containerView.layer.mask = nil;
}

- (void) reCutWithRect:(CGRect) rect {
    self.cutRect = rect;
    [self cutIfNeededWithRect:rect];
}

- (void) cut {
    self.isCut = true;
    [self cutIfNeededWithRect:self.cutRect];
}

- (void) recut {
    self.isCut = true;
    self.containerView.layer.mask = self.shapeLayer;
    CGRect rect = self.cutRect;
    
    if (CGRectEqualToRect(CGRectZero, rect)) {
        rect = self.bounds;
    }
    [self setupShapeLayerWithRect:rect];
}

- (void) cutIfNeededWithRect: (CGRect) rect {
    if (self.config.radius <= 0
        && self.config.leftTopAddRadius <= 0
        && self.config.leftBottomAddRadius <= 0
        && self.config.rightTopAddRadius <= 0
        && self.config.rightBottomAddRadius <= 0) {
        return;
    }
    self.containerView.layer.mask = self.shapeLayer;
    [self setupShapeLayerIfNeedeWithRect:rect];
}

- (void) setupShapeLayerIfNeedeWithRect: (CGRect)rect {
    if (CGSizeEqualToSize(self.frame.size, self.lastDrawFrame.size)) {
        return;
    }
    [self setupShapeLayerWithRect:rect];
}

- (void) setupShapeLayerWithRect: (CGRect)rect {
    self.lastDrawFrame = self.frame;
    __weak typeof(self)weakSelf = self;
    [self createPathWithRect:rect andCallBack:^(CGMutablePathRef path) {
        weakSelf.shapeLayer.path = path;
        if (weakSelf.isDrawShadow) {
            weakSelf.shadowLayer.shadowPath = path;
        }
    }];
    if (self.isDrawShadow) {
        [self setupShadowLayer];
    }
}

- (void) setupShadowLayer {
    self.shadowLayer.backgroundColor = self.backgroundColor.CGColor;
    self.shadowLayer.frame = self.bounds;
}

//MARK: - 创建切圆路径
- (void) createPathWithRect:(CGRect)rect andCallBack: (void(^)(CGMutablePathRef path))block {
    if (!block) return;
    CGMutablePathRef path = [self createMutablePathRefWithRect:rect];
    block(path);
    CFRelease(path);
}

- (CGMutablePathRef) createMutablePathRefWithRect:(CGRect)rect {
    
    CGRect cutRect = rect;
    CGFloat
    minx = CGRectGetMinX(cutRect),//矩形中最小的x
    midx = CGRectGetMidX(cutRect),//矩形中最大x值的一半
    maxx = CGRectGetMaxX(cutRect);//矩形中最大的x值
    
    CGFloat
    miny = CGRectGetMinY(cutRect),//矩形中最小的Y值
    midy = CGRectGetMidY(cutRect),//矩形中最大Y值的一半
    maxy = CGRectGetMaxY(cutRect);//矩形中最大的Y值
    
    CGFloat
    radius = self.config.radius;
    
    CGFloat
    leftTopRadiu = radius + self.config.leftTopAddRadius,
    rightTopRadiu = radius + self.config.rightTopAddRadius,
    leftBottomRadiu = radius + self.config.leftBottomAddRadius,
    rightBottomRadiu = radius + self.config.rightBottomAddRadius;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, minx, midy);
    CGPathAddArcToPoint(path, nil, minx, miny, midx, miny, leftTopRadiu);
    CGPathAddArcToPoint(path, nil, maxx, miny, maxx, midy, rightTopRadiu);
    CGPathAddArcToPoint(path, nil, maxx, maxy, midx, maxy, rightBottomRadiu);
    CGPathAddArcToPoint(path, nil, minx, maxy, minx, midy, leftBottomRadiu);
    return path;
}

// MARK: properties get && set
- (PYBaseFilletShadowViewConfig *) config {
    if (!_config) {
        _config = [PYBaseFilletShadowViewConfig new];
        
        _config
        .setUpRadius(0);
        PYBaseFilletShadowViewConfigPropertyChangedBlock block;
        __weak typeof(self) weakSelf = self;
        block = ^(BOOL isChangedShape, BOOL isChangedShadow) {
            if (isChangedShadow) {
                weakSelf.shadowLayer.shadowColor = weakSelf.config.shadowColor.CGColor;
                weakSelf.shadowLayer.shadowOffset = weakSelf.config.shadowOffset;
                weakSelf.shadowLayer.shadowRadius = weakSelf.config.shadowRadius;
                weakSelf.shadowLayer.shadowOpacity = weakSelf.config.shadowAlpha;
            }
            if(isChangedShape) {
                [weakSelf recut];
            }
        };
        
        [self.config setValue:(id)block forKeyPath:@"propertyChangeCallBack"];
    }
    return _config;
}

- (CAShapeLayer *) shapeLayer {
    if(!_shapeLayer) {
        _shapeLayer = [CAShapeLayer new];
    }
    return _shapeLayer;
}

- (UIView *) containerView {
    if (!_containerView) {
        _containerView = [UIView new];
    }
    return _containerView;
}

- (CALayer *) shadowLayer {
    if (!_shadowLayer) {
        _shadowLayer = [CALayer new];
    }
    return _shadowLayer;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    self.shapeLayer.frame = self.bounds;
    self.shadowLayer.frame = self.bounds;
    CGRect rect = self.cutRect;
    if (CGRectEqualToRect(rect, CGRectZero)) {
        rect = self.bounds;
    }
    [self cutIfNeededWithRect:rect];
}

- (void) beginShadowAnimation:(void(^)(PYViewShadowConfigration *config)) block {
    if (block) {
        block(self.shadowConfig);
    }
}

// MARK: - layout containerView
- (void) layoutContainerView {
    self.containerView.translatesAutoresizingMaskIntoConstraints = false;
    NSLayoutConstraint *left = [self createContainerViewLeft];
    NSLayoutConstraint *right = [self createContainerViewRight];
    NSLayoutConstraint *top = [self createContainerViewTop];
    NSLayoutConstraint *bottom = [self createContainerViewBottom];
    
    [self addConstraints:@[left,right,bottom,top]];
    self.containerViewLeft = left;
    self.containerViewRight = right;
    self.containerViewTop = top;
    self.containerViewBottom = bottom;
}

- (void) setContainerViewEdge:(UIEdgeInsets)containerViewEdge {
    if (UIEdgeInsetsEqualToEdgeInsets(containerViewEdge, _containerViewEdge)) {
        return;
    }
    if (![self.subviews containsObject: self.containerView]) {
        [self addSubview:self.containerView];
    }
    if (containerViewEdge.left != _containerViewEdge.left) {
        [self removeConstraint:self.containerViewLeft];
        self.containerViewLeft = [self createContainerViewLeft];
        [self addConstraint:self.containerViewLeft];
    }
    if (containerViewEdge.right != _containerViewEdge.right) {
        [self removeConstraint:self.containerViewRight];
        self.containerViewRight = [self createContainerViewRight];
        [self addConstraint:self.containerViewRight];
    }
    if (containerViewEdge.top != _containerViewEdge.top) {
        [self removeConstraint:self.containerViewTop];
        self.containerViewRight = [self createContainerViewTop];
        [self addConstraint:self.containerViewTop];
    }
    if (containerViewEdge.bottom != _containerViewEdge.bottom) {
        [self removeConstraint:self.containerViewBottom];
        self.containerViewBottom = [self createContainerViewBottom];
        [self addConstraint:self.containerViewBottom];
    }
    _containerViewEdge = containerViewEdge;
}
- (NSLayoutConstraint *) createContainerViewLeft {
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:self.containerViewEdge.left];
    return left;
}
- (NSLayoutConstraint *) createContainerViewRight {
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:self.containerViewEdge.right];
    return right;
}
- (NSLayoutConstraint *) createContainerViewTop {
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:self.containerViewEdge.top];
    return top;
}
- (NSLayoutConstraint *) createContainerViewBottom {
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:self.containerViewEdge.bottom];
    return bottom;
}


// MARK: lazy loads
- (PYViewShadowConfigration *)shadowConfig {
    if (!_shadowConfig) {
        _shadowConfig = PYViewShadowConfigration.create(self.shadowLayer);
    }
    return _shadowConfig;
}

// MARK: systom functions
- (BOOL) pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    BOOL isTranslucent = self.isTranslucent;
    if (self.revoertPointInsideBlock) {
        isTranslucent =  self.revoertPointInsideBlock(point,event);
    }
    if (!isTranslucent) {
        return false;
    }else{
        return [super pointInside:point withEvent:event];
    }
}

- (void) revoertPointInside:(BOOL (^)(CGPoint, UIEvent * _Nonnull))block {
    self.revoertPointInsideBlock = block;
}

// MARK:life cycles

@end
