
#import "BALayoutUtil.h"

typedef UIView * (^IsSafe)(BOOL);

typedef UIView * (^LessOrEqual)(void);
typedef UIView * (^GreaterOrEqual)(void);
typedef UIView * (^ResetConstraintAttribute)(void);
typedef UIView * (^ClearConstraintAttribute)(void);
typedef UIView * (^RemoveConstraintAttribute)(NSLayoutAttribute attributes, ...);
typedef UIView * (^RemoveConstraintFromViewAttribute)(UIView * view, NSLayoutAttribute attributes, ...);
typedef UIView * (^RemoveConstraintToViewAttribute)(NSObject * toView, NSLayoutAttribute attributes, ...);

typedef UIView * (^PriorityLow)(void);
typedef UIView * (^PriorityHigh)(void);
typedef UIView * (^PriorityRequired)(void);
typedef UIView * (^PriorityFitting)(void);
typedef UIView * (^PriorityValue)(CGFloat value);

typedef UIView * (^ContentHuggingPriority)(UILayoutPriority, UILayoutConstraintAxis);
typedef UIView * (^ContentCompressionResistancePriority)(UILayoutPriority, UILayoutConstraintAxis);

typedef UIView * (^LeftSpace)(CGFloat value);
typedef UIView * (^LeftSpaceToView)(CGFloat value , NSObject * toView);
typedef UIView * (^LeftSpaceEqualView)(NSObject * view);
typedef UIView * (^LeftSpaceEqualViewOffset)(NSObject * view, CGFloat offset);

typedef UIView * (^LeadingSpace)(CGFloat value);
typedef UIView * (^LeadingSpaceToView)(CGFloat value , NSObject * toView);
typedef UIView * (^LeadingSpaceEqualView)(NSObject * view);
typedef UIView * (^LeadingSpaceEqualViewOffset)(NSObject * view, CGFloat offset);

typedef UIView * (^TrailingSpace)(CGFloat value);
typedef UIView * (^TrailingSpaceToView)(CGFloat value , NSObject * toView);
typedef UIView * (^TrailingSpaceEqualView)(NSObject * view);
typedef UIView * (^TrailingSpaceEqualViewOffset)(NSObject * view, CGFloat offset);

typedef UIView * (^BaseLineSpace)(CGFloat value);
typedef UIView * (^BaseLineSpaceToView)(CGFloat value , NSObject * toView);
typedef UIView * (^BaseLineSpaceEqualView)(NSObject * view);
typedef UIView * (^BaseLineSpaceEqualViewOffset)(NSObject * view, CGFloat offset);

typedef UIView * (^RightSpace)(CGFloat value);
typedef UIView * (^RightSpaceToView)(CGFloat value , NSObject * toView);
typedef UIView * (^RightSpaceEqualView)(NSObject * view);
typedef UIView * (^RightSpaceEqualViewOffset)(NSObject * view, CGFloat offset);

typedef UIView * (^TopSpace)(CGFloat value);
typedef UIView * (^TopSpaceToView)(CGFloat value , NSObject * toView);
typedef UIView * (^TopSpaceEqualView)(NSObject * view);
typedef UIView * (^TopSpaceEqualViewOffset)(NSObject * view, CGFloat offset);

typedef UIView * (^BottomSpace)(CGFloat value);
typedef UIView * (^BottomSpaceToView)(CGFloat value , NSObject * toView);
typedef UIView * (^BottomSpaceEqualView)(NSObject * view);
typedef UIView * (^BottomSpaceEqualViewOffset)(NSObject * view, CGFloat offset);

typedef UIView * (^Width)(CGFloat value);
typedef UIView * (^WidthAuto)(void);
typedef UIView * (^WidthEqualView)(NSObject * view);
typedef UIView * (^WidthEqualViewRatio)(NSObject * view, CGFloat ratio);
typedef UIView * (^WidthHeightRatio)(CGFloat ratio);

typedef UIView * (^Height)(CGFloat value);
typedef UIView * (^HeightAuto)(void);
typedef UIView * (^HeightEqualView)(NSObject * view);
typedef UIView * (^HeightEqualViewRatio)(NSObject * view, CGFloat ratio);
typedef UIView * (^HeightWidthRatio)(CGFloat ratio);

