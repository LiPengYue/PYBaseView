//
//  PYBaseNavigationBarView.m
//  FBSnapshotTestCase
//
//  Created by 衣二三 on 2019/8/22.
//

#import "PYBaseNavigationBarView.h"

@interface PYBaseNavigationBarView ()
@property (nonatomic,strong) UIView *backgroundView;
@property (nonatomic,copy) ClickNavTitle clickTitleButton;
@property (nonatomic,copy) CliekNavItem clickRightItem;
@property (nonatomic,copy) CliekNavItem clickLeftItem;

@property (nonatomic,strong) NSMutableArray <UIButton *>*leftItemsM;
@property (nonatomic,strong) NSMutableArray <UIButton *>*rightItemsM;

@property (nonatomic,strong) NSLayoutConstraint *bottomLineLeftConstraint;
@property (nonatomic,strong) NSLayoutConstraint *bottomLineHConstraint;
@property (nonatomic,strong) NSLayoutConstraint *bottomLineRightConstraint;
/// 第一次布局
@property (nonatomic,assign) BOOL isFirstLayout;
@end

@implementation PYBaseNavigationBarView
@synthesize titleButton = _titleButton;

- (void) setUpWeakSelfFunc: (void(^)(PYBaseNavigationBarView *weak))block {
    __weak typeof(self)weakSelf = self;
    if (block) {
        block(weakSelf);
    }
}

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpProperty];
        self.backgroundColor = UIColor.whiteColor;
        self.userInteractionEnabled = true;
    }
    return self;
}
- (void) setUpProperty {
    self.isFirstLayout = true;
    _titleButton = [UIButton new];
    [_titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _titleButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_titleButton addTarget:self action:@selector(click_titleButtonButton:) forControlEvents:UIControlEventTouchUpInside];
    
    self.leftItemLeftSpacing = 14;
    self.rightItemRightSpacing = 14;
    self.titleBottomSpacing = 5;
    self.itemBottomSpacing = -1;
    
    self.itemsMinMargin = 14;
    self.itemHeight = 24;
    self.itemMinWidth = 44;
    self.titleFont = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    self.leftItemTextFont = [UIFont systemFontOfSize:12];
    self.rightItemTextFont = [UIFont systemFontOfSize:12];
}

#pragma mark - functions
- (void) reloadView {
    self.isFirstLayout = true;
    [self setup];
}

- (void) setup {
    [self setupView];
    [self registerEvents];
    if (self.isFirstLayout) {
        self.isFirstLayout = false;
        
        self.titleVericalAlignment
        = _leftVericalAlignment
        = _rightVericalAlignment
        = UIControlContentVerticalAlignmentBottom;
        
        self.titleHorizontalAlignment
        = _leftHorizontalAlignment
        = _rightHorizontalAlignment
        = UIControlContentHorizontalAlignmentLeft;
        
        [self layoutRightAlignment];
        [self layoutLeftAlignment];
    }
}

// MARK: handle views
- (void) setupView {
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self layoutBackgroundView];
    [self layoutTitleButton];
    [self layoutLeftButtons];
    [self layoutRightButtons];
    [self layoutBottomLine];
}


- (NSLayoutConstraint *) createWConstraint: (UIView *)view
                                    toItem: (UIView *)toView
                               andConstant: (CGFloat) constant {
    NSLayoutAttribute attribute = toView ? NSLayoutAttributeWidth : NSLayoutAttributeNotAnAttribute;
    NSLayoutConstraint *w =
    [NSLayoutConstraint constraintWithItem:self.titleButton
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:toView
                                 attribute:attribute
                                multiplier:1
                                  constant:constant];
    return w;
}

- (NSLayoutConstraint *) createHeight: (UIView *)view
                               toItem: (UIView *)toView
                          andConstant: (CGFloat) constant {
    
    NSLayoutAttribute attribute =
    toView
    ? NSLayoutAttributeHeight
    : NSLayoutAttributeNotAnAttribute;
    
    NSLayoutConstraint *h =
    [NSLayoutConstraint constraintWithItem:view
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:toView
                                 attribute:attribute
                                multiplier:1
                                  constant:constant];
    return h;
}

