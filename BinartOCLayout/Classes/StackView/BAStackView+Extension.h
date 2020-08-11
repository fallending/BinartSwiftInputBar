//
//  BAStackView+Extension.h
//  BinartOCLayout
//
//  Created by Seven on 2020/8/11.
//

#import "BAStackView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BAStackView (Extension)

- (UIView *)addSegmentLineTo:(UIView *)view;

//
- (void)appendVertical:(UIView *)view;
- (void)appendVertical:(UIView *)view next:(UIView *)toView;

/**
 @param view 当前视图
 @param frontView 在 view 之前，当 view 是第一个视图，frontView需要为空，因为第一个不需要处理 line等
 @param nextView 在 view 之后
 */
- (void)appendVertical:(UIView *)view from:(UIView *)frontView to:(UIView *)nextView;

@end

NS_ASSUME_NONNULL_END