typedef UIView * (^CenterX)(CGFloat value);
typedef UIView * (^CenterXToView)(CGFloat value, NSObject * toView);

typedef UIView * (^CenterY)(CGFloat value);
typedef UIView * (^CenterYToView)(CGFloat value, NSObject * toView);

typedef UIView * (^Center)(CGFloat x, CGFloat y);
typedef UIView * (^CenterToView)(CGPoint center, NSObject * toView);

typedef UIView * (^size)(CGFloat width, CGFloat height);
typedef UIView * (^SizeEqual)(NSObject * view);

typedef UIView * (^FrameEqual)(NSObject * view);

#pragma mark - UI自动布局 -

@interface UIView (BAAutoLayout)

#pragma mark - api version ~ 2.0 -

/// 是否安全布局
@property (nonatomic ,copy , readonly)IsSafe whc_IsSafe;

/// 当前约束小于等于
@property (nonatomic ,copy , readonly)LessOrEqual whc_LessOrEqual;
/// 当前约束大于等于
@property (nonatomic ,copy , readonly)GreaterOrEqual whc_GreaterOrEqual;
/// 重置缓存约束
@property (nonatomic ,copy , readonly)ResetConstraintAttribute whc_ResetConstraint;
/// 清除所有约束
@property (nonatomic ,copy , readonly)ClearConstraintAttribute whc_ClearLayoutAttr;
/// 移除约束(NSLayoutAttribute attributes, ...)
@property (nonatomic ,copy , readonly)RemoveConstraintAttribute whc_RemoveLayoutAttrs;
/// 移除约束从指定视图上(NSObject * view, NSLayoutAttribute attributes, ...)
@property (nonatomic ,copy , readonly)RemoveConstraintFromViewAttribute whc_RemoveFromLayoutAttrs;
/// 移除约束从关联视图上(NSObject * toView, NSLayoutAttribute attributes, ...)
@property (nonatomic ,copy , readonly)RemoveConstraintToViewAttribute whc_RemoveToLayoutAttrs;

/// 设置当前约束的低优先级
@property (nonatomic ,copy , readonly)PriorityLow whc_PriorityLow;
/// 设置当前约束的高优先级
@property (nonatomic ,copy , readonly)PriorityHigh whc_PriorityHigh;
/// 设置当前约束的默认优先级
@property (nonatomic ,copy , readonly)PriorityRequired whc_PriorityRequired;
/// 设置当前约束的合适优先级
@property (nonatomic ,copy , readonly)PriorityFitting whc_PriorityFitting;
/// 设置当前约束的优先级 (CGFloat value): 优先级大小(0-1000)
@property (nonatomic ,copy , readonly)PriorityValue whc_Priority;

/// 设置视图抗拉伸优先级,优先级越高越不容易被拉伸(UILayoutPriority, UILayoutConstraintAxis)
@property (nonatomic ,copy, readonly)ContentHuggingPriority whc_ContentHuggingPriority;
/// 设置视图抗压缩优先级,优先级越高越不容易被压缩(UILayoutPriority, UILayoutConstraintAxis)
@property (nonatomic ,copy, readonly)ContentCompressionResistancePriority whc_ContentCompressionResistancePriority;

/// 与父视图左边间距(CGFloat value)
@property (nonatomic ,copy , readonly)LeftSpace whc_LeftSpace;
/// 与相对视图toView左边间距(CGFloat value,NSObject * toView)
@property (nonatomic ,copy , readonly)LeftSpaceToView whc_LeftSpaceToView;
/// 与视图view左边间距相等(NSObject * view)
@property (nonatomic ,copy , readonly)LeftSpaceEqualView whc_LeftSpaceEqualView;
/// 与视图view左边间距相等并偏移offset(NSObject * view, CGFloat offset)
@property (nonatomic ,copy , readonly)LeftSpaceEqualViewOffset whc_LeftSpaceEqualViewOffset;

/// 与父视图左边间距(CGFloat value)
@property (nonatomic ,copy , readonly)LeadingSpace whc_LeadingSpace;
/// 与相对视图toView左边间距(CGFloat value,NSObject * toView)
@property (nonatomic ,copy , readonly)LeadingSpaceToView whc_LeadingSpaceToView;
/// 与视图view左边间距相等(NSObject * view)
@property (nonatomic ,copy , readonly)LeadingSpaceEqualView whc_LeadingSpaceEqualView;
/// 与视图view左边间距相等并偏移offset (NSObject * view, CGFloat offset)
@property (nonatomic ,copy , readonly)LeadingSpaceEqualViewOffset whc_LeadingSpaceEqualViewOffset;