- (NSLayoutConstraint *) createCeterx: (UIView *)view
                               toItem: (UIView *)toView
                          andConstant: (CGFloat)constant{
    
    NSLayoutAttribute attribute =
    toView
    ? NSLayoutAttributeCenterX
    : NSLayoutAttributeNotAnAttribute;
    
    NSLayoutConstraint *centerX =
    [NSLayoutConstraint constraintWithItem:view
                                 attribute:NSLayoutAttributeCenterX
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:toView
                                 attribute:attribute
                                multiplier:1
                                  constant:constant];
    return centerX;
}

- (NSLayoutConstraint *) createCeterY: (UIView *)view
                               toItem: (UIView *)toView
                          andConstant: (CGFloat)constant{
    
    NSLayoutAttribute attribute =
    toView
    ? NSLayoutAttributeCenterY
    : NSLayoutAttributeNotAnAttribute;
    
    NSLayoutConstraint *centerY =
    [NSLayoutConstraint constraintWithItem:view
                                 attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:toView
                                 attribute:attribute
                                multiplier:1
                                  constant:constant];
    return centerY;
}

- (NSLayoutConstraint *) createLeft: (UIView *)view
                             toItem: (UIView *)toView
                        andConstant: (CGFloat)constant{
    
    NSLayoutAttribute attribute =
    toView
    ? NSLayoutAttributeLeft
    : NSLayoutAttributeNotAnAttribute;
    
    NSLayoutConstraint *left =
    [NSLayoutConstraint constraintWithItem:view
                                 attribute:NSLayoutAttributeLeft
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:toView
                                 attribute:attribute
                                multiplier:1
                                  constant:constant];
    return left;
}

- (NSLayoutConstraint *) createLeftRight: (UIView *)view
                                  toItem: (UIView *)toView
                             andConstant: (CGFloat)constant{
    
    NSLayoutAttribute attribute =
    toView
    ? NSLayoutAttributeRight
    : NSLayoutAttributeNotAnAttribute;
    
    NSLayoutConstraint *left =
    [NSLayoutConstraint constraintWithItem:view
                                 attribute:NSLayoutAttributeLeft
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:toView
                                 attribute:attribute
                                multiplier:1
                                  constant:constant];
    return left;
}

- (NSLayoutConstraint *) createBottom: (UIView *)view
                               toItem: (UIView *)toView
                          andConstant: (CGFloat) constant {
    
    NSLayoutAttribute attribute =
    toView
    ? NSLayoutAttributeBottom
    : NSLayoutAttributeNotAnAttribute;
    
    NSLayoutConstraint *bottom =
    [NSLayoutConstraint constraintWithItem:view
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:toView
                                 attribute:attribute
                                multiplier:1
                                  constant:constant];
    return bottom;
}

- (NSLayoutConstraint *) createRight: (UIView *)view
                              toItem: (UIView *)toView
                         andConstant: (CGFloat) constant {
    NSLayoutAttribute attribute =
    toView
    ? NSLayoutAttributeRight
    : NSLayoutAttributeNotAnAttribute;
    
    NSLayoutConstraint *right =
    [NSLayoutConstraint constraintWithItem:view
                                 attribute:NSLayoutAttributeRight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:toView
                                 attribute:attribute
                                multiplier:1
                                  constant:constant];
    return right;
}

- (NSLayoutConstraint *) createRightLeft: (UIView *)view
                                  toItem: (UIView *)toView
                             andConstant: (CGFloat) constant {
    NSLayoutAttribute attribute =
    toView
    ? NSLayoutAttributeLeft
    : NSLayoutAttributeNotAnAttribute;
    
    NSLayoutConstraint *right =
    [NSLayoutConstraint constraintWithItem:view
                                 attribute:NSLayoutAttributeRight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:toView
                                 attribute:attribute
                                multiplier:1
                                  constant:constant];
    return right;
}

