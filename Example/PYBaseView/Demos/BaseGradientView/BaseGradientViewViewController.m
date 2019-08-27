//
//  BaseGradientViewViewController.m
//  PYBaseView_Example
//
//  Created by 衣二三 on 2019/8/26.
//  Copyright © 2019 LiPengYue. All rights reserved.
//

#import "BaseGradientViewViewController.h"

@interface BaseGradientViewViewController ()
@property (nonatomic,strong) PYBaseGradientView *gradientView;
@property (nonatomic,strong) PYBaseGradientView *gradientView1;
/// typeButton
@property (nonatomic,strong) PYBaseButton *typeButton;
@end

@implementation BaseGradientViewViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNetWork];
    [self setupViews];
    [self registerEvents];
}
// MARK: - init


#pragma mark - func

// MARK: setupTable

// MARK: network
- (void) loadNetWork {
    
}
// MARK: handle views
- (void) setupViews {
    [self.view addSubview:self.gradientView];
    [self.view addSubview:self.gradientView1];
//    [self.view addSubview: self.typeButton];
    self.gradientView.frame = CGRectMake(10, 100, 100, 100);
    self.gradientView1.frame = CGRectMake(120, 100, 100, 100);
    
    [self click_typeButtonAction:self.typeButton];
    
    self.navBarView.addTitleItemWithTitleAndImg(@"渐变",nil);
    self.navBarView.addLeftItemWithTitleAndImg(@"返回",nil);
    [self.navBarView reloadView];
    [self.gradientView drawRadialGradient:^(PYBaseGradientViewDrawRadialConfig *radialConfig) {
        radialConfig
        .setUpScaleEndCenter(CGPointMake(0.5, 0.5))
        .setUpScaleStartCenter(CGPointMake(0.5, 0.5))
        .setUpColorArray(@[
                           UIColor.redColor,
                           UIColor.blueColor
                           ])
        .setUpStartRadius(0)
        .setUpEndRadius(200)
        .setUpLocationArray(@[@0.1,@1]);
    }];

    [self.gradientView1 drawLineGradient:^(PYBaseGradientViewLineConfig *lineConfig) {
        lineConfig
        .setUpScaleEndCenter(CGPointMake(0, 0))
        .setUpScaleStartCenter(CGPointMake(1, 1))
        .setUpColorArray(@[
                           UIColor.redColor,
                           UIColor.cyanColor
                           ])
        .setUpLocationArray(@[
                              @0,@1
                              ]);
        
    }];
}
// MARK: handle event
- (void) registerEvents {
    
}
// MARK: lazy loads
- (PYBaseGradientView *)gradientView {
    if (!_gradientView) {
        _gradientView = [PYBaseGradientView new];
    }
    return _gradientView;
}

- (PYBaseGradientView *)gradientView1 {
    if (!_gradientView1) {
        _gradientView1 = [PYBaseGradientView new];
    }
    return _gradientView1;
}

    /// typeButton
- (PYBaseButton *) typeButton {
    if (!_typeButton) {
        _typeButton = [PYBaseButton new];
        [_typeButton setupHandler:^(PYBaseButtonHandler * _Nonnull handler) {
            [handler setUpStyle:0 style:^(PYBaseButtonHandler *handler) {
               handler.setUpTitleColor(UIColor.whiteColor)
                .setUpTitle(@"线性扩散")
                .setUpBorderColor(UIColor.whiteColor)
                .setUpBorderWidth(1)
                .setUpCornerRadius(6);
            }];
            
            [handler setUpStyle:1 style:^(PYBaseButtonHandler *handler) {
                handler.setUpTitleColor(UIColor.whiteColor)
                .setUpTitle(@"圆心扩散")
                .setUpBorderColor(UIColor.whiteColor)
                .setUpBorderWidth(1)
                .setUpCornerRadius(6);
            }];
        }];
        
        _typeButton.layer.cornerRadius = 6;
        _typeButton.frame = CGRectMake(100, PYSize.navTotalH + 20, 200, 100);
        [_typeButton addTarget:self action:@selector(click_typeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _typeButton;
}
- (void) click_typeButtonAction:(UIButton *)button {
    button.selected = !button.selected;
    [_typeButton setupHandler:^(PYBaseButtonHandler * _Nonnull handler) {
        [handler adjustButtonStyleWithState:button.selected];
    }];
    
    if (button.selected) {
        [self.gradientView drawRadialGradient:^(PYBaseGradientViewDrawRadialConfig *radialConfig) {
            radialConfig
            .setUpScaleEndCenter(CGPointMake(0.5, 0.5))
            .setUpScaleStartCenter(CGPointMake(0.5, 0.5))
            .setUpColorArray(@[
                               UIColor.redColor,
                               UIColor.blueColor
                               ])
            .setUpStartRadius(0)
            .setUpEndRadius(1000)
            .setUpLocationArray(@[@0.1,@1]);
        }];
    } else {
        [self.gradientView drawLineGradient:^(PYBaseGradientViewLineConfig *lineConfig) {
            lineConfig
            .setUpScaleEndCenter(CGPointMake(0, 0))
            .setUpScaleStartCenter(CGPointMake(1, 1))
            .setUpColorArray(@[
                               UIColor.redColor,
                               UIColor.cyanColor
                               ])
            .setUpLocationArray(@[
                                  @0,@1
                                  ]);
            
        }];
    }
}
    
// MARK: systom functions

// MARK:life cycles


@end

