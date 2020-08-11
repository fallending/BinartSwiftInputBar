
#import "UIView+BALayout.h"

typedef enum : NSUInteger {
    BALayoutAxisVertical = 1 << 0,      /// 垂直布局
    BALayoutAxisHorizontal = 1 << 1,    /// 横向布局
    BALayoutAxisAll = 1 << 2,           /// 垂直布局和横向布局
    
    BAStackViewAxisVertical = BALayoutAxisVertical,
    BAStackViewAxisHorizontal = BALayoutAxisHorizontal,
    BAStackViewAxisAll = BALayoutAxisAll,
} BAStackViewAxis;

typedef BAStackViewAxis BALayoutAxis;

typedef enum : NSUInteger {
    /* Align the leading and trailing edges of vertically stacked items
    or the top and bottom edges of horizontally stacked items tightly to the container.
    */
    BAStackViewAlignmentFill = 1 << 0,
    /* Align the leading edges of vertically stacked items
    or the top edges of horizontally stacked items tightly to the relevant edge
    of the container
    */
    BAStackViewAlignmentLeading = 1 << 1,
    /* Center the items in a vertical stack horizontally
    or the items in a horizontal stack vertically
    */
    BAStackViewAlignmentCenter = 1 << 2,      /// 从上面开始
    /* Align the trailing edges of vertically stacked items
    or the bottom edges of horizontally stacked items tightly to the relevant
    edge of the container
    */
    BAStackViewAlignmentTrailing = 1 << 3,   /// 从下面开始
} BAStackViewAlignment;

typedef enum : NSUInteger {
    BAStackViewDistributionFill = 1 << 0,
    BAStackViewDistributionFillEqually = 1 << 1,
    BAStackViewDistributionFillProportionally = 1 << 2,
    BAStackViewDistributionEqualSpacing = 1 << 3,
    BAStackViewDistributionEqualCentering = 1 << 4,
} BAStackViewDistribution;

// MARK: = UI自动布局StackView容器

@interface UIView ( BAStackView )
/**
 控件横向和垂直布局宽度或者高度权重比例
 */
@property (nonatomic , assign) CGFloat whc_WidthWeight;

@property (nonatomic , assign) CGFloat whc_HeightWeight;

@end

// MARK: =

@interface BAStackView : UIView

/// 混合布局(同时垂直和横向)每行多少列
@property (nonatomic , assign) NSInteger columns;

/// 容器内边距
@property (nonatomic , assign) UIEdgeInsets padding;

/// 容器内子控件横向间隙
@property (nonatomic , assign) CGFloat horizontalSpacing;
/// 容器内子控件垂直间隙
@property (nonatomic , assign) CGFloat verticalSpacing;

/// 子元素高宽比
@property (nonatomic , assign) CGFloat heightWidthRatio;

/// 子元素宽高比
@property (nonatomic , assign) CGFloat widthHeightRatio;

/* A stack with a horizontal axis is a row of arrangedSubviews,
and a stack with a vertical axis is a column of arrangedSubviews.
 */

/// 容器自动布局轴向, required
@property (nonatomic , assign) BALayoutAxis axis;

/* The layout of the arrangedSubviews along the axis
*/
@property (nonatomic, assign) BAStackViewDistribution distribution;

/* The layout of the arrangedSubviews transverse to the axis;
e.g., leading/trailing edges in a vertical stack
*/
/// 容器自动布局方向, required
@property (nonatomic , assign) BAStackViewAlignment alignment; // 新增

/// 子视图固定宽度
@property (nonatomic , assign) CGFloat arrangedSubviewWidth;

/// 子视图固定高度
@property (nonatomic , assign) CGFloat arrangedSubviewHeight;

/// 设置分割线尺寸
@property (nonatomic , assign) CGFloat whc_SegmentLineSize;
/// 设置分割线内边距
@property (nonatomic , assign) CGFloat whc_SegmentLinePadding;
/// 设置分割线的颜色
@property (nonatomic , strong) UIColor * whc_SegmentLineColor;

/************重载父类属性**************/
/////// 自动高度
//@property (nonatomic ,copy , readonly) HeightAuto whc_HeightAuto;
////
/////// 自动宽度
//@property (nonatomic ,copy , readonly) WidthAuto whc_WidthAuto;

/// 容器里子元素实际数量
@property (nonatomic , assign , readonly) NSInteger arrangedSubviewCount;

/// 元素集合
@property (nonatomic, strong, readonly)NSArray<UIView *> * arrangedSubViews;

/************重载父类方法**************/

// 自动宽度
- (void)whc_AutoWidth; // 基本是作用于子视图

// 自动高度
- (void)whc_AutoHeight; // 基本是作用于子视图

/// 根据子视图计算当前合理高度，依赖 arrangedSubviewWidth, arrangedSubviewHeight
- (void)autoHeight;

/// 根据子视图计算当前合理宽度，依赖 arrangedSubviewWidth, arrangedSubviewHeight
- (void)autoWidth;

// 开始进行自动布局
- (void)layoutMe;

// 清除所有子视图
- (void)removeAllArrangedSubviews;

@end