- (NSLayoutConstraint *) createTop: (UIView *)view
                         andToItem: (UIView *)toItem
                       andConstant: (CGFloat) constant {
    NSLayoutAttribute attribute =
    toItem
    ? NSLayoutAttributeTop
    : NSLayoutAttributeNotAnAttribute;
    
    NSLayoutConstraint *top =
    [NSLayoutConstraint constraintWithItem:view
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:toItem
                                 attribute:attribute
                                multiplier:1
                                  constant:constant];
    return top;
}

- (NSLayoutConstraint *) createMinWidth: (UIView *)view
                              andToItem: (UIView *)toItem
                            andConstant: (CGFloat) constant {
    NSLayoutAttribute attribute =
    toItem
    ? NSLayoutAttributeWidth
    : NSLayoutAttributeNotAnAttribute;
    
    NSLayoutConstraint *w =
    [NSLayoutConstraint constraintWithItem:view
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationGreaterThanOrEqual
                                    toItem:toItem
                                 attribute:attribute
                                multiplier:1
                                  constant:constant];
    return w;
}

- (void) layoutBackgroundView {
    self.backgroundView.translatesAutoresizingMaskIntoConstraints = false;
    [self addSubview:self.backgroundView];
    NSLayoutConstraint *left =
    [self createLeft:self.backgroundView
              toItem:self
         andConstant:0];
    NSLayoutConstraint *right =
    [self createRight:self.backgroundView
               toItem:self
          andConstant: 0];
    NSLayoutConstraint *top =
    [self createTop:self.backgroundView
          andToItem:self
        andConstant: 0];
    NSLayoutConstraint *bottom =
    [self createBottom:self.backgroundView
                toItem:self
           andConstant: 0];
    [self addConstraints:@[
                           left,
                           right,
                           top,
                           bottom
                           ]];
}