/// 与父视图右边间距(CGFloat value)
@property (nonatomic ,copy , readonly)TrailingSpace whc_TrailingSpace;
/// 与相对视图toView右边间距(CGFloat value,NSObject * toView)
@property (nonatomic ,copy , readonly)TrailingSpaceToView whc_TrailingSpaceToView;
/// 与视图view右边间距相等(NSObject * view)
@property (nonatomic ,copy , readonly)TrailingSpaceEqualView whc_TrailingSpaceEqualView;
/// 与视图view右边间距相等并偏移offset(NSObject * view, CGFloat offset)
@property (nonatomic ,copy , readonly)TrailingSpaceEqualViewOffset whc_TrailingSpaceEqualViewOffset;

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
/// 与父视图底边间距Y(CGFloat value)
@property (nonatomic ,copy , readonly)BaseLineSpace whc_FirstBaseLine;
/// 与相对视图toView底边间距Y(CGFloat value,NSObject * toView)
@property (nonatomic ,copy , readonly)BaseLineSpaceToView whc_FirstBaseLineToView;
/// 与视图view底边间距Y相等(NSObject * view)
@property (nonatomic ,copy , readonly)BaseLineSpaceEqualView whc_FirstBaseLineEqualView;
/// 与视图view底边间距Y相等并偏移offset(NSObject * view, CGFloat offset)
@property (nonatomic ,copy , readonly)BaseLineSpaceEqualViewOffset whc_FirstBaseLineEqualViewOffset;
#endif

/// 与父视图底边间距Y(CGFloat value)
@property (nonatomic ,copy , readonly)BaseLineSpace whc_LastBaseLine;
/// 与相对视图toView底边间距Y(CGFloat value,NSObject * toView)
@property (nonatomic ,copy , readonly)BaseLineSpaceToView whc_LastBaseLineToView;
/// 与视图view底边间距Y相等(NSObject * view)
@property (nonatomic ,copy , readonly)BaseLineSpaceEqualView whc_LastBaseLineEqualView;
/// 与视图view底边间距Y相等并偏移offset(NSObject * view, CGFloat offset)
@property (nonatomic ,copy , readonly)BaseLineSpaceEqualViewOffset whc_LastBaseLineEqualViewOffset;
/// 与父视图右边间距(CGFloat value)
@property (nonatomic ,copy , readonly)RightSpace whc_RightSpace;
/// 与相对视图toView右边间距(CGFloat value,NSObject * toView)
@property (nonatomic ,copy , readonly)RightSpaceToView whc_RightSpaceToView;
/// 与相对视图toView右边间距相等(NSObject toView)
@property (nonatomic ,copy , readonly)RightSpaceEqualView whc_RightSpaceEqualView;
/// 与相对视图toView右边间距相等并偏移offset(NSObject toView, CGFloat offset)
@property (nonatomic ,copy , readonly)RightSpaceEqualViewOffset whc_RightSpaceEqualViewOffset;

/// 与父视图顶边间距(CGFloat value)
@property (nonatomic ,copy , readonly)TopSpace whc_TopSpace;
/// 与相对视图toView顶边间距(CGFloat value,NSObject * toView)
@property (nonatomic ,copy , readonly)TopSpaceToView whc_TopSpaceToView;
/// 与视图view顶边间距相等(NSObject * view)
@property (nonatomic ,copy , readonly)TopSpaceEqualView whc_TopSpaceEqualView;
/// 与视图view顶边间距相等并偏移offset(NSObject * view, CGFloat offset)
@property (nonatomic ,copy , readonly)TopSpaceEqualViewOffset whc_TopSpaceEqualViewOffset;

