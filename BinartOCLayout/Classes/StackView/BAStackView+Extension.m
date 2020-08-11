//
//  BAStackView+Extension.m
//  BinartOCLayout
//
//  Created by Seven on 2020/8/11.
//

#import "BAStackView+Extension.h"
#import "BAStackViewPrivate.h"
#import "UIView+BAFrame.h"

@implementation BAStackView (Extension)

- (UIView *)addSegmentLineTo:(UIView *)view {
    BAStackViewLineView * line = [self makeLine];
    
    [self addSubview:line];
    
    switch (self.axis) {
        case BAStackViewAxisHorizontal:
            
            break;
            
        case BAStackViewAxisVertical: {
            [line whc_LeftSpace:self.whc_SegmentLinePadding];
            [line whc_RightSpace:self.whc_SegmentLinePadding];
            [line whc_Height:self.whc_SegmentLineSize];
            
            switch (self.alignment) {
                case BAStackViewAlignmentLeading: {
                    [line whc_TopSpace:self.verticalSpacing / 2.0 toView:view];
                }
                    break;
                    
                case BAStackViewAlignmentTrailing: {
                    [line whc_BottomSpace:self.verticalSpacing / 2.0 toView:view];
                }
                    break;
                    
                default:
                    break;
            }
            
        }
            break;
            
        default:
            break;
    }

    return line;
}

- (void)appendVertical:(UIView *)view {
    switch (self.alignment) {
        case BAStackViewAlignmentLeading:
            [view whc_TopSpace:self.padding.top];
            
            break;
            
        case BAStackViewAlignmentTrailing:
            [view whc_BottomSpace:self.padding.bottom];
            break;
            
        default:
            // 不支持！！！
            break;
    }
    
    [view whc_LeftSpace:self.padding.left];
}

- (void)appendVertical:(UIView *)view next:(UIView *)toView {
    BOOL need = self.whc_SegmentLineSize > 0;

    switch (self.alignment) {
        case BAStackViewAlignmentLeading: {
            toView = need ? [self addSegmentLineTo:toView]:toView;
            CGFloat vspacing = need ? self.verticalSpacing/2 : self.verticalSpacing;
            
            [view whc_TopSpace:vspacing toView:toView];
        }
            break;
            
        case BAStackViewAlignmentTrailing: {
            
            toView = need ? [self addSegmentLineTo:toView]:toView;
            CGFloat vspacing = need ? self.verticalSpacing/2 : self.verticalSpacing;
            
            [view whc_BottomSpace:vspacing toView:toView];
        }
            break;
            
        default:
            // 不支持！！！
            break;
    }
    
    [view whc_LeftSpace:self.padding.left];
}

- (void)appendVertical:(UIView *)view from:(UIView *)frontView to:(UIView *)nextView {
    BOOL needLine = self.whc_SegmentLineSize > 0;

    switch (self.alignment) {
        case BAStackViewAlignmentLeading: {
            if (frontView) {
                frontView = needLine ? [self addSegmentLineTo:frontView]:frontView;
                CGFloat vspacing = needLine ? self.verticalSpacing/2 : self.verticalSpacing;
                
                [view whc_TopSpace:vspacing+self.padding.top toView:frontView];
            } else {
                [view whc_TopSpace:self.padding.top];
            }
            
        }
            break;
            
        case BAStackViewAlignmentTrailing: {
            
            if (frontView) {
                frontView = needLine ? [self addSegmentLineTo:frontView]:frontView;
                CGFloat vspacing = needLine ? self.verticalSpacing/2 : self.verticalSpacing;
                
                [view whc_BottomSpace:vspacing+self.padding.bottom toView:frontView];
            } else {
                [view whc_BottomSpace:self.padding.bottom];
            }
        }
            break;
            
        default:
            // 不支持！！！
            break;
    }
    
    [view whc_LeftSpace:self.padding.left];
    
    if (nextView) {
        // 宽度处理
        if (self.arrangedSubviewWidth > 0) {
            [view whc_Width:self.arrangedSubviewWidth];
        } else {
            if (self.widthHeightRatio > 0) {
                [view whc_WidthHeightRatio:self.widthHeightRatio];
            } else {
                if (_autoWidth) {
                    [view whc_AutoWidth];
                } else {
                    [view whc_RightSpace:self.padding.right];
                }
            }
        }
        
        // 高度处理
        if (self.arrangedSubviewHeight > 0) {
            [view whc_Height:self.arrangedSubviewHeight];
        } else {
            if (self.heightWidthRatio > 0) {
                [view whc_HeightWidthRatio:self.heightWidthRatio];
            } else {
                if (_autoHeight) {
                    [view whc_AutoHeight];
                }else {
                    [view whc_HeightEqualView:nextView
                                        ratio:view.whc_HeightWeight / nextView.whc_HeightWeight];
                }
            }
        }
    } else {
        // 宽度处理
        if (self.arrangedSubviewWidth > 0) {
            [view whc_Width:self.arrangedSubviewWidth];
            if (_autoWidth) {
                [view whc_RightSpace:self.padding.right];
            }
        } else {
            if (self.widthHeightRatio > 0) {
                [view whc_WidthHeightRatio:self.widthHeightRatio];
                if (_autoWidth) {
                    [view whc_RightSpace:self.padding.right];
                }
            } else {
                if (_autoWidth) {
                    [view whc_AutoWidth];
                } else {
                    [view whc_RightSpace:self.padding.right];
                }
            }
        }
        
        // 与下一个视图的关系
        if (self.arrangedSubviewHeight > 0) {
            [view whc_Height:self.arrangedSubviewHeight];
            
            // 以 arrangedSubviewHeight 为优先
//            if (_autoHeight) {
//                [view whc_BottomSpace:self.padding.bottom];
//            }
        } else {
            if (self.heightWidthRatio > 0) {
                [view whc_HeightWidthRatio:self.heightWidthRatio];
                
                // 以 heightWidthRatio 为优先
//                if (_autoHeight) {
//                    [view whc_BottomSpace:self.padding.bottom];
//                }
            } else {
                if (_autoHeight) {
                    [view whc_AutoHeight];
                }
                
                switch (self.alignment) {
                    case BAStackViewAlignmentLeading: {
                        [view whc_BottomSpace:self.padding.bottom];
                    }
                        
                        break;
                        
                    case BAStackViewAlignmentTrailing: {
                        [view whc_TopSpace:self.padding.top];
                    }
                        break;
                        
                    default:
                        break;
                }
                
            }
        }
    }
}

@end