- (void) layoutTitleButton {
    [self.backgroundView addSubview:self.titleButton];
    self.titleButton.translatesAutoresizingMaskIntoConstraints = false;
    NSLayoutConstraint *width =
    [self createWConstraint:self.titleButton
                     toItem:nil
                andConstant:self.titleButtonWidth];
    
    NSLayoutConstraint *height =
    [self createHeight:self.titleButton
                toItem:nil
           andConstant:self.titleButtonHeight];
    
    NSLayoutConstraint *centerx =
    [self createCeterx:self.titleButton
                toItem:self.backgroundView
           andConstant:0];
    
    NSLayoutConstraint *bottom =
    [self createBottom:self.titleButton
                toItem:self.backgroundView
           andConstant:-(self.titleBottomSpacing)];
    
    
    if (self.titleButtonWidth
        && self.titleButtonHeight) {
        
        [self.backgroundView addConstraints:@[ centerx,
                                               bottom ]];
        
        [self.titleButton addConstraints:@[height,
                                           width]];
        return;
    }
    
    if(self.titleButtonWidth) {
        [self.titleButton addConstraint:width];
        [self.backgroundView addConstraints:@[
                                              centerx,
                                              bottom
                                              ]];
        return;
    }
    
    if(self.titleButtonHeight) {
        [self.titleButton addConstraint:height];
        [self.backgroundView addConstraints:@[
                                              centerx,
                                              bottom
                                              ]];
        return;
    }
    [self.backgroundView addConstraints:@[
                                          centerx,
                                          bottom
                                          ]];
}
- (void) layoutLeftButtons {
    __block UIButton *leftButtonFront;
    NSInteger leftButtonsCount = self.leftItemsM.count;
    
    if (leftButtonsCount == 1) {
        [self.backgroundView addSubview: self.leftItemsM.firstObject];
        UIButton *button = self.leftItemsM.firstObject;
        button.translatesAutoresizingMaskIntoConstraints = false;
        
        NSLayoutConstraint *left =
        [self createLeft:button
                  toItem:self.backgroundView
             andConstant:self.leftItemLeftSpacing];
        
        NSLayoutConstraint *centerY =
        [self createCeterY:button
                    toItem:self.titleButton
               andConstant:0];
        
        [self createMinWidth:button andToItem:nil andConstant:self.itemMinWidth];
        
        NSLayoutConstraint *height =
        [self createHeight: button
                    toItem: nil
               andConstant: self.itemHeight];
        
        [self.backgroundView addConstraints:@[centerY,left]];
        [button addConstraint: height];
        return;
    }
    
    [self.leftItemsM enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj) {
            [self.backgroundView addSubview:obj];
            obj.translatesAutoresizingMaskIntoConstraints = false;
            
            if (idx == 0) {
                NSLayoutConstraint *left =
                [self createLeft:obj
                          toItem:self.backgroundView
                     andConstant:self.leftItemLeftSpacing];
                
                NSLayoutConstraint *centerY;
                NSLayoutConstraint *bottomSpacing;
                if (self.itemBottomSpacing < 0) {
                    centerY =
                    [self createCeterY:obj
                                toItem:self.titleButton
                           andConstant: 0];
                }else{
                    bottomSpacing =
                    [self createBottom:obj
                                toItem:self.backgroundView
                           andConstant:self.itemBottomSpacing];
                }
                
                NSLayoutConstraint *height =
                [self createHeight:obj
                            toItem:nil
                       andConstant:self.itemHeight];
                
                [obj addConstraint:height];
                if (centerY) {
                    [self.backgroundView addConstraints:@[centerY,left]];
                }else{
                    [self.backgroundView addConstraints:@[bottomSpacing,left]];
                }
                [self.backgroundView addConstraints:@[centerY,left]];
                
            } else {
                NSLayoutConstraint *left =
                [self createLeftRight:obj
                               toItem:leftButtonFront
                          andConstant: self.itemsMinMargin];
                
                NSLayoutConstraint *centerY =
                [self createCeterY:obj
                            toItem:leftButtonFront
                       andConstant:0];
                
                NSLayoutConstraint *height =
                [self createHeight:obj
                            toItem:nil
                       andConstant:self.itemHeight];
                
                [obj addConstraint:height];
                [self.backgroundView addConstraints:@[
                                                      left,
                                                      centerY
                                                      
                                                      ]];
            }
            leftButtonFront = obj;
        }
    }];
}
- (void) layoutRightButtons {
    __block UIButton *rightButtonFront;
    NSInteger rightButtonsCount = self.rightItemsM.count;
    
    if (rightButtonsCount == 1) {
        UIButton *button = self.rightItemsM.firstObject;
        [self.backgroundView addSubview: button];
        
        button.translatesAutoresizingMaskIntoConstraints = false;
        
        NSLayoutConstraint *right =
        [self createRight:button
                   toItem:self.backgroundView
              andConstant: (-self.itemsMinMargin)];
        
        NSLayoutConstraint *ceterY =
        [self createCeterY:button
                    toItem:self.titleButton
               andConstant:0];
        
        NSLayoutConstraint *height =
        [self createHeight:button
                    toItem:nil
               andConstant:self.itemHeight];
        
        [self.backgroundView addConstraints:@[right,ceterY]];
        [button addConstraint:height];
        
        return;
    }
    
    [self.rightItemsM enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj) {
            [self.backgroundView addSubview:obj];
            obj.translatesAutoresizingMaskIntoConstraints = false;
            [obj setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
            
            if (idx == 0 && rightButtonsCount != 1) {
                NSLayoutConstraint *right =
                [self createRight:obj
                           toItem:self.backgroundView
                      andConstant:(-self.rightItemRightSpacing)];
                NSLayoutConstraint *centerY;
                NSLayoutConstraint *bottom;
                if (self.itemBottomSpacing < 0) {
                    centerY =
                    [self createCeterY:obj
                            toItem: self.titleButton
                           andConstant:0];
                }else{
                    bottom =
                    [self createBottom:obj
                                toItem:self.backgroundView
                           andConstant:self.itemBottomSpacing];
                }
                
                NSLayoutConstraint *height =
                [self createHeight:obj
                            toItem:nil
                       andConstant:self.itemHeight];
                
                if (centerY) {
                    [self.backgroundView addConstraints:@[centerY,right]];
                }else{
                    [self.backgroundView addConstraints:@[bottom,right]];
                }
                [obj addConstraints:@[height]];
                
                
            }else {
                
                NSLayoutConstraint *right =
                [self createRightLeft:obj
                               toItem:rightButtonFront
                          andConstant: (-self.itemsMinMargin)];
                NSLayoutConstraint *centerY =
                [self createCeterY:obj
                            toItem:rightButtonFront
                       andConstant:0];
                NSLayoutConstraint *height =
                [self createHeight:obj
                            toItem:rightButtonFront
                       andConstant:0];
                
                [self.backgroundView addConstraints:@[right,
                                                      height,
                                                      centerY]];
                
            }
            rightButtonFront = obj;
        }
    }];
}
- (void) layoutBottomLine {
    [self.backgroundView addSubview:self.bottomLineView];
    self.bottomLineView.translatesAutoresizingMaskIntoConstraints = false;
    NSLayoutConstraint *bottom =
    [self createBottom:self.bottomLineView
                toItem:self.backgroundView
           andConstant:0];
    NSLayoutConstraint *left =
    [self createLeft:self.bottomLineView
              toItem:self.backgroundView
         andConstant:0];
    NSLayoutConstraint *right =
    [self createRight:self.bottomLineView
               toItem:self.backgroundView
          andConstant:0];
    NSLayoutConstraint *height =
    [self createHeight:self.bottomLineView
                toItem:nil
           andConstant:1];
    
    self.bottomLineLeftConstraint = left;
    self.bottomLineRightConstraint = right;
    self.bottomLineHConstraint = height;
    
    [self.bottomLineView addConstraint:height];
    [self.backgroundView addConstraints:@[bottom,left,right]];
}

