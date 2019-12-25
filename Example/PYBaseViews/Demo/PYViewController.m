//
//  PYViewController.m
//  PYBaseViews
//
//  Created by LiPengYue on 08/23/2019.
//  Copyright (c) 2019 LiPengYue. All rights reserved.
//

#import "PYViewController.h"
#import "PYMainView.h"
#import <PYBaseEventHandler.h>
#import <PYBaseView.h>


@interface PYViewController ()

@property (nonatomic,strong) PYMainView *mainView;
@end

@implementation PYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self registerEvents];
    
}

- (void) setupView {
    CGRect rect = self.view.bounds;
    rect.origin.y = PYBaseSize.navTotalH;
    rect.size.height = PYBaseSize.screen_navH;
    self.mainView = [[PYMainView alloc] initWithFrame:rect];
    [self.view addSubview:self.mainView];
}

- (void) registerEvents {
    __weak typeof (self)weakSelf = self;
    [NSObject receivedWithSender:self.mainView andSignal:^id(NSString *key, id message) {
        if ([key isEqualToString:kClickMainView]) {
            if ([message isKindOfClass:UIViewController.class]) {
                UIViewController *vc = message;
                [weakSelf.navigationController pushViewController:vc animated:true];
            }
        }
        return nil;
    }];
}

@end
