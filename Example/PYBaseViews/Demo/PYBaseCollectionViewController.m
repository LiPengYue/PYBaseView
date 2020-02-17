//
//  PYBaseCollectionViewController.m
//  PYBaseViews_Example
//
//  Created by 衣二三 on 2019/12/26.
//  Copyright © 2019 LiPengYue. All rights reserved.
//

#import "PYBaseCollectionViewController.h"
#import "PYBaseSegmentCollectionView.h"
#import <MJRefresh/MJRefresh.h>
#import "PYSubTableVew.h"
#import "PYScrollView.h"
#import <PYBaseView.h>
#import "PYSegmentContentViewCollectionViewCell.h"
#import "PYSegmentTagsCollectionViewCell.h"
#import "PYSubCollectionView.h"
#import "PYWkWebView.h"
#import "BaseSegmentTagView.h"
@interface PYBaseCollectionViewController ()
<
UICollectionViewDelegateFlowLayout,
UICollectionViewDelegate,
UICollectionViewDataSource,
BaseSegmentTagViewDelegate,
PYBaseSegmentContentViewDelegate
>
/// PYBaseSegmentCollectionView
@property (nonatomic,strong) PYBaseSegmentCollectionView *collectionView;

@property (nonatomic,weak) PYBaseSegmentContentView *segmentContentView;
@property (nonatomic,weak) BaseSegmentTagView *tagView;
@property (nonatomic, strong) NSMutableArray <UIView *> *viewList;
@property (nonatomic, strong) NSMutableArray <NSString *> *tagNames;
@property (nonatomic,assign) NSInteger isReload;
@end

static NSString *const KSegmentTagCellId= @"PYSegmentTagsCollectionViewCell";
static NSString *const KSegmentViewCellId= @"PYSegmentContentViewCollectionViewCell";
static NSString *const KNormalCellId= @"CELLID";

@implementation PYBaseCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    self.title = @"PYBaseSegmentCollectionView";
    self.collectionView.frame = self.view.bounds;
    self.collectionView.backgroundColor = UIColor.whiteColor;
    self.collectionView.frame = CGRectMake(0, PYBaseSize.navTotalH, PYBaseSize.screenW, PYBaseSize.screen_navH);
  self.collectionView.topSpacing = CGFLOAT_MAX;
    __weak typeof(self)weakSelf = self;
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.collectionView reloadData];
            weakSelf.isReload = true;
            
            weakSelf.collectionView.topSpacing = CGFLOAT_MAX;
            [weakSelf.collectionView.mj_header endRefreshing];
        });
    }];
}

- (PYBaseSegmentCollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        
        _collectionView = [[PYBaseSegmentCollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.panGestureRecognizer.cancelsTouchesInView = NO;
        
        /// 第一组的cell
        [_collectionView registerClass:UICollectionViewCell.class
                forCellWithReuseIdentifier:KNormalCellId];
        /// 第二组的tags
        [_collectionView registerClass:PYSegmentTagsCollectionViewCell.class
                forCellWithReuseIdentifier:KSegmentTagCellId];
        /// 第三组的 左右滑动cell
        [_collectionView registerClass:PYSegmentContentViewCollectionViewCell.class
                forCellWithReuseIdentifier:KSegmentViewCellId];
    }
    return _collectionView;
}

#pragma mark - delegate && DataSource
//MARK: BaseSegmentTagViewDelegate
- (CGSize) baseSegmentTagView:(BaseSegmentTagView *)tagView sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *tagName = self.tagNames[indexPath.row];
    NSInteger titleW = [tagName sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(600, 60)].width;
    
    return CGSizeMake(titleW + 2, 60);
}

- (BOOL)baseSegmentTagView:(BaseSegmentTagView *)tagView
       shouldSelectedIndex:(NSInteger)selectedIndex {
    [self.segmentContentView scrollToIndex:selectedIndex andAnimated:true];
    return true;
}


//MARK: PYBaseSegmentContentViewDelegate
/// 是否应该 显示下一页 （在翻页之前调用）
- (void)willDisplayView:(PYBaseSegmentContentView *)segmentView forItemAtIndex:(NSInteger)index {
    NSLog(@"将要显示第 %ld页",index);
}

/// 已经翻页调用
- (void) didEndDisplayingView:(PYBaseSegmentContentView *)segmentView
              forItemAtIndex:(NSInteger)index {

    NSLog(@"当前显示第 %ld 页",(long)index);
}