// MARK: handle event
- (void) registerEvents {
    
}

- (void) click_titleButtonButton: (UIButton *)button {
    if (self.clickTitleButton) {
        self.clickTitleButton(self.titleButton);
    }
}
- (void) click_RightButtonFunc: (UIButton *)button {
    if (self.clickRightItem) {
        NSInteger idx = [self.rightItemsM indexOfObject:button];
        self.clickRightItem(button, idx);
    }
}
- (void) click_LeftButtonFunc: (UIButton *)button {
    if (self.clickLeftItem) {
        NSInteger idx = [self.leftItemsM indexOfObject:button];
        self.clickLeftItem(button, idx);
    }
}

- (void) clickLeftButtonFunc: (CliekNavItem) clickLeftItem {
    self.clickLeftItem = clickLeftItem;
}
- (void) clickRightButtonFunc: (CliekNavItem) clickRightItem {
    self.clickRightItem = clickRightItem;
}
- (void) clickTitleButtonFunc: (ClickNavTitle) clickTitle {
    self.clickTitleButton = clickTitle;
}


// MARK: ther func
- (PYBaseNavigationBarView *(^)(UIButton *button)) addLeftItem {
    return ^(UIButton *button) {
        NSInteger idx = self.leftItemsM.count;
        [self setUpWeakSelfFunc:^(PYBaseNavigationBarView *weak) {
            [weak insertLeftItem:button andIndex:idx];
        }];
        return self;
    };
}
- (PYBaseNavigationBarView *(^)(UIButton *button)) addRightItem {
    return ^(UIButton *button) {
        [self setUpWeakSelfFunc:^(PYBaseNavigationBarView *weak) {
            NSInteger idx = weak.rightItemsM.count;
            [weak insertRightItem:button andIndex:idx];
        }];
        
        return self;
    };
}

