
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

typedef enum : NSUInteger {
    BADirectionRow = 1 << 0,                /// 主轴为水平方向，起点在左端
    BADirectionRowReverse = 1 << 1,         /// 主轴为水平方向，起点在右端
    BADirectionColumn = 1 << 2,             /// 主轴为垂直方向，起点在上沿
    BADirectionColumnReverse = 1 << 3,      /// 主轴为垂直方向，起点在下沿
} BADirection;

typedef enum : NSUInteger {
    BAWrapNoWrap = 1 << 0,                  /// 不换行
    BAWrapWrap = 1 << 1,                    /// 换行，第一行在上方
    BAWrapWrapReverse = 1 << 2,             /// 换行，第一行在下方
} BAWrap;

typedef enum : NSUInteger {
    BAJustifyContentStart = 1 << 0,         /// 左对齐
    BAJustifyContentEnd = 1 << 1,           /// 右对齐
    BAJustifyContentCenter = 1 << 2,        /// 居中
    BAJustifyContentSpaceBetween = 1 << 3,  /// 两端对齐，项目之间的间隔都相等
    BAJustifyContentSpaceAround = 1 << 4,   /// 每个项目两侧的间隔相等。所以，项目之间的间隔比项目与边框的间隔大一倍
} BAJustifyContent;

typedef enum : NSUInteger {
    BAAlignItemsStart = 1 << 0,             /// 交叉轴的起点对齐
    BAAlignItemsEnd = 1 << 1,               /// 交叉轴的终点对齐
    BAAlignItemsCenter = 1 << 2,            /// 交叉轴的中点对齐
    BAAlignItemsBaseline = 1 << 3,          /// 项目的第一行文字的基线对齐（不支持）
    BAAlignItemsStretch = 1 << 4,           /// 如果项目未设置高度或设为auto，将占满整个容器的高度
} BAAlignItems;


// 内边距
typedef struct __attribute__((objc_boxable)) BAPadding {
    CGFloat top, left, bottom, right;
} BAPadding;

// 外边距
typedef struct __attribute__((objc_boxable)) BAMargin {
    CGFloat top, left, bottom, right;
} BAMargin;


typedef UIView *(^ BAVoidBlock)(void);
typedef UIView *(^ BAValueBlock)(CGFloat value);
typedef UIView *(^ BAValueAgainstBlock)(CGFloat value , NSObject *toView);
