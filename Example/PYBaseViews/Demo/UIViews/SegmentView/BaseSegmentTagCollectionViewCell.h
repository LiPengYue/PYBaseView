//
//  BaseSegmentTagCollectionViewCell.h
//  MFNestTableViewDemo
//
//  Created by 衣二三 on 2019/12/24.
//  Copyright © 2019 Lyman Li. All rights reserved.
//

#import <UIKit/UIKit.h>

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

@property (nonatomic,assign) SBaseSegmentTagCollectionViewCellData styleData;
@end

struct SBaseSegmentTagCollectionViewCellData {
    UIColor *selectedBackgroundColor;
    UIColor *normalBackgroundColor;
    
    UIColor *selectedTextColor;
    UIColor *normalTextColor;
    
    CGFloat normalBorderW;
    CGFloat selectedBorderW;
    
    CGFloat normalCornerRadius;
    CGFloat selectedCornerRadius;
    
    UIColor *selectedBorderColor;
    UIColor *normalBorderColor;
    
    UIFont *selectedFont;
    UIFont *normalFont;
};


/**
 创建 data
 
 * selectedTextColor #1C1C1C
 * normalTextColor #999999
 * 其他都是 0 或 nil
 */
NS_INLINE SBaseSegmentTagCollectionViewCellData SBaseSegmentTagCollectionViewCellDataMakeDefault() {
    SBaseSegmentTagCollectionViewCellData data;
    
    data.selectedBackgroundColor = UIColor.whiteColor;
    data.normalBackgroundColor = UIColor.whiteColor;
    data.selectedTextColor = [UIColor colorWithRed:28/255.0 green:28/255.0 blue:28/255.0 alpha:1.0];
    data.normalTextColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    data.normalBorderW = 0;
    data.selectedBorderW = 0;
    data.normalCornerRadius = 0;
    data.selectedCornerRadius = 0;
    data.selectedBorderColor = nil;
    data.normalBorderColor = nil;
    return data;
}

NS_ASSUME_NONNULL_END