/// 与父视图底边间距(CGFloat value)
@property (nonatomic ,copy , readonly)BottomSpace whc_BottomSpace;
/// 与相对视图toView底边间距(CGFloat value,NSObject * toView)
@property (nonatomic ,copy , readonly)BottomSpaceToView whc_BottomSpaceToView;
/// 与相对视图toView底边间距相等(NSObject * toView)
@property (nonatomic ,copy , readonly)BottomSpaceEqualView whc_BottomSpaceEqualView;
/// 与相对视图toView底边间距相等并偏移offset(NSObject * toView, CGFloat offset)
@property (nonatomic ,copy , readonly)BottomSpaceEqualViewOffset whc_BottomSpaceEqualViewOffset;

/// 宽度(CGFloat value)
@property (nonatomic ,copy , readonly)Width whc_Width;
/// 宽度自动()
@property (nonatomic ,copy , readonly)WidthAuto whc_WidthAuto;
/// 宽度等于视图view(NSObject * view)
@property (nonatomic ,copy , readonly)WidthEqualView whc_WidthEqualView;
/// 宽度等于视图view 参照比例Ratio(NSObject * view ,CGFloat ratio)
@property (nonatomic ,copy , readonly)WidthEqualViewRatio whc_WidthEqualViewRatio;
/// 视图自身宽度与高度的比(CGFloat Ratio)
@property (nonatomic ,copy , readonly)WidthHeightRatio whc_WidthHeightRatio;

/// 高度(CGFloat value)
@property (nonatomic ,copy , readonly)Height whc_Height;
/// 高度自动()
@property (nonatomic ,copy , readonly)HeightAuto whc_HeightAuto;
/// 高度等于视图view(NSObject * view)
@property (nonatomic ,copy , readonly)HeightEqualView whc_HeightEqualView;
/// 高度等于视图view 参照比例Ratio(NSObject * view ,CGFloat ratio)
@property (nonatomic ,copy , readonly)HeightEqualViewRatio whc_HeightEqualViewRatio;
/// 视图自身高度与宽度的比(CGFloat Ratio)
@property (nonatomic ,copy , readonly)HeightWidthRatio whc_HeightWidthRatio;

/// 中心X与父视图偏移(CGFloat value)
@property (nonatomic ,copy , readonly)CenterX whc_CenterX;
/// 中心X与视图view偏移(CGFloat value , NSObject * toView)
@property (nonatomic ,copy , readonly)CenterXToView whc_CenterXToView;

/// 中心Y与父视图偏移(CGFloat value)
@property (nonatomic ,copy , readonly)CenterY whc_CenterY;
/// 中心Y与视图view偏移(CGFloat value , NSObject * toView)
@property (nonatomic ,copy , readonly)CenterYToView whc_CenterYToView;

/// 中心与父视图偏移(CGFloat value)
@property (nonatomic ,copy , readonly)Center whc_Center;
/// 中心与视图view偏移(CGFloat value , NSObject * toView)
@property (nonatomic ,copy , readonly)CenterToView whc_CenterToView;

/// size设置(CGFloat width, CGFloat height)
@property (nonatomic ,copy , readonly)size whc_Size;
/// size设置(NSObject * view)
@property (nonatomic ,copy , readonly)SizeEqual whc_SizeEqualView;

/// frame设置(NSObject * view)
@property (nonatomic ,copy , readonly)FrameEqual whc_FrameEqualView;
#pragma mark - api version ~ 1.0 -


/**
 是否进行安全布局

 @param safe 是否安全
 @return 返回当前视图
 */
- (UIView *)whc_IsSafe:(BOOL)safe;


/**
 重置缓存的约束,该方法在当前视图对象移除从父视图上可能需要调用清除与父视图之前旧约束缓存对象
 
 @return 返回当前视图
 */
- (UIView *)whc_ResetConstraints;

/**
 清除所有布局属性
 
 @return 返回当前视图
 */
- (UIView *)whc_ClearLayoutAttrs;

/**
 移除一个或者一组约束
 
 @param attributes 约束类型（可变参数）
 @return 返回当前视图
 */
- (UIView *)whc_RemoveLayoutAttr:(NSLayoutAttribute)attributes, ...;


/**
 移除一个单个属性

 @param attribute 约束类型
 @return 返回当前视图
 */
- (UIView *)whc_RemoveLayoutOneAttr:(NSLayoutAttribute)attribute;

/**
 移除一个或者一组约束从指定的视图上

 @param view 指定视图
 @param attributes 约束类型（可变参数）
 @return 返回当前视图
 */
