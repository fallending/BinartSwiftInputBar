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
    
    switch (self.flex.direction) {
        case BADirectionRow:
        case BADirectionRowReverse: {
            [line whc_TopSpace:self.whc_SegmentLinePadding];
            [line whc_BottomSpace:self.whc_SegmentLinePadding];
            
            [line whc_Width:self.whc_SegmentLineSize];
            
            switch (self.self.flex.direction) {
                case BADirectionRow: {
                    [line whc_LeftSpace:self.horizontalSpacing / 2.0 toView:view];
                }
                    break;
                    
                case BADirectionRowReverse: {
                    [line whc_RightSpace:self.horizontalSpacing / 2.0 toView:view];
                }
                    break;
                    
                default:
                    break;
            }
        }
            
            break;
            
        case BADirectionColumn:
        case BADirectionColumnReverse: {
            [line whc_LeftSpace:self.whc_SegmentLinePadding];
            [line whc_RightSpace:self.whc_SegmentLinePadding];
            [line whc_Height:self.whc_SegmentLineSize];
            
            switch (self.flex.direction) {
                case BADirectionColumn: {
                    [line whc_TopSpace:self.verticalSpacing / 2.0 toView:view];
                }
                    break;
                    
                case BADirectionColumnReverse: {
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

//- (void)appendVertical:(UIView *)view {
//    switch (self.alignment) {
//        case BAStackViewAlignmentLeading:
//            [view whc_TopSpace:self.padding.top];
//
//            break;
//
//        case BAStackViewAlignmentTrailing:
//            [view whc_BottomSpace:self.padding.bottom];
//            break;
//
//        default:
//            // 不支持！！！
//            break;
//    }
//
//    [view whc_LeftSpace:self.padding.left];
//}
//
//- (void)appendVertical:(UIView *)view next:(UIView *)toView {
//    BOOL need = self.whc_SegmentLineSize > 0;
//
//    switch (self.alignment) {
//        case BAStackViewAlignmentLeading: {
//            toView = need ? [self addSegmentLineTo:toView]:toView;
//            CGFloat vspacing = need ? self.verticalSpacing/2 : self.verticalSpacing;
//
//            [view whc_TopSpace:vspacing toView:toView];
//        }
//            break;
//
//        case BAStackViewAlignmentTrailing: {
//
//            toView = need ? [self addSegmentLineTo:toView]:toView;
//            CGFloat vspacing = need ? self.verticalSpacing/2 : self.verticalSpacing;
//
//            [view whc_BottomSpace:vspacing toView:toView];
//        }
//            break;
//
//        default:
//            // 不支持！！！
//            break;
//    }
//
//    [view whc_LeftSpace:self.padding.left];
//}

- (void)appendVertical:(UIView *)view from:(UIView *)frontView to:(UIView *)nextView {
    BOOL needLine = self.whc_SegmentLineSize > 0;

    switch (self.flex.direction) {
        case BADirectionColumn: {
            if (frontView) {
                frontView = needLine ? [self addSegmentLineTo:frontView]:frontView;
                CGFloat vspacing = needLine ? self.verticalSpacing/2 : self.verticalSpacing;
                
                [view whc_TopSpace:vspacing+self.padding.top toView:frontView];
            } else {
                [view whc_TopSpace:self.padding.top];
            }
            
        }
            break;
            
        case BADirectionColumnReverse: {
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
                
                switch (self.flex.direction) {
                    case BADirectionColumn: {
                        [view whc_BottomSpace:self.padding.bottom];
                    }
                        
                        break;
                        
                    case BADirectionColumnReverse: {
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

- (void)appendHorizontal:(UIView *)view from:(UIView *)frontView to:(UIView *)nextView {
    
    BOOL needLine = self.whc_SegmentLineSize > 0.0;

    // 起点
    switch (self.flex.direction) {
        case BADirectionRow: {
            if (frontView) {
                frontView = needLine ? [self addSegmentLineTo:frontView]:frontView;
                CGFloat spacing = needLine ? self.horizontalSpacing/2 : self.horizontalSpacing;
                
                [view whc_LeftSpace:spacing+self.padding.left toView:frontView];
            } else {
                [view whc_LeftSpace:self.padding.left];
            }
            
        }
            break;
            
        case BADirectionRowReverse: {
            
            if (frontView) {
                frontView = needLine ? [self addSegmentLineTo:frontView]:frontView;
                CGFloat spacing = needLine ? self.horizontalSpacing/2 : self.horizontalSpacing;
                
                [view whc_RightSpace:spacing+self.padding.right toView:frontView];
            } else {
                [view whc_RightSpace:self.padding.right];
            }
        }
            break;
            
        default:
            // 不支持！！！
            break;
    }
    
    // 交叉轴排列
    switch (self.flex.align) {
        case BAAlignItemsStart: {
            // 向容器顶部固定
            [view whc_TopSpace:self.padding.top];
        }
            break;
            
        case BAAlignItemsEnd: {
            // 向容器底部固定
            [view whc_BottomSpace:self.padding.bottom];
        }
            break;
            
        default:
            @throw [NSException exceptionWithName:@"BAStackView" reason:@"当前 flex.align 类型不支持" userInfo:@{}];
            break;
    }
    
    // 后续（有nextView）、尾部（无nextView）
    if (self.arrangedSubviewWidth > 0) {
        [view whc_Width:self.arrangedSubviewWidth];
    } else {
        if (self.widthHeightRatio > 0) {
            [view whc_WidthHeightRatio:self.widthHeightRatio];
        } else {
            if (_autoWidth) {
                [view whc_AutoWidth];
            } else {
                if (nextView) {
                    [view whc_WidthEqualView:nextView
                                       ratio:view.whc_WidthWeight / nextView.whc_WidthWeight];
                } else {
                    [view whc_RightSpace:self.padding.right];
                }
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
            } else {
                
                switch (self.flex.align) {
                    case BAAlignItemsStart: {
                        [view whc_BottomSpace:self.padding.bottom];
                    }
                        break;
                        
                    case BAAlignItemsEnd: {
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

//- (void)

@end
