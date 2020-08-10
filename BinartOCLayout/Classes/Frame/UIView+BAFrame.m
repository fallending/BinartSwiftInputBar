
#import "UIView+BAFrame.h"

@implementation UIView ( BAFrame )

- (CGFloat)whc_sw {
    return CGRectGetWidth([UIScreen mainScreen].bounds);
}

- (CGFloat)whc_sh {
    return CGRectGetHeight([UIScreen mainScreen].bounds);
}

- (void)setWhc_w:(CGFloat)whc_w {
    CGRect rect = self.frame;
    rect.size.width = whc_w;
    self.frame = rect;
}

- (CGFloat)whc_w {
    return CGRectGetWidth(self.frame);
}

- (void)setWhc_h:(CGFloat)whc_h {
    CGRect rect = self.frame;
    rect.size.height = whc_h;
    self.frame = rect;
}

- (CGFloat)whc_h {
    return CGRectGetHeight(self.frame);
}

- (void)setWhc_x:(CGFloat)whc_x {
    CGRect rect = self.frame;
    rect.origin.x = whc_x;
    self.frame = rect;
}

- (CGFloat)whc_x {
    return CGRectGetMinX(self.frame);
}

- (void)setWhc_y:(CGFloat)whc_y {
    CGRect rect = self.frame;
    rect.origin.y = whc_y;
    self.frame = rect;
}

- (CGFloat)whc_y {
    return CGRectGetMinY(self.frame);
}

- (void)setWhc_maxX:(CGFloat)whc_maxX {
    self.whc_w = whc_maxX - self.whc_x;
}

- (CGFloat)whc_maxX {
    return CGRectGetMaxX(self.frame);
}

- (void)setWhc_maxY:(CGFloat)whc_maxY {
    self.whc_h = whc_maxY - self.whc_y;
}

- (CGFloat)whc_maxY {
    return CGRectGetMaxY(self.frame);
}

- (void)setWhc_midX:(CGFloat)whc_midX {
    self.whc_w = whc_midX * 2;
}

- (CGFloat)whc_midX {
    return CGRectGetMinX(self.frame) + CGRectGetWidth(self.frame) / 2;
}

- (void)setWhc_midY:(CGFloat)whc_midY {
    self.whc_h = whc_midY * 2;
}

- (CGFloat)whc_midY {
    return CGRectGetMinY(self.frame) + CGRectGetHeight(self.frame) / 2;
}

#if TARGET_OS_IPHONE || TARGET_OS_TV

- (void)setWhc_cx:(CGFloat)whc_cx {
    CGPoint center = self.center;
    center.x = whc_cx;
    self.center = center;
}

- (CGFloat)whc_cx {
    return self.center.x;
}

- (void)setWhc_cy:(CGFloat)whc_cy {
    CGPoint center = self.center;
    center.y = whc_cy;
    self.center = center;
}

- (CGFloat)whc_cy {
    return self.center.y;
}

#endif
- (void)setWhc_xy:(CGPoint)whc_xy {
    CGRect rect = self.frame;
    rect.origin = whc_xy;
    self.frame = rect;
}


- (CGPoint)whc_xy {
    return self.frame.origin;
}

- (void)setWhc_s:(CGSize)whc_s {
    CGRect rect = self.frame;
    rect.size = whc_s;
    self.frame = rect;
}

- (CGSize)whc_s {
    return self.frame.size;
}

@end