- (UIView *)whc_RemoveFrom:(UIView *)view layoutAttrs:(NSLayoutAttribute)attributes, ...;


/**
 移除一个约束从指定的视图上

 @param view 指定视图
 @param attribute 约束类型
 @return 返回当前视图
 */
- (UIView *)whc_RemoveFrom:(UIView *)view layoutAttr:(NSLayoutAttribute)attribute;


/**
 移除一个约束从关联的视图

 @param view 关联的视图
 @param attribute 移除的约束
 @return 当前视图
 */
- (UIView *)whc_RemoveTo:(NSObject *)view attr:(NSLayoutAttribute)attribute;

/**
 移除多个约束从关联的视图
 
 @param view 关联的视图
 @param attributes 移除的约束
 @return 当前视图
 */

- (UIView *)whc_RemoveTo:(NSObject *)view layoutAttrs:(NSLayoutAttribute)attributes, ... ;

/**
 设置当前约束的低优先级

 @return 返回当前视图
 */
- (UIView *)whc_priorityLow;

/**
 设置当前约束的高优先级

 @return 返回当前视图
 */
- (UIView *)whc_priorityHigh;

/**
 设置当前约束的默认优先级

 @return 返回当前视图
 */
- (UIView *)whc_priorityRequired;

/**
 设置当前约束的合适优先级

 @return 返回当前视图
 */
- (UIView *)whc_priorityFitting;

/**
 设置当前约束的优先级

 @param value 优先级大小(0-1000)
 @return 返回当前视图
 */
- (UIView *)whc_priority:(CGFloat)value;

/**
 设置左边距(默认相对父视图)

 @param leftSpace 左边距
 @return 返回当前视图
 */
- (UIView *)whc_LeftSpace:(CGFloat)leftSpace;


/**
 设置左边距

 @param leftSpace 左边距
 @param toView 相对视图
 @return 返回当前视图
 */
- (UIView *)whc_LeftSpace:(CGFloat)leftSpace toView:(NSObject *)toView;

/**
 设置左边距与视图view左边距相等

 @param view 相对视图
 @return 返回当前视图
 */
- (UIView *)whc_LeftSpaceEqualView:(NSObject *)view;

/**
 设置左边距与视图view左边距相等并偏移offset

 @param view 相对视图
 @param offset 偏移量
 @return 返回当前视图
 */
- (UIView *)whc_LeftSpaceEqualView:(NSObject *)view offset:(CGFloat)offset;

/**
 设置右边距(默认相对父视图)

 @param rightSpace 右边距
 @return 返回当前视图
 */
- (UIView *)whc_RightSpace:(CGFloat)rightSpace;

/**
 设置右边距

 @param rightSpace 右边距
 @param toView 相对视图
 @return 返回当前视图
 */
- (UIView *)whc_RightSpace:(CGFloat)rightSpace toView:(NSObject *)toView;

/**
 设置右边距与视图view左对齐边距相等

 @param view 相对视图
 @return 返回当前视图
 */
- (UIView *)whc_RightSpaceEqualView:(NSObject *)view;

/**
 设置右边距与视图view左对齐边距相等并偏移offset

 @param view 相对视图
 @param offset 偏移量
 @return 返回当前视图
 */
- (UIView *)whc_RightSpaceEqualView:(NSObject *)view offset:(CGFloat)offset;

/**
 设置左对齐(默认相对父视图)

 @param leadingSpace 左边距
 @return 返回当前视图
 */
- (UIView *)whc_LeadingSpace:(CGFloat)leadingSpace;

/**
 设置左对齐
 
 @param leadingSpace 左边距
 @param toView 相对视图
 @return 返回当前视图
 */

- (UIView *)whc_LeadingSpace:(CGFloat)leadingSpace toView:(NSObject *)toView;

/**
 设置左对齐边距与某视图左对齐边距相等

 @param view 相对视图
 @return 返回当前视图
 */
- (UIView *)whc_LeadingSpaceEqualView:(NSObject *)view;

/**
 设置左对齐边距与某视图左对齐边距相等并偏移offset

 @param view 相对视图
 @param offset 偏移量
 @return 返回当前视图
 */
- (UIView *)whc_LeadingSpaceEqualView:(NSObject *)view offset:(CGFloat)offset;

/**
 设置右对齐(默认相对父视图)

 @param trailingSpace 右边距
 @return 返回当前视图
 */
