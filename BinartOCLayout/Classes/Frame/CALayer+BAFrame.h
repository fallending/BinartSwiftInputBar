
#import "BALayoutUtil.h"

@interface CALayer (WHC_Frame)
/// 获取屏幕宽度
@property (nonatomic, assign, readonly)CGFloat whc_sw;
/// 获取屏幕高度
@property (nonatomic, assign, readonly)CGFloat whc_sh;
/// 获取视图层宽度
@property (nonatomic, assign)CGFloat whc_w;
/// 获取视图层高度
@property (nonatomic, assign)CGFloat whc_h;
/// 获取视图层x
@property (nonatomic, assign)CGFloat whc_x;
/// 获取视图层y
@property (nonatomic, assign)CGFloat whc_y;
/// 获取视图层最大x
@property (nonatomic, assign)CGFloat whc_maxX;
/// 获取视图层最大y
@property (nonatomic, assign)CGFloat whc_maxY;
/// 获取视图层中间x
@property (nonatomic, assign)CGFloat whc_midX;
/// 获取视图层中间y
@property (nonatomic, assign)CGFloat whc_midY;
/// 获取视图层中心锚点x
@property (nonatomic, assign)CGFloat whc_ax;
/// 获取视图层中心锚点y
@property (nonatomic, assign)CGFloat whc_ay;
/// 获取视图层xy
@property (nonatomic, assign)CGPoint whc_xy;
/// 获取视图层size
@property (nonatomic, assign)CGSize  whc_s;
@end
