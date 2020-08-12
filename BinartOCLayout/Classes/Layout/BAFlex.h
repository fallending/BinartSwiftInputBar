
#import "BALayoutUtil.h"

// http://www.ruanyifeng.com/blog/2015/07/flex-grammar.html
// also see <UIKit/Geometry.h>

// 容器默认存在两根轴：水平的主轴（main axis）和垂直的交叉轴（cross axis）。主轴的开始位置（与边框的交叉点）叫做main start，结束位置叫做main end；交叉轴的开始位置叫做cross start，结束位置叫做cross end。

// 项目默认沿主轴排列。单个项目占据的主轴空间叫做main size，占据的交叉轴空间叫做cross size。

NS_ASSUME_NONNULL_BEGIN

typedef struct BAFlex {
    BADirection direction;
    BAWrap wrap; // 当前配合 columns 来实现分行、分列，没有遵守 flex 规则
    BAJustifyContent justify;
    BAAlignItems align;
} BAFlex;

// MARK: = Flex 布局引擎

@interface BAFlexEngine: NSObject

// 布局算法（未实现）

@end

NS_ASSUME_NONNULL_END
