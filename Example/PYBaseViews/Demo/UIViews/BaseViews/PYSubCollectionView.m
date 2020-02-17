//
//  PYSubCollectionView.m
//  PYBaseViews_Example
//
//  Created by 李鹏跃 on 2020/2/7.
//  Copyright © 2020 LiPengYue. All rights reserved.
//

#import "PYSubCollectionView.h"
#import "PYNormalCollectionViewCell.h"
#import <MJRefresh/MJRefresh.h>
@interface PYSubCollectionView ()
<
UICollectionViewDelegateFlowLayout,
UICollectionViewDelegate,
UICollectionViewDataSource
>
@property (nonatomic,assign) CGSize itemSize;
@end

@implementation PYSubCollectionView
+ (instancetype) create {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.sectionInset = UIEdgeInsetsMake(10, 14, 14, 14);
    return [[self alloc]initWithFrame:CGRectZero collectionViewLayout: layout];
}
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        [self baseSetup];
        self.alwaysBounceVertical = true;/// 这句话必须要
    }
    return self;
}


- (void) baseSetup {
    self.delegate = self;
    self.dataSource = self;
    self.panGestureRecognizer.cancelsTouchesInView = NO;
    
    [self registerClass:PYNormalCollectionViewCell.class forCellWithReuseIdentifier:@"CELLID"];
    __weak typeof (self)weakSelf = self;
    self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.mj_footer endRefreshing];
        });
    }];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        PYNormalCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELLID" forIndexPath:indexPath];
        cell.backgroundColor = UIColor.redColor;
        return cell;
    }
    return nil;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 15;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.itemSize.width <= CGFLOAT_MIN) {
        CGFloat w = (self.frame.size.width - 28 - 10)/2.0;
        self.itemSize = CGSizeMake(w, w * 1.5);
    }
    return self.itemSize;
}
@end