- (PYBaseNavigationBarView *(^)(NSString *str,UIImage *image)) addLeftItemWithTitleAndImg {
    return ^(NSString *str, UIImage *image) {
        UIButton *button = [UIButton new];
        [button setImage:image forState:UIControlStateNormal];
        [button setTitle:str forState:UIControlStateNormal];
        [self setUpWeakSelfFunc:^(PYBaseNavigationBarView *weak) {
            weak.addLeftItem(button);
        }];
        return self;
    };
}
- (PYBaseNavigationBarView *(^)(NSString *str,UIImage *image)) addRightItemWithTitleAndImg {
    return ^(NSString *str, UIImage *image) {
        UIButton *button = [[UIButton alloc] init];;
        button.userInteractionEnabled = true;
        [button setImage:image forState:UIControlStateNormal];
        [button setTitle:str forState:UIControlStateNormal];
        [self setUpWeakSelfFunc:^(PYBaseNavigationBarView *weak) {
            weak.addRightItem(button);
        }];
        return self;
    };
}
- (PYBaseNavigationBarView *(^)(NSString *str,UIImage *image)) addTitleItemWithTitleAndImg {
    return ^(NSString *str, UIImage *image) {
        UIButton *button = [[UIButton alloc] init];;
        button.userInteractionEnabled = true;
        button.titleLabel.font = self.titleFont;
        [button setImage:image forState:UIControlStateNormal];
        [button setTitle:str forState:UIControlStateNormal];
        CGFloat value = 51.0 / 255;
        [button setTitleColor:[UIColor colorWithRed:value green:value blue:value alpha:1] forState:UIControlStateNormal];
        button.tag = self.titleButton.tag;
        self.titleButton = button;
        [button addTarget:self action:@selector(click_titleButtonButton:) forControlEvents:UIControlEventTouchUpInside];
        return self;
    };
}

- (PYBaseNavigationBarView *(^)(NSAttributedString *str)) addLeftItemWithAttributedStr {
    return ^(NSAttributedString *str) {
        UIButton *button = [[UIButton alloc] init];;
        button.userInteractionEnabled = true;
        [button setAttributedTitle:str forState:UIControlStateNormal];
        [self setUpWeakSelfFunc:^(PYBaseNavigationBarView *weak) {
            weak.addLeftItem(button);
        }];
        return self;
    };
}
- (PYBaseNavigationBarView *(^)(NSAttributedString *str)) addRightItemWithAttributedStr {
    return ^(NSAttributedString *str) {
        UIButton *button = [[UIButton alloc] init];
        button.userInteractionEnabled = true;
        [button setAttributedTitle:str forState:UIControlStateNormal];
        [self setUpWeakSelfFunc:^(PYBaseNavigationBarView *weak) {
            weak.addRightItem(button);
        }];
        return self;
    };
}
- (PYBaseNavigationBarView *(^)(NSAttributedString *str)) addTitleItemWithAttributedStr {
    return ^(NSAttributedString *str) {
        UIButton *button = [[UIButton alloc] init];;
        button.userInteractionEnabled = true;
        button.titleLabel.font = self.titleFont;
        [button setAttributedTitle:str forState:UIControlStateNormal];
        button.tag = self.titleButton.tag;
        self.titleButton = button;
        [button addTarget:self action:@selector(click_titleButtonButton:) forControlEvents:UIControlEventTouchUpInside];
        return self;
    };
}

