//
//  PYBaseCollectionViewController.m
//  PYBaseViews_Example
//
//  Created by 衣二三 on 2019/12/26.
//  Copyright © 2019 LiPengYue. All rights reserved.
//

#import "PYBaseCollectionViewController.h"
#import "PYSegmentCollectionView.h"


@interface PYBaseCollectionViewController ()
<
BaseSegmentTagViewDelegate,
BaseSegmentContentViewDelegate
>
/// BaseSegmentCollectionView
@property (nonatomic,strong) PYSegmentCollectionView *collectionView;
@end

@implementation PYBaseCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    self.collectionView.frame = self.view.bounds;
    self.collectionView.frame = CGRectMake(0, PYBaseSize.navTotalH, PYBaseSize.screenW, PYBaseSize.screen_navH);
    self.collectionView.contentViewDelegate = self;
    self.collectionView.tagViewDelegate = self;
    
}

- (PYSegmentCollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        
        _collectionView = [[PYSegmentCollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    }
    return _collectionView;
}

- (SBaseSegmentTagViewData)baseSegmentTagView:(BaseSegmentTagView *)tagView
                            andGetDataWithRow:(NSInteger)row
                                   andSection:(NSInteger)section {
    SBaseSegmentTagViewData data;
    data.itemSize = CGSizeMake(50, 50);
    return data;
}


- (BOOL)baseSegmentTagView:(BaseSegmentTagView *)tagView
       shouldSelectedIndex:(NSInteger)selectedIndex {
    [self.collectionView.segmentContentView scrollToIndex:selectedIndex andAnimated:true];
    return true;
}

/// 是否应该 显示下一页 （在翻页之前调用）
- (BOOL)shouldAppearView:(BaseSegmentContentView *)segmentView andToIndex:(NSInteger)toIndex {
//    if (toIndex == 2) {
//        return false;
//    }
    return true;
}

/// 已经翻页调用
- (void) didAppearView:(BaseSegmentContentView *)segmentView
              andIndex:(NSInteger)index {
    [self.collectionView.tagView scrollToIndex:segmentView.currentSelectedIndex andAnimated:true];
}

/// 左右滑动
- (void) collectionViewDidScroll:(BaseSegmentContentView *)segmentView {
    
}

@end