/// 左右滑动
- (void) collectionViewDidScroll:(PYBaseSegmentContentView *)segmentView {
    [self.tagView scrollToIndex:segmentView.currentSelectedIndex
                    andAnimated:segmentView.collectionView.tracking];
}

/// MARK: collectionView delegate and datasource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELLID" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor colorWithRed:0.9 green:0.0 blue:0.5 alpha:1];
        return cell;
    }
    if (indexPath.section == 1) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELLID" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor colorWithRed:0.9 green:0.5 blue:0.5 alpha:1];
        return cell;
    }
    if (indexPath.section == 2) {
        PYSegmentTagsCollectionViewCell *cell = (PYSegmentTagsCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PYSegmentTagsCollectionViewCell" forIndexPath:indexPath];
        cell.backgroundColor = UIColor.redColor;
        self.tagView = cell.tagView;
        self.tagView.modelArray = self.tagNames;
        self.tagView.delegate = self;
        ///
        self.collectionView.topSpacing = cell.frame.origin.y;
        return cell;
    }
    if (indexPath.section == 3) {
        PYSegmentContentViewCollectionViewCell *cell = (PYSegmentContentViewCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PYSegmentContentViewCollectionViewCell" forIndexPath:indexPath];
        cell.backgroundColor = UIColor.redColor;
        cell.segmentContentView.subViewArray = self.viewList;
        cell.segmentContentView.delegate = self;
        self.segmentContentView = cell.segmentContentView;
        return cell;
    }
    
    return nil;
}

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) return 12;
    if (section == 1) return 3;
    return 1;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat tagsViewH = 60;
    CGFloat segmentViewH = PYBaseSize.screen_navH - tagsViewH; /// 注意 tagsViewH 必须要等于总高度减去tagsViewH
    
    if (indexPath.section == 0) {
        return CGSizeMake(30, 20);
    }
    if (indexPath.section == 1) {
        CGFloat H = 40;
        if (indexPath.row == 0) {
            H = self.isReload ? 100 : 50;
        }
        if (indexPath.row == 1) {
            H = 30;
        }
        if (indexPath.row == 2) {
            H = 20;
        }
        return CGSizeMake(PYBaseSize.screenW, H);
    }
    if (indexPath.section == 2) {
        return CGSizeMake(PYBaseSize.screenW, tagsViewH);
    }
    return CGSizeMake(PYBaseSize.screenW, segmentViewH);
}

- (NSMutableArray<NSString *> *)tagNames {
    if (!_tagNames) {
        _tagNames = @[@"collectionView",@"tabeView",@"scrollView",@"webview"].mutableCopy;
    }
    return _tagNames;
}

- (NSMutableArray<UIView *> *)viewList {
    if (!_viewList) {
        _viewList = [[NSMutableArray alloc] init];
        PYSubCollectionView * collectionView = [self createCollectionView];
        PYSubTableVew *tableView = [self createTableView];
        PYScrollView *scrollView = [self createScrollView];
        PYWkWebView *webview = [self createWebView];
        
        [self.collectionView registerContentWithView:collectionView
                           andContentInnerScrollView:collectionView];
        [self.collectionView registerContentWithView:tableView
                           andContentInnerScrollView:tableView];
        [self.collectionView registerContentWithView:scrollView
                           andContentInnerScrollView:scrollView];
        [self.collectionView registerContentWithView:webview
                           andContentInnerScrollView:webview.scrollView];
        
        [_viewList addObject:collectionView];
        [_viewList addObject:tableView];
        [_viewList addObject:scrollView];
        [_viewList addObject:webview];
    }
    return _viewList;
}

- (PYSubCollectionView *)createCollectionView {
    PYSubCollectionView *collectionView = [PYSubCollectionView create];
    return collectionView;
}

- (PYSubTableVew *)createTableView {
    PYSubTableVew *tableView = [[PYSubTableVew alloc] initWithFrame:CGRectZero];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return tableView;
}

- (PYScrollView *) createScrollView {
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
    return scrollView;
}

- (PYWkWebView *) createWebView {
    PYWkWebView *webview = [[PYWkWebView alloc] init];
    webview.backgroundColor = [UIColor whiteColor];
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.jianshu.com/u/d41e51daf400"]]];
    return webview;
}

@end


