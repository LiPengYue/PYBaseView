//
//  PYSegmentCollectionView.h
//  PYBaseViews_Example
//
//  Created by 衣二三 on 2019/12/26.
//  Copyright © 2019 LiPengYue. All rights reserved.
//

#import "BaseSegmentCollectionView.h"

NS_ASSUME_NONNULL_BEGIN

@interface PYSegmentCollectionView : BaseSegmentCollectionView
@property (nonatomic,weak) BaseSegmentContentView *segmentContentView;
@property (nonatomic,weak) BaseSegmentTagView *tagView;
@end

NS_ASSUME_NONNULL_END
