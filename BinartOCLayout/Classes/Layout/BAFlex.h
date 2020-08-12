
#import "BALayoutUtil.h"

// flex 概念：http://www.ruanyifeng.com/blog/2015/07/flex-grammar.html
// flex 详细：https://juejin.im/post/6844903474774147086
// also see <UIKit/Geometry.h>

NS_ASSUME_NONNULL_BEGIN

typedef struct BAFlex {
    // MARK: = 轴向、排向
    /**
     容器默认存在两根轴
     1. 水平的主轴（main axis）和垂直的交叉轴（cross axis）
     1.1 主轴的开始位置（与边框的交叉点）叫做main start，结束位置叫做main end
     1.2 交叉轴的开始位置叫做cross start，结束位置叫做cross end
     2. 项目默认沿主轴排列
     2.1 单个项目占据的主轴空间叫做main size，占据的交叉轴空间叫做cross size
     */
    BADirection direction;
    
    // MARK: = main 分布
    
    /**
     
     */
    BAJustifyContent justify;
    
    // MARK: = cross 分布
    
    /**
     
     */
    BAAlignItems align;
    
    // MARK: = 换行
    /**
     nowrap:
     
     1. 主轴方向，所有项目均分
     2. 交叉轴方向，stretch拉伸
     2.1 如果指定高度，则按高度优先
     2.2 如果指定高宽比，则按高宽比优先
     
     wrap:
     
     1. 主轴依赖，交叉轴辅助信息，来决定何时换行
     1.1 指定交叉轴方向的条目数
     1.2 指定项目宽度
     2. 交叉轴均分项目高度
     2.1 如果指定高度，则按高度优先，如果最终高度超出，则按超出
     2.2 如果指定高宽比，则按高宽比优先
     
     wrapreverse:
     
     类似 wrap
     
     */
    BAWrap wrap; // 当前配合 columns 来实现分行、分列，没有遵守 flex 规则
} BAFlex;

// MARK: = Flex 布局引擎

@interface BAFlexEngine: NSObject

// 布局算法（未实现）

@end

NS_ASSUME_NONNULL_END
