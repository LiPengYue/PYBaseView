//
//  PresentViewController.m
//  BaseProgress
//
//  Created by 衣二三 on 2019/4/8.
//  Copyright © 2019年 衣二三. All rights reserved.
//

#import "PresentViewController.h"


@interface PresentViewController () <PYBasePointProgressProtocol>
@property (nonatomic,strong) PYBasePointProgressView *progressView;
@property (nonatomic,strong) UILabel * progressLabel;
@end

@implementation PresentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.progressView];
    [self.view addSubview:self.progressLabel];
    self.progressLabel.bounds = CGRectMake(0, 0, self.view.bounds.size.width, 40);
    self.progressLabel.center = CGPointMake(self.view.center.x, 140);
    self.progressView.center =  CGPointMake(self.view.center.x, 220);
}

- (PYBasePointProgressView *) progressView {
    if (!_progressView) {
        _progressView = [PYBasePointProgressView new];
        _progressView.frame = CGRectMake(10, 100, 300, 200);
        _progressView.frontLineAnimationDelegate = self;
//        _progressView.selectedType = BasePointProgressSelectedEdge;
        
        PYBasePointProgressLineData normal = _progressView.normalLineStyle;
        normal.drowLength = 5;
        normal.marginLength = 3;
        normal.lineHeight = 1;
        normal.isMovePointViewTop = true;
        
        _progressView.currentProgressView.backgroundColor = UIColor.whiteColor;
        _progressView.currentProgressView.bounds = CGRectMake(0, 0, 10, 50);
        _progressView.currentProgressView.layer.masksToBounds = true;
        _progressView.currentProgressView.layer.cornerRadius = 5;
        _progressView.currentProgressView.layer.borderColor = UIColor.blackColor.CGColor;
        _progressView.currentProgressView.layer.borderWidth = 2;
        
        _progressView.normalLineStyle = normal;
        
    }
    return _progressView;
}
/// progressLabel
- (UILabel *) progressLabel {
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc] init];
        _progressLabel.frame = CGRectMake(0,0,0,0);
        _progressLabel.backgroundColor = UIColor.whiteColor;
        _progressLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return _progressLabel;
}

- (void)dealloc {
    NSLog(@"✅ 销毁：%@",NSStringFromClass(self.class));
}

- (NSArray<PYBasePointProgressContentView *> *)createPointContentViewWithProgressView:(PYBasePointProgressView *)progressView {

    NSMutableArray *array = [NSMutableArray arrayWithCapacity:4];
    for (int i = 0; i < 5; i++) {
        
        PYBasePointProgressContentView *view1 = [PYBasePointProgressContentView new];
        view1.bounds = CGRectMake(0, 0, 30, 30);
        view1.layer.masksToBounds = true;
        view1.layer.cornerRadius = 15;
        view1.backgroundColor = UIColor.redColor;
        view1.button.tag = i + 1;
        [view1.button addTarget:self action:@selector(click1:) forControlEvents:UIControlEventTouchUpInside];
        
        [array addObject:view1];
    }
    
    return array;
}


- (void) animationDidStopWithProgressView:(PYBasePointProgressView *)progressView andSelectedPointViews:(NSArray<PYBasePointProgressContentView *> *)selectedPointViews andNormalPointViews:(NSArray<PYBasePointProgressContentView *> *)normalPointViews {
    self.progressLabel.text = [NSString stringWithFormat:@"%.3lf",progressView.currentProgress];
    [selectedPointViews enumerateObjectsUsingBlock:^(PYBasePointProgressContentView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.backgroundColor = UIColor.greenColor;
    }];
    [normalPointViews enumerateObjectsUsingBlock:^(PYBasePointProgressContentView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       obj.backgroundColor = UIColor.redColor;
    }];
}

- (void)panChangedWithProgressView:(PYBasePointProgressView *)progressView andSelectedPointViews:(NSArray<PYBasePointProgressContentView *> *)selectedPointViews andNormalPointViews:(NSArray<PYBasePointProgressContentView *> *)normalPointViews {
    [self animationDidStopWithProgressView:progressView andSelectedPointViews:selectedPointViews andNormalPointViews:normalPointViews];
    NSLog(@"%lf",progressView.currentProgress);
}

- (void) click1: (UIButton *)button {
    [self.progressView reloadProgressToViewCenter:(PYBasePointProgressContentView *)button.superview andOffset:0];
    NSLog(@"点击");
}

- (void) willDisplayPointView:(PYBasePointProgressContentView *)pointView andIsSected:(BOOL)isSelected andIndexPath:(NSInteger)index {
    
}


@end
