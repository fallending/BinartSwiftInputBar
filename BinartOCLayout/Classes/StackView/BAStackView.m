#import <objc/runtime.h>

#import "BAStackView.h"
#import "BAStackViewPrivate.h"
#import "BAStackView+Extension.h"
#import "UIView+BAFrame.h"
#import "UIView+BALayout.h"

// MARK: =

@implementation UIView ( BAStackView )

- (void)setWhc_WidthWeight:(CGFloat)whc_WidthWeight {
    objc_setAssociatedObject(self,
                             @selector(whc_WidthWeight),
                             @(whc_WidthWeight),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)whc_WidthWeight {
    CGFloat weight = [objc_getAssociatedObject(self, _cmd) floatValue];
    if (weight == 0) {
        weight = 1;
    }
    return weight;
}

- (void)setWhc_HeightWeight:(CGFloat)whc_HeightWeight {
    objc_setAssociatedObject(self,
                             @selector(whc_HeightWeight),
                             @(whc_HeightWeight),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)whc_HeightWeight {
    CGFloat weight = [objc_getAssociatedObject(self, _cmd) floatValue];
    if (weight == 0) {
        weight = 1;
    }
    return weight;
}

@end

// MARK: =


@implementation BAStackViewLineView

@end

// MARK: =

@implementation BAStackView

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setWhc_WidthWeight:(CGFloat)whc_WidthWeight {
    objc_setAssociatedObject(self,
                             @selector(whc_WidthWeight),
                             @(whc_WidthWeight),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setWhc_ElementHeightWidthRatio:(CGFloat)heightWidthRatio {
    _heightWidthRatio = heightWidthRatio;
    _widthHeightRatio = 0;
}

- (void)setWhc_ElementWidthHeightRatio:(CGFloat)widthHeightRatio {
    _widthHeightRatio = widthHeightRatio;
    _heightWidthRatio = 0;
}

- (NSInteger)arrangedSubviewCount {
    return self.arrangedSubViews.count;
}

- (NSInteger)columns {
    return MAX(_columns, 1);
}

- (void)whc_AutoHeight {
    [super whc_AutoHeight];
    
    _autoHeight = YES;
}

- (void)autoHeight {
    CGFloat estimateHeight = 0;
    switch (self.flex.direction) {
            // 只关心主轴未水平方向的自动高度，因为此时，高度才是伸展的
        case BADirectionRow:
        case BADirectionRowReverse: {
            estimateHeight = self.arrangedSubviewHeight + self.padding.top + self.padding.bottom;
            
            // 如果支持换行，换行需要指定元素宽度，或者行数、列数
            if (self.flex.wrap == BAWrapWrap ||
                self.flex.wrap == BAWrapWrapReverse) {
                long numbersOfLine = self.arrangedSubviewCount / self.columns + ((self.arrangedSubviewCount%self.columns) == 0 ? 0 : 1);
                
                estimateHeight = numbersOfLine * (self.arrangedSubviewHeight + self.verticalSpacing) + self.padding.top + self.padding.bottom;
            }
        }
            break;
            
        default:
            estimateHeight = 0;
            break;
    }

    [self whc_Height:estimateHeight];
}

- (void)autoWidth {
    CGFloat estimateWidth = 0;
    
    switch (self.flex.direction) {
            // 只关心主轴为垂直方向的自动宽度，因为此时，高度才是伸展的
        case BADirectionColumn:
        case BADirectionColumnReverse: {
            estimateWidth = self.arrangedSubviewCount * (self.arrangedSubviewWidth + self.horizontalSpacing)+self.padding.left+self.padding.right;
            
            if (self.flex.wrap == BAWrapWrap ||
                self.flex.wrap == BAWrapWrapReverse) {
                long numberOfColumns = self.arrangedSubviewCount / self.columns + ((self.arrangedSubviewCount%self.columns) == 0 ? 0 : 1);
                
                estimateWidth = numberOfColumns * (self.arrangedSubviewWidth + self.horizontalSpacing) + self.padding.left + self.padding.right;
            }
        }
            break;
            
        default:
            estimateWidth = 0;
            break;
    }
    
    [self whc_Width:estimateWidth];
}

- (HeightAuto)whc_HeightAuto {
    _autoHeight = YES;
    __weak typeof(self) weakSelf = self;
    return ^() {
        [super whc_AutoHeight];
        return weakSelf;
    };
}

- (void)whc_AutoWidth {
    [super whc_AutoWidth];
    _autoWidth = YES;
}

- (WidthAuto)whc_WidthAuto {
    _autoWidth = YES;
    __weak typeof(self) weakSelf = self;
    return ^() {
        [super whc_AutoWidth];
        return weakSelf;
    };
}

- (NSArray<UIView *> *)arrangedSubViews {
    NSMutableArray * subViews = [NSMutableArray array];
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isKindOfClass:BAStackViewLineView.self]) {
            [subViews addObject:obj];
        }
    }];
    return subViews;
}