- (UIView *)whc_TrailingSpace:(CGFloat)trailingSpace;

/**
 设置右对齐

 @param trailingSpace 右边距
 @param toView 相对视图
 @return 返回当前视图
 */
- (UIView *)whc_TrailingSpace:(CGFloat)trailingSpace toView:(NSObject *)toView;

/**
 设置右对齐边距与某视图右对齐边距相等

 @param view 相对视图
 @return 返回当前视图
 */
- (UIView *)whc_TrailingSpaceEqualView:(NSObject *)view;

/**
 设置右对齐边距与某视图右对齐边距相等并偏移offset

 @param view 相对视图
 @param offset 偏移量
 @return 返回当前视图
 */
- (UIView *)whc_TrailingSpaceEqualView:(NSObject *)view offset:(CGFloat)offset;

/**
 设置顶边距(默认相对父视图)

 @param topSpace 顶边距
 @return 返回当前视图
 */
- (UIView *)whc_TopSpace:(CGFloat)topSpace;

/**
 设置顶边距

 @param topSpace 顶边距
 @param toView 相对视图
 @return 返回当前视图
 */
- (UIView *)whc_TopSpace:(CGFloat)topSpace toView:(NSObject *)toView;

/**
 设置顶边距与视图view顶边距相等

 @param view 相对视图
 @return 返回当前视图
 */
- (UIView *)whc_TopSpaceEqualView:(NSObject *)view;

/**
 设置顶边距与视图view顶边距相等并偏移offset

 @param view 相对视图
 @param offset 偏移量
 @return 返回当前视图
 */
- (UIView *)whc_TopSpaceEqualView:(NSObject *)view offset:(CGFloat)offset;

/**
 设置底边距(默认相对父视图)

 @param bottomSpace 底边距
 @return 返回当前视图
 */
- (UIView *)whc_BottomSpace:(CGFloat)bottomSpace;

/**
 设置底边距

 @param bottomSpace 底边距
 @param toView 相对视图
 @return 返回当前视图
 */
- (UIView *)whc_BottomSpace:(CGFloat)bottomSpace toView:(NSObject *)toView;

/**
 设置底边距与视图view底边距相等

 @param view 相对视图
 @return 返回当前视图
 */
- (UIView *)whc_BottomSpaceEqualView:(NSObject *)view;

/**
 设置底边距与视图view底边距相等并偏移offset

 @param view 相对视图
 @param offset 偏移量
 @return 返回当前视图
 */
- (UIView *)whc_BottomSpaceEqualView:(NSObject *)view offset:(CGFloat)offset;

/**
 设置宽度

 @param width 宽度
 @return 返回当前视图
 */
- (UIView *)whc_Width:(CGFloat)width;

/**
 设置宽度与某个视图相等

 @param view 相对视图
 @return 返回当前视图
 */
- (UIView *)whc_WidthEqualView:(NSObject *)view;

/**
 设置宽度与视图view相等

 @param view 相对视图
 @param ratio 比例
 @return 返回当前视图
 */
- (UIView *)whc_WidthEqualView:(NSObject *)view ratio:(CGFloat)ratio;

/**
 设置自动宽度

 @return 返回当前视图
 */
- (UIView *)whc_AutoWidth;

/**
 设置视图自身宽度与高度的比

 @param ratio 比例
 @return 返回当前视图
 */
- (UIView *)whc_WidthHeightRatio:(CGFloat)ratio;

/**
 设置高度

 @param height 高度
 @return 返回当前视图
 */
- (UIView *)whc_Height:(CGFloat)height;

/**
 设置高度与视图view相等

 @param view 相对视图
 @return 返回当前视图
 */
- (UIView *)whc_HeightEqualView:(NSObject *)view;

/**
 设置高度与视图view相等

 @param view 相对视图
 @param ratio 比例
 @return 返回当前视图
 */
- (UIView *)whc_HeightEqualView:(NSObject *)view ratio:(CGFloat)ratio;

/**
 设置自动高度

 @return 返回当前视图
 */
- (UIView *)whc_AutoHeight;

/**
 设置视图自身高度与宽度的比

 @param ratio 比例
 @return 返回当前视图
 */
- (UIView *)whc_HeightWidthRatio:(CGFloat)ratio;

