//
//  PYSegmentCollectionView.m
//  PYBaseViews_Example
//
//  Created by 衣二三 on 2019/12/26.
//  Copyright © 2019 LiPengYue. All rights reserved.
//

#import "PYSegmentCollectionView.h"
#import "PYSubTableVew.h"
#import "PYScrollView.h"
#import <PYBaseView.h>
#import "PYSegmentContentViewCollectionViewCell.h"
#import "PYSegmentTagsCollectionViewCell.h"

@interface PYSegmentCollectionView()
<
UICollectionViewDelegateFlowLayout,
UICollectionViewDelegate,
UICollectionViewDataSource
>
@property (nonatomic, strong) NSMutableArray <UIView *> *viewList;

@end

@implementation PYSegmentCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        [self baseSetup];
    }
    return self;
}


- (void) baseSetup {
    self.delegate = self;
    self.dataSource = self;
    self.panGestureRecognizer.cancelsTouchesInView = NO;
    
    [self registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:@"CELLID"];
    [self registerClass:PYSegmentTagsCollectionViewCell.class forCellWithReuseIdentifier:@"PYSegmentTagsCollectionViewCell"];
    [self registerClass:PYSegmentContentViewCollectionViewCell.class forCellWithReuseIdentifier:@"PYSegmentContentViewCollectionViewCell"];
    
    
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        self.topSpacing = cell.frame.origin.y;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELLID" forIndexPath:indexPath];
        cell.backgroundColor = UIColor.redColor;
        return cell;
    }
    if (indexPath.section == 1) {
        PYSegmentTagsCollectionViewCell *cell = (PYSegmentTagsCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PYSegmentTagsCollectionViewCell" forIndexPath:indexPath];
        cell.backgroundColor = UIColor.redColor;
        cell.tagView.modelArray = @[@"0000",@"1111",@"2222",@"3333",@"4444"];
        cell.tagView.delegate = self.tagViewDelegate;
        self.tagView = cell.tagView;
        return cell;
    }
    if (indexPath.section == 2) {
       PYSegmentContentViewCollectionViewCell *cell = (PYSegmentContentViewCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PYSegmentContentViewCollectionViewCell" forIndexPath:indexPath];
        cell.backgroundColor = UIColor.redColor;
        cell.segmentContentView.subViewArray = self.viewList;
        cell.segmentContentView.delegate = self.contentViewDelegate;
        self.segmentContentView = cell.segmentContentView;
       return cell;
    }
    
    return nil;
}

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) return 12;
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake(100, 100);
    }
    if (indexPath.section == 1) {
        return CGSizeMake(PYBaseSize.screenW, 60);
    }
    return CGSizeMake(PYBaseSize.screenW, PYBaseSize.screen_navH);
}

- (NSMutableArray<UIView *> *)viewList {
    if (!_viewList) {
        _viewList = [[NSMutableArray alloc] init];
        
        // 添加3个tableview
        for (int i = 0; i < 3; ++i) {
            PYSubTableVew *tableView = [[PYSubTableVew alloc] initWithFrame:CGRectZero];
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            tableView.tag = i;
            __weak typeof (self) weakself = self;
            [weakself registerContentWithView:tableView andContentInnerScrollView:tableView];
            [_viewList addObject:tableView];
        }
        
        // 添加ScrollView
        PYScrollView *scrollView = [[PYScrollView alloc] init];
        scrollView.tag = 100011;
        scrollView.backgroundColor = [UIColor whiteColor];
        UIImage *image = [UIImage imageNamed:@"3"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        CGFloat w = PYBaseSize.screenW;
        imageView.frame = CGRectMake(0, 0, w, w * image.size.height / image.size.width);
        scrollView.contentSize = imageView.frame.size;
        scrollView.alwaysBounceVertical = YES; // 设置为YES，当contentSize小于frame.size也可以滚动
        [scrollView addSubview:imageView];
        scrollView.bounces = true;
        [self registerContentWithView:scrollView
            andContentInnerScrollView:scrollView];
        [_viewList addObject:scrollView];
        
        // 添加webview
        UIWebView *webview = [[UIWebView alloc] init];
        webview.backgroundColor = [UIColor whiteColor];
        [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.lymanli.com/"]]];
        [_viewList addObject:webview];
        [self registerContentWithView:webview
            andContentInnerScrollView:webview.scrollView];
    }
    return _viewList;
}
@end
