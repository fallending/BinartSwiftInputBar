
#import "BALayoutUtil.h"

@interface UIView (BAFrame)

/// 获取屏幕宽度
@property (nonatomic, assign, readonly)CGFloat whc_sw;
/// 获取屏幕高度
@property (nonatomic, assign, readonly)CGFloat whc_sh;
/// 获取视图宽度
@property (nonatomic, assign)CGFloat whc_w;
/// 获取视图高度
@property (nonatomic, assign)CGFloat whc_h;
/// 获取视图x
@property (nonatomic, assign)CGFloat whc_x;
/// 获取视图y
@property (nonatomic, assign)CGFloat whc_y;
/// 获取视图最大x
@property (nonatomic, assign)CGFloat whc_maxX;
/// 获取视图最大y
@property (nonatomic, assign)CGFloat whc_maxY;
/// 获取视图中间x
@property (nonatomic, assign)CGFloat whc_midX;
/// 获取视图中间y
@property (nonatomic, assign)CGFloat whc_midY;
#if TARGET_OS_IPHONE || TARGET_OS_TV
/// 获取视图中心x
@property (nonatomic, assign)CGFloat whc_cx;
/// 获取视图中心y
@property (nonatomic, assign)CGFloat whc_cy;
#endif
/// 获取视图xy
@property (nonatomic, assign)CGPoint whc_xy;
/// 获取视图size
@property (nonatomic, assign)CGSize  whc_s;

@end