/**
 设置中心x与父视图中心的偏移 centerX = 0 与父视图中心x重合

 @param centerX 中心x坐标偏移
 @return 返回当前视图
 */
- (UIView *)whc_CenterX:(CGFloat)centerX;

/**
 设置中心x与相对视图中心的偏移 centerX = 0 与相对视图中心x重合

 @param centerX 中心x坐标偏移
 @param toView 相对视图
 @return 返回当前视图
 */
- (UIView *)whc_CenterX:(CGFloat)centerX toView:(NSObject *)toView;

/**
 设置中心y与父视图中心的偏移 centerY = 0 与父视图中心y重合

 @param centerY 中心y坐标偏移
 @return 返回当前视图
 */
- (UIView *)whc_CenterY:(CGFloat)centerY;

/**
 设置中心y与相对视图中心的偏移 centerY = 0 与相对视图中心y重合

 @param centerY 中心y坐标偏移
 @param toView 相对视图
 @return 返回当前视图
 */
- (UIView *)whc_CenterY:(CGFloat)centerY toView:(NSObject *)toView;

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
/**
 设置顶部基线偏移(默认相对父视图)

 @param space 间隙
 @return 返回当前视图
 */
- (UIView *)whc_FirstBaseLine:(CGFloat)space;

/**
 设置顶部基线与对象视图底部基线偏移

 @param space 间隙
 @param toView 相对视图
 @return 返回当前视图
 */
- (UIView *)whc_FirstBaseLine:(CGFloat)space toView:(NSObject *)toView;

/**
 设置顶部基线与相对视图顶部基线相等

 @param view 相对视图
 @return 返回当前视图
 */
- (UIView *)whc_FirstBaseLineEqualView:(NSObject *)view;

/**
 设置顶部基线与相对视图顶部基线相等并偏移offset

 @param view 相对视图
 @param offset 偏移量
 @return 返回当前视图
 */
- (UIView *)whc_FirstBaseLineEqualView:(NSObject *)view offset:(CGFloat)offset;

#endif

/**
 设置底部基线偏移(默认相对父视图)

 @param space 间隙
 @return 返回当前视图
 */
- (UIView *)whc_LastBaseLine:(CGFloat)space;

/**
 设置底部基线与对象视图顶部基线偏移

 @param space 间隙
 @param toView 相对视图
 @return 返回当前视图
 */
- (UIView *)whc_LastBaseLine:(CGFloat)space toView:(NSObject *)toView;

/**
 设置底部基线与相对视图底部基线相等

 @param view 相对视图
 @return 返回当前视图
 */
- (UIView *)whc_LastBaseLineEqualView:(NSObject *)view;

/**
 设置底部基线与相对视图底部基线相等并偏移offset

 @param view 相对视图
 @param offset 偏移量
 @return 返回当前视图
 */
- (UIView *)whc_LastBaseLineEqualView:(NSObject *)view offset:(CGFloat)offset;


/**
 设置中心偏移(默认相对父视图)center = CGPointZero 与父视图中心重合

 @param center 中心偏移xy
 @return 返回当前视图
 */
- (UIView *)whc_Center:(CGPoint)center;

/**
 设置中心偏移(默认相对父视图)center = CGPointZero 与父视图中心重合

 @param center 中心偏移xy
 @param toView 相对视图
 @return 返回当前视图
 */
- (UIView *)whc_Center:(CGPoint)center toView:(NSObject *)toView;


/**
 设置frame(默认相对父视图)

 @param left 左边距
 @param top 顶边距
 @param width 宽度
 @param height 高度
 @return 返回当前视图
 */
- (UIView *)whc_Frame:(CGFloat)left top:(CGFloat)top width:(CGFloat)width height:(CGFloat)height;

/**
 设置frame (默认相对父视图)
 
 @param left 左边距
 @param top 顶边距
 @param right 右边距
 @param bottom 底边距
 @return 返回当前视图
 */

- (UIView *)whc_AutoSize:(CGFloat)left top:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom;

/**
 设置frame
 
 @param left 左边距
 @param top 顶边距
 @param width 宽度
 @param height 高度
 @param toView 相对视图
 @return 返回当前视图
 */

- (UIView *)whc_Frame:(CGFloat)left top:(CGFloat)top width:(CGFloat)width height:(CGFloat)height toView:(NSObject *)toView;

