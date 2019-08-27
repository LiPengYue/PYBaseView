//
//  PYRoundViewController.m
//  PYBaseView_Example
//
//  Created by 衣二三 on 2019/8/26.
//  Copyright © 2019 LiPengYue. All rights reserved.
//

#import "PYRoundViewController.h"

@interface PYRoundViewController ()
@property (nonatomic,strong) PYBaseView *roundView;
@end

@implementation PYRoundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.roundView];
    UIImageView *imageView = [UIImageView new];
    imageView.image = [UIImage imageNamed:@"1"];
    [self.roundView.containerView addSubview:imageView];
    self.roundView.frame = CGRectMake(20,100, 200, 200);
    imageView.frame = self.roundView.bounds;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.roundView beginShadowAnimation:^(PYViewShadowConfigration * _Nonnull config) {
        config
        .setUpFromShadowColor(UIColor.redColor)
        .setUpToShadowColor(UIColor.grayColor)
        .setUpFromShadowOffset(CGSizeMake(10, 10))
        .setUpToShadowOffset(CGSizeMake(5, 4))
        .setUpToShadowOpacity(1)
        .beginAnimationWithDuration(2);
    }];
}

- (PYBaseView *)roundView {
    if (!_roundView) {
        _roundView = [PYBaseView new];
        _roundView
        .config
        .setUpLeftTopAddRadius(6)//左上角追加圆角半径
        .setUpLeftBottomAddRadius(20)//左下角追加圆角半径
        .setUpRightTopAddRadius(35)//右上角追加圆角半径
        .setUpRightBottomAddRadius(50)//右下角追加圆角半径
        .setUpShadowAlpha(1)
        .setUpShadowColor(UIColor.redColor)
        .setUpShadowRadius(10)
        .setUpShadowOffset(CGSizeMake(10, 10))
        .setUpRightBottomAddRadius(50)
        .setUpShadowAlpha(1)
        .setUpShadowColor(UIColor.redColor)
        .setUpShadowRadius(10)
        .setUpShadowOffset(CGSizeMake(10, 10));
        _roundView.isDrawShadow = true;
       
    }
    return _roundView;
}

@end
