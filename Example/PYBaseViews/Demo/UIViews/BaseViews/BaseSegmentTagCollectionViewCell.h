//
//  BaseSegmentTagCollectionViewCell.h
//  PYBaseViews_Example
//
//  Created by 李鹏跃 on 2019/12/24.
//  Copyright © 2019 Lyman Li. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BaseSegmentTagCollectionViewCellStyleModel;

NS_ASSUME_NONNULL_BEGIN
@protocol BaseSegmentTagCollectionViewCellDelegate <NSObject>
- (void) setupData: (id)data;
@end

typedef struct SBaseSegmentTagCollectionViewCellData SBaseSegmentTagCollectionViewCellData;

@interface BaseSegmentTagCollectionViewCell : UICollectionViewCell
<
BaseSegmentTagCollectionViewCellDelegate
>


@property (nonatomic,assign) BOOL isSelected;
@property (nonatomic,strong,readonly) id model;
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) BaseSegmentTagCollectionViewCellStyleModel *styleData;
@end


@interface BaseSegmentTagCollectionViewCellStyleModel : UICollectionViewCell

@property (nonatomic,strong) UIColor *selectedBackgroundColor;
@property (nonatomic,strong) UIColor *normalBackgroundColor;

@property (nonatomic,strong) UIColor *selectedTextColor;
@property (nonatomic,strong) UIColor *normalTextColor;

@property (nonatomic,assign) CGFloat normalBorderW;
@property (nonatomic,assign) CGFloat selectedBorderW;

@property (nonatomic,assign) CGFloat normalCornerRadius;
@property (nonatomic,assign) CGFloat selectedCornerRadius;

@property (nonatomic,strong) UIColor *selectedBorderColor;
@property (nonatomic,strong) UIColor *normalBorderColor;

@property (nonatomic,strong) UIFont *selectedFont;
@property (nonatomic,strong) UIFont *normalFont;
@end

NS_ASSUME_NONNULL_END