/**
 设置frame (默认相对父视图)
 
 @param left 左边距
 @param top 顶边距
 @param right 右边距
 @param height 高度
 @return 返回当前视图
 */

- (UIView *)whc_AutoWidth:(CGFloat)left top:(CGFloat)top right:(CGFloat)right height:(CGFloat)height;

/**
 设置frame (默认相对父视图)
 
 @param left 左边距
 @param top 顶边距
 @param width 宽度
 @param bottom 底边距
 @return 返回当前视图
 */

- (UIView *)whc_AutoHeight:(CGFloat)left top:(CGFloat)top width:(CGFloat)width bottom:(CGFloat)bottom;

/**
 设置frame
 
 @param left 左边距
 @param top 顶边距
 @param right 右边距
 @param bottom 底边距
 @param toView 相对视图
 @return 返回当前视图
 */

- (UIView *)whc_AutoSize:(CGFloat)left top:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom toView:(NSObject *)toView;

/**
 设置frame
 
 @param left 左边距
 @param top 顶边距
 @param right 右边距
 @param height 高度
 @param toView 相对视图
 @return 返回当前视图
 */

- (UIView *)whc_AutoWidth:(CGFloat)left top:(CGFloat)top right:(CGFloat)right height:(CGFloat)height toView:(NSObject *)toView;

/**
 设置frame (默认相对父视图)
 
 @param left 左边距
 @param top 顶边距
 @param width 宽度
 @param bottom 底边距
 @return 返回当前视图
 */

- (UIView *)whc_AutoHeight:(CGFloat)left top:(CGFloat)top width:(CGFloat)width bottom:(CGFloat)bottom toView:(UIView *)toView;

/**
 设置视图显示宽高
 
 @param size 视图宽高
 @return 返回当前视图
 */

- (UIView *)whc_Size:(CGSize)size;

/**
 设置视图size等于view
 
 @param view 相对视图
 @return 返回当前视图
 */
- (UIView *)whc_SizeEqualView:(UIView *)view;

/**
 设置视图frame等于view
 @param view 相对视图
 @return 返回当前视图
 */
- (UIView *)whc_FrameEqualView:(UIView *)view;

#pragma mark - 自动加边线模块 -

/**
 对视图底部加线
 
 @param value 线宽
 @param color 线的颜色
 @return 返回线视图
 */

- (UIView *)whc_AddBottomLine:(CGFloat)value lineColor:(UIColor *)color;

/**
 对视图底部加线
 
 @param value 线宽
 @param color 线的颜色
 @param pading 内边距
 @return 返回线视图
 */

- (UIView *)whc_AddBottomLine:(CGFloat)value lineColor:(UIColor *)color pading:(CGFloat)pading;

/**
 对视图顶部加线
 
 @param value 线宽
 @param color 线的颜色
 @return 返回线视图
 */

- (UIView *)whc_AddTopLine:(CGFloat)value lineColor:(UIColor *)color;

/**
 对视图顶部加线
 
 @param value 线宽
 @param color 线的颜色
 @param pading 内边距
 @return 返回线视图
 */

- (UIView *)whc_AddTopLine:(CGFloat)value lineColor:(UIColor *)color pading:(CGFloat)pading;

/**
 对视图左边加线
 
 @param value 线宽
 @param color 线的颜色
 @return 返回线视图
 */


- (UIView *)whc_AddLeftLine:(CGFloat)value lineColor:(UIColor *)color;

/**
 对视图左边加线

 @param value   线宽
 @param color   线的颜色
 @param padding 边距
 @return 返回线视图
 */
- (UIView *)whc_AddLeftLine:(CGFloat)value lineColor:(UIColor *)color padding:(CGFloat)padding;

/**
 对视图右边加线
 
 @param value 线宽
 @param color 线的颜色
 @return 返回线视图
 */

- (UIView *)whc_AddRightLine:(CGFloat)value lineColor:(UIColor *)color;

/**
 对视图右边加线
 
 @param value 线宽
 @param color 线的颜色
 @param padding 边距
 @return 返回线视图
 */

- (UIView *)whc_AddRightLine:(CGFloat)value lineColor:(UIColor *)color padding:(CGFloat)padding;

@end
