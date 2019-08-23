//
//  PYBaseTableCell.m
//  FBSnapshotTestCase
//
//  Created by 衣二三 on 2019/8/23.
//

#import "PYBaseTableCell.h"

@interface PYBaseTableCell()
@property (nonatomic,strong) NSIndexPath *touchBeginIndexPath;
@end

@implementation PYBaseTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.isHiddenSeparatorLine = false;
        self.separatorLineH = 1;
        [self baseTCellSetupViews];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.isHiddenSeparatorLine = false;
    self.separatorLineH = 1;
    [self baseTCellSetupViews];
}

#pragma mark - setup views
- (void) baseTCellSetupViews {
    [self.contentView addSubview:self.topLineView];
    [self.contentView addSubview:self.bottomLineView];
}

- (void) layoutSubviews {
    [super layoutSubviews];
    [self baseCellSetupLineFrameIfNeeded];
}

#pragma - event
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    self.touchBeginIndexPath = [self.tableView indexPathForCell:self];
}

- (void) longPressGestureAction: (UILongPressGestureRecognizer *)longPressGesture {
    if (longPressGesture.state == UIGestureRecognizerStateBegan) {
        if ([self.delegate respondsToSelector:@selector(longPressGestureActionWithIndex:)]) {
            [self.delegate longPressGestureActionWithIndex:self.touchBeginIndexPath];
        }
    }
}


#pragma mark - get && set
// MARK - get
- (UITableView *)tableView {
    if (!_tableView) {
        if ([self.superview isKindOfClass:UITableView.class]) {
            _tableView = (UITableView *)self.superview;
        }
    }
    return _tableView;
}

- (UIView *) topLineView {
    if (!_topLineView) {
        _topLineView = [UIView new];
    }
    return _topLineView;
}

- (UIView *) bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [UIView new];
    }
    return _bottomLineView;
}

- (UILongPressGestureRecognizer *) longPressGesture {
    if (!_longPressGesture) {
        _longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureAction:)];
    }
    return _longPressGesture;
}

// MARK: - set
- (void) setSeparatorColor:(UIColor *) separatorColor {
    _separatorColor = separatorColor;
    self.topLineView.backgroundColor = self.separatorColor;
    self.bottomLineView.backgroundColor = self.separatorColor;
}

- (void) setSeparatorLineH:(CGFloat)separatorLineH {
    _separatorLineH = separatorLineH;
    [self baseCellSetupLineFrameIfNeeded];
}

- (void) setSeparatorLineEdge:(UIEdgeInsets)separatorLineEdge {
    _separatorLineEdge = separatorLineEdge;
    [self baseCellSetupLineFrameIfNeeded];
}

- (void) baseCellSetupLineFrameIfNeeded {
    if (self.frame.size.height > 1 && !self.isHiddenSeparatorLine) {
        CGFloat top = self.separatorLineEdge.top;
        CGFloat bottom = self.separatorLineEdge.bottom;
        CGFloat right = self.separatorLineEdge.right;
        
        CGFloat x = self.separatorLineEdge.left;
        CGFloat w = self.frame.size.width-x-right;
        CGFloat h = self.separatorLineH;
        CGFloat y = self.frame.size.height - h + top - bottom;
        
        self.topLineView.frame = CGRectMake(x, top, w, h);
        self.bottomLineView.frame = CGRectMake(x, y, w, h);
        self.topLineView.hidden = false;
        self.bottomLineView.hidden = false;
    }else{
        self.topLineView.hidden = true;
        self.bottomLineView.hidden = true;
    }
    
}
@end