- (void)layoutMe {
    [self runStackLayoutEngine];
}

- (BAStackViewLineView *)makeLine {
    BAStackViewLineView * lineView = [BAStackViewLineView new];

    if (self.whc_SegmentLineColor) {
        lineView.backgroundColor = self.whc_SegmentLineColor;
    } else {
        lineView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    }

    return lineView;
}

- (void)removeAllArrangedSubviews {
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
        [obj whc_ResetConstraints];
    }];
}

- (void)removeAllSegmentLine {
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj whc_ResetConstraints];
        if ([obj isKindOfClass:[BAStackViewLineView class]]) {
            [obj removeFromSuperview];
        }
    }];
}

- (void)runStackLayoutEngine {
    [self removeAllSegmentLine];
    NSArray * subViews = self.subviews;
    NSInteger count = subViews.count;
    if (count == 0) {
        return;
    }
    UIView * toView = nil;
    
    switch (self.flex.direction) {
            // 水平轴为主轴
        case BADirectionRow:
        case BADirectionRowReverse: {
            for (int i = 0; i < count; i++) {
                UIView * view = subViews[i];
                UIView * nextView = i < count - 1 ? subViews[i + 1] : nil;

                [self appendHorizontal:view from:toView to:nextView];
                
                toView = view;
                if ([toView isKindOfClass:[BAStackView class]]) {
                    [((BAStackView *)toView) layoutMe];
                }
            }
            break;
        }
            
            // 纵轴为主轴
        case BADirectionColumn:
        case BADirectionColumnReverse: {
            toView = nil; // 应该总是从容器开始的
            for (int i = 0; i < count; i++) {
                UIView * view = subViews[i]; // 当前要处理的视图
                UIView * nextView = i < count - 1 ? subViews[i + 1] : nil; // 下一个要处理的视图
                
                [self appendVertical:view from:toView to:nextView];

                toView = view;
                if ([toView isKindOfClass:[BAStackView class]]) {
                    [((BAStackView *)toView) layoutMe];
                }
            }
            break;
        }
            
            // ？？？？
//        case BALayoutAxisAll: {
//            for (UIView * view in self.subviews) {
//                [view whc_ResetConstraints];
//
//            }
//            subViews = self.subviews;
//            count = subViews.count;
//
//            NSInteger rowCount = count / self.columns + (count % self.columns == 0 ? 0 : 1);
//            NSInteger index = 0;
//            _lastRowVacantCount = rowCount * self.columns - count;
//            for (NSInteger i = 0; i < _lastRowVacantCount; i++) {
////                WHC_VacntView * view = [WHC_VacntView new];
////
////                view.backgroundColor = [UIColor clearColor];
////
////                [self addSubview:view];
//            }
//            if (_lastRowVacantCount > 0) {
//                subViews = nil;
//                subViews = self.subviews;
//                count = subViews.count;
//            }
//            UIView * frontRowView = nil;
//            UIView * frontColumnView = nil;
//
//            BAStackViewLineView * columnLineView = nil;
//            for (NSInteger row = 0; row < rowCount; row++) {
//                UIView * nextRowView = nil;
//                UIView * rowView = subViews[row * self.columns];
//                NSInteger nextRow = (row + 1) * self.columns;
//                if (nextRow < count) {
//                    nextRowView = subViews[nextRow];
//                }
//                BAStackViewLineView * rowLineView = nil;
//                if (self.whc_SegmentLineSize > 0.0 && row > 0) {
//                    rowLineView = [self makeLine];
//                    [self addSubview:rowLineView];
//                    [rowLineView whc_LeftSpace:self.whc_SegmentLinePadding];
//                    [rowLineView whc_RightSpace:self.whc_SegmentLinePadding];
//                    [rowLineView whc_Height:self.whc_SegmentLineSize];
//                    [rowLineView whc_TopSpace:self.verticalSpacing / 2.0 toView:frontRowView];
//                }
//                for (NSInteger column = 0; column < self.columns; column++) {
//                    index = row * self.columns + column;
//                    UIView * view = subViews[index];
//                    UIView * nextColumnView = nil;
//                    if (column > 0 && self.whc_SegmentLineSize > 0.0) {
//                        columnLineView = [self makeLine];
//                        [self addSubview:columnLineView];
//                        [columnLineView whc_LeftSpace:self.horizontalSpacing / 2.0 toView:frontColumnView];
//                        [columnLineView whc_TopSpace:self.whc_SegmentLinePadding];
//                        [columnLineView whc_BottomSpace:self.whc_SegmentLinePadding];
//                        [columnLineView whc_Width:self.whc_SegmentLineSize];
//                    }
//                    if (column < self.columns - 1 && index < count) {
//                        nextColumnView = subViews[index + 1];
//                    }
//                    if (row == 0) {
//                        [view whc_TopSpace:self.padding.top];
//                    }else {
//                        if (rowLineView) {
//                            [view whc_TopSpace:self.verticalSpacing / 2.0 toView:rowLineView];
//                        }else {
//                            [view whc_TopSpace:self.verticalSpacing toView:frontRowView];
//                        }
//                    }
//                    if (column == 0) {
//                        [view whc_LeftSpace:self.padding.left];
//                    }else {
//                        if (columnLineView) {
//                            [view whc_LeftSpace:self.horizontalSpacing / 2.0 toView:columnLineView];
//                        }else {
//                            [view whc_LeftSpace:self.horizontalSpacing toView:frontColumnView];
//                        }
//
//                    }
//                    if (nextRowView) {
//                        if (self.arrangedSubviewHeight > 0) {
//                            [view whc_Height:self.arrangedSubviewHeight];
//                        }else {
//                            if (_heightWidthRatio > 0) {
//                                [view whc_HeightWidthRatio:_heightWidthRatio];
//                            }else {
//                                if (_autoHeight) {
//                                    [view whc_AutoHeight];
//                                }else {
//                                    [view whc_HeightEqualView:nextRowView
//                                                        ratio:view.whc_HeightWeight / nextRowView.whc_HeightWeight];
//                                }
//                            }
//                        }
//                    }else {
//                        if (self.arrangedSubviewHeight > 0) {
//                            [view whc_Height:self.arrangedSubviewHeight];
//                        }else {
//                            if (_heightWidthRatio > 0) {
//                                [view whc_HeightWidthRatio:_heightWidthRatio];
//                            }else {
//                                if (_autoHeight) {
//                                    [view whc_AutoHeight];
//                                }else {
//                                    [view whc_BottomSpace:self.padding.bottom];
//                                }
//                            }
//                        }
//                    }
//                    if (nextColumnView) {
//                        if (self.arrangedSubviewWidth > 0) {
//                            [view whc_Width:self.arrangedSubviewWidth];
//                        }else {
//                            if (_widthHeightRatio > 0) {
//                                [view whc_WidthHeightRatio:_widthHeightRatio];
//                            }else {
//                                if (_autoWidth) {
//                                    [view whc_AutoWidth];
//                                }else {
//                                    [view whc_WidthEqualView:nextColumnView
//                                                   ratio:view.whc_WidthWeight / nextColumnView.whc_WidthWeight];
//                                }
//                            }
//                        }
//                    } else {
//                        if (self.arrangedSubviewWidth > 0) {
//                            [view whc_Width:self.arrangedSubviewWidth];
//                        }else {
//                            if (_widthHeightRatio > 0) {
//                                [view whc_WidthHeightRatio:_widthHeightRatio];
//                            }else {
//                                if (_autoWidth) {
//                                    [view whc_AutoWidth];
//                                }else {
//                                    [view whc_RightSpace:self.padding.right];
//                                }
//                            }
//                        }
//                    }
//                    frontColumnView = view;
//                    if ([frontColumnView isKindOfClass:[BAStackView class]]) {
//                        [((BAStackView *)frontColumnView) layoutMe];
//                    }
//                }
//                frontRowView = rowView;
//            }
//            break;
//        }
            
        default:
            break;
    }
    
//    if (_autoWidth && _axis != BALayoutAxisHorizontal) {
//                        NSInteger subCount = self.subviews.count;
//
//                        [self layoutIfNeeded];
//
//                        CGFloat rowLastColumnViewMaxX = 0;
//                        UIView * rowLastColumnViewMaxXView;
//                        for (NSInteger r = 0; r < subCount; r++) {
//                            NSInteger index = r;
//                            UIView * maxWidthView = self.subviews[index];
//
//                            [maxWidthView layoutIfNeeded];
//
//                            if (maxWidthView.whc_maxX > rowLastColumnViewMaxX) {
//                                rowLastColumnViewMaxX = maxWidthView.whc_maxX;
//                                rowLastColumnViewMaxXView = maxWidthView;
//                            }
//                        }
//                        [rowLastColumnViewMaxXView whc_RightSpace:_padding.right];
//                    }
//
//                    if (_autoHeight && _axis != BALayoutAxisVertical) {
//                        NSInteger subCount = self.subviews.count;
//
//                        [self layoutIfNeeded];
//
//                        CGFloat columnLastRowViewMaxY = 0;
//                        UIView * columnLastRowViewMaxYView;
//                        for (NSInteger r = 0; r < subCount; r++) {
//                            NSInteger index = r;
//                            UIView * maxHeightView = self.subviews[index];
//
//                            [maxHeightView layoutIfNeeded];
//
//                            if (maxHeightView.whc_maxY > columnLastRowViewMaxY) {
//                                columnLastRowViewMaxY = maxHeightView.whc_maxY;
//                                columnLastRowViewMaxYView = maxHeightView;
//                            }
//                        }
//                        [columnLastRowViewMaxYView whc_BottomSpace:_padding.bottom];
//                    }
}


@end