- (PYBaseNavigationBarView *) insertLeftItem: (UIButton *)button andIndex: (NSInteger)index {
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self.leftItemsM insertObject:button atIndex:index];
    CGFloat value = 51.0 / 255;
    [button setTitleColor:[UIColor colorWithRed:value green:value blue:value alpha:1] forState:UIControlStateNormal];
    button.titleLabel.font = self.leftItemTextFont;
    [button addTarget:self action:@selector(click_LeftButtonFunc:) forControlEvents:UIControlEventTouchUpInside];
    
    dispatch_semaphore_signal(semaphore);
    return self;
}
- (PYBaseNavigationBarView *) insertRightItem: (UIButton *)button  andIndex: (NSInteger)index {
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    [self.rightItemsM insertObject:button atIndex:index];
    button.titleLabel.font = self.rightItemTextFont;
    CGFloat value = 51.0 / 255;
    [button setTitleColor:[UIColor colorWithRed:value green:value blue:value alpha:1] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(click_RightButtonFunc:) forControlEvents:UIControlEventTouchUpInside];
    
    dispatch_semaphore_signal(semaphore);
    return self;
}
- (PYBaseNavigationBarView *) removeLeftItemWithIndex: (NSInteger) index {
    [self.leftItemsM removeObjectAtIndex:index];
    return self;
}
- (PYBaseNavigationBarView *) removeRightItemWithIndex: (NSInteger) index {
    [self.rightItemsM removeObjectAtIndex:index];
    return self;
}
- (PYBaseNavigationBarView *) removeLeftAll {
    [self.leftItemsM removeAllObjects];
    return self;
}
- (PYBaseNavigationBarView *) removeRightAll {
    [self.rightItemsM removeAllObjects];
    return self;
}
- (UIButton *) getLeftItemWithIndex: (NSInteger) index {
    if (self.leftItemsM.count > index) {
        return self.leftItemsM[index];
    }
    return nil;
}
- (UIButton *) getRightItemWithIndex: (NSInteger) index {
    if (self.rightItemsM.count > index) {
        return self.rightItemsM[index];
    }
    return nil;
}


// MARK: properties get && set
- (NSArray<UIButton *> *) leftItems { return self.leftItemsM; }
- (NSArray<UIButton *> *) rightItems { return self.rightItemsM; }
- (NSArray<UIButton *> *) leftItemsM {
    if (!_leftItemsM) {
        _leftItemsM = [NSMutableArray new];
    }
    return _leftItemsM;
}
- (NSArray<UIButton *> *) rightItemsM {
    if (!_rightItemsM) {
        _rightItemsM = [NSMutableArray new];
    }
    return _rightItemsM;
}

- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [UIView new];
        CGFloat value = 228.0 / 255;
        _bottomLineView.backgroundColor =[UIColor colorWithRed:value green:value blue:value alpha:1];
    }
    return _bottomLineView;
}
- (UIButton *)titleButton {
    if (!_titleButton) {
        _titleButton = [UIButton new];
    }
    return _titleButton;
}
- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [UIView new];
        _backgroundView.backgroundColor = UIColor.whiteColor;
    }
    return _backgroundView;
}
- (CALayer *)shadowLayer {
    if (!_shadowLayer) {
        _shadowLayer = [CALayer new];
        _shadowLayer.shadowColor = [UIColor colorWithWhite:0 alpha:0.07].CGColor;
        _shadowLayer.shadowOpacity = 1;
        _shadowLayer.shadowOffset = CGSizeMake(-2, 3);
        _shadowLayer.shadowRadius = 4;
        [self.layer insertSublayer:_shadowLayer atIndex:0];
    }
    return _shadowLayer;
}

