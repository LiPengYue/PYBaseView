//
//  PYSegmentTagsCollectionViewCell.h
//  PYBaseViews_Example
//
//  Created by 衣二三 on 2019/12/26.
//  Copyright © 2019 LiPengYue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYBaseSegmentHandler.h"
#import "BaseSegmentTagView.h"

NS_ASSUME_NONNULL_BEGIN

@interface PYSegmentTagsCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) BaseSegmentTagView *tagView;
@end

NS_ASSUME_NONNULL_END