- (void)setBottomLineH:(CGFloat)bottomLineH {
    _bottomLineH = bottomLineH;
    self.bottomLineHConstraint.constant = _bottomLineH;
}
- (void)setBottomLineLeftSpacing:(CGFloat)bottomLineLeftSpacing {
    _bottomLineLeftSpacing = bottomLineLeftSpacing;
    self.bottomLineLeftConstraint.constant = bottomLineLeftSpacing;
}
- (void)setBottomLineRightSpacing:(CGFloat)bottomLineRightSpacing {
    _bottomLineRightSpacing = bottomLineRightSpacing;
    self.bottomLineRightConstraint.constant = bottomLineRightSpacing;
}
- (void)setIsHiddenBottomLine:(BOOL)isHiddenBottomLine {
    _isHiddenBottomLine = isHiddenBottomLine;
    self.bottomLineView.hidden = isHiddenBottomLine;
}
- (void)setTitleButton:(UIButton *)titleButton {
    if (titleButton == _titleButton) {
        return;
    }
    [_titleButton removeFromSuperview];
    _titleButton = titleButton;
    [self layoutTitleButton];
}
- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    self.titleButton.titleLabel.font = titleFont;
}
- (void)setLeftItemTextFont:(UIFont *)leftItemTextFont {
    if (_leftItemTextFont == leftItemTextFont)
        return;
    
    _leftItemTextFont = leftItemTextFont;
    [self.leftItems enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.titleLabel.font = leftItemTextFont;
    }];
}
- (void)setRightItemTextFont:(UIFont *)rightItemTextFont {
    if (_rightItemTextFont == rightItemTextFont)
        return;
    
    _rightItemTextFont = rightItemTextFont;
    [self.rightItems enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.titleLabel.font = rightItemTextFont;
    }];
}

- (void)setLeftVericalAlignment:(UIControlContentVerticalAlignment)leftVericalAlignment {
    if (leftVericalAlignment == _leftVericalAlignment) {
        return;
    }
    _leftVericalAlignment = leftVericalAlignment;
    [self layoutLeftAlignment];
}
- (void)setRightVericalAlignment:(UIControlContentVerticalAlignment)rightVericalAlignment {
    if (rightVericalAlignment == _rightVericalAlignment) {
        return;
    }
    _rightVericalAlignment = rightVericalAlignment;
    [self layoutRightAlignment];
}
- (void)setTitleVericalAlignment:(UIControlContentVerticalAlignment)titleVericalAlignment {
    if (titleVericalAlignment == _titleVericalAlignment) {
        return;
    }
    self.titleButton.contentVerticalAlignment = titleVericalAlignment;
}

- (void)setLeftHorizontalAlignment: (UIControlContentHorizontalAlignment) leftHorizontalAlignment {
    if (_leftHorizontalAlignment == leftHorizontalAlignment) {
        return;
    }
    _leftHorizontalAlignment = leftHorizontalAlignment;
    [self layoutLeftAlignment];
}
- (void)setRightHorizontalAlignment:(UIControlContentHorizontalAlignment)rightHorizontalAlignment {
    if (_rightHorizontalAlignment == rightHorizontalAlignment) {
        return;
    }
    _rightHorizontalAlignment = rightHorizontalAlignment;
    [self layoutRightAlignment];
}
- (void)setTitleHorizontalAlignment:(UIControlContentHorizontalAlignment)titleHorizontalAlignment {
    if (titleHorizontalAlignment == _titleHorizontalAlignment) {
        return;
    }
    _titleHorizontalAlignment = titleHorizontalAlignment;
    self.titleButton.contentHorizontalAlignment = titleHorizontalAlignment;
}
//titleHorizontalAlignment
- (void) layoutRightAlignment {
    [self.rightItems enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.contentVerticalAlignment = self.rightVericalAlignment;
        obj.contentHorizontalAlignment = self.rightHorizontalAlignment;
    }];
}
- (void) layoutLeftAlignment {
    [self.leftItems enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.contentVerticalAlignment = self.leftVericalAlignment;
        obj.contentHorizontalAlignment = self.leftHorizontalAlignment;
    }];
}


// MARK:life cycles
- (void)layoutSubviews {
    [super layoutSubviews];
    if (!self.isHiddenShadow) {
        self.shadowLayer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
        self.shadowLayer.frame = self.bounds;
    }
   
    [self.titleButton layoutIfNeeded];
    self.titleButton.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    
}

@end
