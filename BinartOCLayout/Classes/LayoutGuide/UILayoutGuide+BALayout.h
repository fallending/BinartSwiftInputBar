

#import "BALayoutUtil.h"

typedef UILayoutGuide * (^LGLessOrEqual)(void) NS_AVAILABLE(10_11, 9_0);
typedef UILayoutGuide * (^LGGreaterOrEqual)(void) NS_AVAILABLE(10_11, 9_0);
typedef UILayoutGuide * (^LGResetConstraintAttribute)(void) NS_AVAILABLE(10_11, 9_0);
typedef UILayoutGuide * (^LGClearConstraintAttribute)(void) NS_AVAILABLE(10_11, 9_0);
typedef UILayoutGuide * (^LGRemoveConstraintAttribute)(NSLayoutAttribute attributes, ...) NS_AVAILABLE(10_11, 9_0);
typedef UILayoutGuide * (^LGRemoveConstraintFromViewAttribute)(UIView * view, NSLayoutAttribute attributes, ...) NS_AVAILABLE(10_11, 9_0);
typedef UILayoutGuide * (^LGRemoveConstraintToViewAttribute)(NSObject * toView, NSLayoutAttribute attributes, ...) NS_AVAILABLE(10_11, 9_0);

typedef UILayoutGuide * (^LGPriorityLow)(void) NS_AVAILABLE(10_11, 9_0);
typedef UILayoutGuide * (^LGPriorityHigh)(void) NS_AVAILABLE(10_11, 9_0);
typedef UILayoutGuide * (^LGPriorityRequired)(void) NS_AVAILABLE(10_11, 9_0);
typedef UILayoutGuide * (^LGPriorityFitting)(void) NS_AVAILABLE(10_11, 9_0);
typedef UILayoutGuide * (^LGPriorityValue)(CGFloat value) NS_AVAILABLE(10_11, 9_0);

typedef UILayoutGuide * (^LGLeftSpace)(CGFloat value) NS_AVAILABLE(10_11, 9_0);
typedef UILayoutGuide * (^LGLeftSpaceToView)(CGFloat value , NSObject * toView) NS_AVAILABLE(10_11, 9_0);
typedef UILayoutGuide * (^LGLeftSpaceEqualView)(NSObject * view) NS_AVAILABLE(10_11, 9_0);
typedef UILayoutGuide * (^LGLeftSpaceEqualViewOffset)(NSObject * view, CGFloat offset) NS_AVAILABLE(10_11, 9_0);

typedef UILayoutGuide * (^LGLeadingSpace)(CGFloat value) NS_AVAILABLE(10_11, 9_0);
typedef UILayoutGuide * (^LGLeadingSpaceToView)(CGFloat value , NSObject * toView) NS_AVAILABLE(10_11, 9_0);
typedef UILayoutGuide * (^LGLeadingSpaceEqualView)(NSObject * view) NS_AVAILABLE(10_11, 9_0);
typedef UILayoutGuide * (^LGLeadingSpaceEqualViewOffset)(NSObject * view, CGFloat offset) NS_AVAILABLE(10_11, 9_0);

typedef UILayoutGuide * (^LGTrailingSpace)(CGFloat value) NS_AVAILABLE(10_11, 9_0);
typedef UILayoutGuide * (^LGTrailingSpaceToView)(CGFloat value , NSObject * toView) NS_AVAILABLE(10_11, 9_0);
typedef UILayoutGuide * (^LGTrailingSpaceEqualView)(NSObject * view) NS_AVAILABLE(10_11, 9_0);
typedef UILayoutGuide * (^LGTrailingSpaceEqualViewOffset)(NSObject * view, CGFloat offset) NS_AVAILABLE(10_11, 9_0);

typedef UILayoutGuide * (^LGBaseLineSpace)(CGFloat value) NS_AVAILABLE(10_11, 9_0);
typedef UILayoutGuide * (^LGBaseLineSpaceToView)(CGFloat value , NSObject * toView) NS_AVAILABLE(10_11, 9_0);
typedef UILayoutGuide * (^LGBaseLineSpaceEqualView)(NSObject * view) NS_AVAILABLE(10_11, 9_0);
typedef UILayoutGuide * (^LGBaseLineSpaceEqualViewOffset)(NSObject * view, CGFloat offset) NS_AVAILABLE(10_11, 9_0);

typedef UILayoutGuide * (^LGRightSpace)(CGFloat value) NS_AVAILABLE(10_11, 9_0);
typedef UILayoutGuide * (^LGRightSpaceToView)(CGFloat value , NSObject * toView) NS_AVAILABLE(10_11, 9_0);
typedef UILayoutGuide * (^LGRightSpaceEqualView)(NSObject * view) NS_AVAILABLE(10_11, 9_0);
typedef UILayoutGuide * (^LGRightSpaceEqualViewOffset)(NSObject * view, CGFloat offset) NS_AVAILABLE(10_11, 9_0);

typedef UILayoutGuide * (^LGTopSpace)(CGFloat value) NS_AVAILABLE(10_11, 9_0);
typedef UILayoutGuide * (^LGTopSpaceToView)(CGFloat value , NSObject * toView) NS_AVAILABLE(10_11, 9_0);
typedef UILayoutGuide * (^LGTopSpaceEqualView)(NSObject * view) NS_AVAILABLE(10_11, 9_0);
typedef UILayoutGuide * (^LGTopSpaceEqualViewOffset)(NSObject * view, CGFloat offset) NS_AVAILABLE(10_11, 9_0);

typedef UILayoutGuide * (^LGBottomSpace)(CGFloat value) NS_AVAILABLE(10_11, 9_0);
typedef UILayoutGuide * (^LGBottomSpaceToView)(CGFloat value , NSObject * toView) NS_AVAILABLE(10_11, 9_0);
typedef UILayoutGuide * (^LGBottomSpaceEqualView)(NSObject * view) NS_AVAILABLE(10_11, 9_0);
typedef UILayoutGuide * (^LGBottomSpaceEqualViewOffset)(NSObject * view, CGFloat offset) NS_AVAILABLE(10_11, 9_0);

typedef UILayoutGuide * (^LGWidth)(CGFloat value) NS_AVAILABLE(10_11, 9_0);
typedef UILayoutGuide * (^LGWidthAuto)(void) NS_AVAILABLE(10_11, 9_0);
typedef UILayoutGuide * (^LGWidthEqualView)(NSObject * view) NS_AVAILABLE(10_11, 9_0);
typedef UILayoutGuide * (^LGWidthEqualViewRatio)(NSObject * view, CGFloat ratio) NS_AVAILABLE(10_11, 9_0);
typedef UILayoutGuide * (^LGWidthHeightRatio)(CGFloat ratio) NS_AVAILABLE(10_11, 9_0);

typedef UILayoutGuide * (^LGHeight)(CGFloat value) NS_AVAILABLE(10_11, 9_0);
typedef UILayoutGuide * (^LGHeightAuto)(void) NS_AVAILABLE(10_11, 9_0);
typedef UILayoutGuide * (^LGHeightEqualView)(NSObject * view) NS_AVAILABLE(10_11, 9_0);
typedef UILayoutGuide * (^LGHeightEqualViewRatio)(NSObject * view, CGFloat ratio) NS_AVAILABLE(10_11, 9_0);
typedef UILayoutGuide * (^LGHeightWidthRatio)(CGFloat ratio);

typedef UILayoutGuide * (^LGCenterX)(CGFloat value) NS_AVAILABLE(10_11, 9_0);
typedef UILayoutGuide * (^LGCenterXToView)(CGFloat value, NSObject * toView) NS_AVAILABLE(10_11, 9_0);

typedef UILayoutGuide * (^LGCenterY)(CGFloat value) NS_AVAILABLE(10_11, 9_0);
typedef UILayoutGuide * (^LGCenterYToView)(CGFloat value, NSObject * toView) NS_AVAILABLE(10_11, 9_0);

typedef UILayoutGuide * (^LGCenter)(CGFloat x, CGFloat y) NS_AVAILABLE(10_11, 9_0);
typedef UILayoutGuide * (^LGCenterToView)(CGPoint center, NSObject * toView) NS_AVAILABLE(10_11, 9_0);

typedef UILayoutGuide * (^LGsize)(CGFloat width, CGFloat height) NS_AVAILABLE(10_11, 9_0);
typedef UILayoutGuide * (^LGSizeEqual)(NSObject * view) NS_AVAILABLE(10_11, 9_0);

typedef UILayoutGuide * (^LGFrameEqual)(NSObject * view) NS_AVAILABLE(10_11, 9_0);

#pragma mark - UI自动布局 -

NS_AVAILABLE(10_11, 9_0)
@interface UILayoutGuide (WHC_AutoLayout)

#pragma mark - api version ~ 2.0 -

/// 当前约束小于等于
@property (nonatomic ,copy , readonly)LGLessOrEqual whc_LessOrEqual;
/// 当前约束大于等于
@property (nonatomic ,copy , readonly)LGGreaterOrEqual whc_GreaterOrEqual;
/// 重置缓存约束
@property (nonatomic ,copy , readonly)LGResetConstraintAttribute whc_ResetConstraint;
/// 清除所有约束
@property (nonatomic ,copy , readonly)LGClearConstraintAttribute whc_ClearLayoutAttr;
/// 移除约束(NSLayoutAttribute attributes, ...)
@property (nonatomic ,copy , readonly)LGRemoveConstraintAttribute whc_RemoveLayoutAttrs;
/// 移除约束从指定视图上(NSObject * view, NSLayoutAttribute attributes, ...)
@property (nonatomic ,copy , readonly)LGRemoveConstraintFromViewAttribute whc_RemoveFromLayoutAttrs;
/// 移除约束从关联视图上(NSObject * toView, NSLayoutAttribute attributes, ...)
@property (nonatomic ,copy , readonly)LGRemoveConstraintToViewAttribute whc_RemoveToLayoutAttrs;

/// 设置当前约束的低优先级
@property (nonatomic ,copy , readonly)LGPriorityLow whc_PriorityLow;
/// 设置当前约束的高优先级
@property (nonatomic ,copy , readonly)LGPriorityHigh whc_PriorityHigh;
/// 设置当前约束的默认优先级
@property (nonatomic ,copy , readonly)LGPriorityRequired whc_PriorityRequired;
/// 设置当前约束的合适优先级
@property (nonatomic ,copy , readonly)LGPriorityFitting whc_PriorityFitting;
/// 设置当前约束的优先级 (CGFloat value): 优先级大小(0-1000)
@property (nonatomic ,copy , readonly)LGPriorityValue whc_Priority;

/// 与父视图左边间距(CGFloat value)
@property (nonatomic ,copy , readonly)LGLeftSpace whc_LeftSpace;
/// 与相对视图toView左边间距(CGFloat value,NSObject * toView)
@property (nonatomic ,copy , readonly)LGLeftSpaceToView whc_LeftSpaceToView;
/// 与视图view左边间距相等(NSObject * view)
@property (nonatomic ,copy , readonly)LGLeftSpaceEqualView whc_LeftSpaceEqualView;
/// 与视图view左边间距相等并偏移offset(NSObject * view, CGFloat offset)
@property (nonatomic ,copy , readonly)LGLeftSpaceEqualViewOffset whc_LeftSpaceEqualViewOffset;

/// 与父视图左边间距(CGFloat value)
@property (nonatomic ,copy , readonly)LGLeadingSpace whc_LeadingSpace;
/// 与相对视图toView左边间距(CGFloat value,NSObject * toView)
@property (nonatomic ,copy , readonly)LGLeadingSpaceToView whc_LeadingSpaceToView;
/// 与视图view左边间距相等(NSObject * view)
@property (nonatomic ,copy , readonly)LGLeadingSpaceEqualView whc_LeadingSpaceEqualView;
/// 与视图view左边间距相等并偏移offset (NSObject * view, CGFloat offset)
@property (nonatomic ,copy , readonly)LGLeadingSpaceEqualViewOffset whc_LeadingSpaceEqualViewOffset;

/// 与父视图右边间距(CGFloat value)
@property (nonatomic ,copy , readonly)LGTrailingSpace whc_TrailingSpace;
/// 与相对视图toView右边间距(CGFloat value,NSObject * toView)
@property (nonatomic ,copy , readonly)LGTrailingSpaceToView whc_TrailingSpaceToView;
/// 与视图view右边间距相等(NSObject * view)
@property (nonatomic ,copy , readonly)LGTrailingSpaceEqualView whc_TrailingSpaceEqualView;
/// 与视图view右边间距相等并偏移offset(NSObject * view, CGFloat offset)
@property (nonatomic ,copy , readonly)LGTrailingSpaceEqualViewOffset whc_TrailingSpaceEqualViewOffset;

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
/// 与父视图底边间距Y(CGFloat value)
@property (nonatomic ,copy , readonly)LGBaseLineSpace whc_FirstBaseLine;
/// 与相对视图toView底边间距Y(CGFloat value,NSObject * toView)
@property (nonatomic ,copy , readonly)LGBaseLineSpaceToView whc_FirstBaseLineToView;
/// 与视图view底边间距Y相等(NSObject * view)
@property (nonatomic ,copy , readonly)LGBaseLineSpaceEqualView whc_FirstBaseLineEqualView;
/// 与视图view底边间距Y相等并偏移offset(NSObject * view, CGFloat offset)
@property (nonatomic ,copy , readonly)LGBaseLineSpaceEqualViewOffset whc_FirstBaseLineEqualViewOffset;
#endif

/// 与父视图底边间距Y(CGFloat value)
@property (nonatomic ,copy , readonly)LGBaseLineSpace whc_LastBaseLine;
/// 与相对视图toView底边间距Y(CGFloat value,NSObject * toView)
@property (nonatomic ,copy , readonly)LGBaseLineSpaceToView whc_LastBaseLineToView;
/// 与视图view底边间距Y相等(NSObject * view)
@property (nonatomic ,copy , readonly)LGBaseLineSpaceEqualView whc_LastBaseLineEqualView;
/// 与视图view底边间距Y相等并偏移offset(NSObject * view, CGFloat offset)
@property (nonatomic ,copy , readonly)LGBaseLineSpaceEqualViewOffset whc_LastBaseLineEqualViewOffset;
/// 与父视图右边间距(CGFloat value)
@property (nonatomic ,copy , readonly)LGRightSpace whc_RightSpace;
/// 与相对视图toView右边间距(CGFloat value,NSObject * toView)
@property (nonatomic ,copy , readonly)LGRightSpaceToView whc_RightSpaceToView;
/// 与相对视图toView右边间距相等(NSObject toView)
@property (nonatomic ,copy , readonly)LGRightSpaceEqualView whc_RightSpaceEqualView;
/// 与相对视图toView右边间距相等并偏移offset(NSObject toView, CGFloat offset)
@property (nonatomic ,copy , readonly)LGRightSpaceEqualViewOffset whc_RightSpaceEqualViewOffset;

/// 与父视图顶边间距(CGFloat value)
@property (nonatomic ,copy , readonly)LGTopSpace whc_TopSpace;
/// 与相对视图toView顶边间距(CGFloat value,NSObject * toView)
@property (nonatomic ,copy , readonly)LGTopSpaceToView whc_TopSpaceToView;
/// 与视图view顶边间距相等(NSObject * view)
@property (nonatomic ,copy , readonly)LGTopSpaceEqualView whc_TopSpaceEqualView;
/// 与视图view顶边间距相等并偏移offset(NSObject * view, CGFloat offset)
@property (nonatomic ,copy , readonly)LGTopSpaceEqualViewOffset whc_TopSpaceEqualViewOffset;

/// 与父视图底边间距(CGFloat value)
@property (nonatomic ,copy , readonly)LGBottomSpace whc_BottomSpace;
/// 与相对视图toView底边间距(CGFloat value,NSObject * toView)
@property (nonatomic ,copy , readonly)LGBottomSpaceToView whc_BottomSpaceToView;
/// 与相对视图toView底边间距相等(NSObject * toView)
@property (nonatomic ,copy , readonly)LGBottomSpaceEqualView whc_BottomSpaceEqualView;
/// 与相对视图toView底边间距相等并偏移offset(NSObject * toView, CGFloat offset)
@property (nonatomic ,copy , readonly)LGBottomSpaceEqualViewOffset whc_BottomSpaceEqualViewOffset;

/// 宽度(CGFloat value)
@property (nonatomic ,copy , readonly)LGWidth whc_Width;
/// 宽度自动()
@property (nonatomic ,copy , readonly)LGWidthAuto whc_WidthAuto;
/// 宽度等于视图view(NSObject * view)
@property (nonatomic ,copy , readonly)LGWidthEqualView whc_WidthEqualView;
/// 宽度等于视图view 参照比例Ratio(NSObject * view ,CGFloat ratio)
@property (nonatomic ,copy , readonly)LGWidthEqualViewRatio whc_WidthEqualViewRatio;
/// 视图自身宽度与高度的比(CGFloat Ratio)
@property (nonatomic ,copy , readonly)LGWidthHeightRatio whc_WidthHeightRatio;

/// 高度(CGFloat value)
@property (nonatomic ,copy , readonly)LGHeight whc_Height;
/// 高度自动()
@property (nonatomic ,copy , readonly)LGHeightAuto whc_HeightAuto;
/// 高度等于视图view(NSObject * view)
@property (nonatomic ,copy , readonly)LGHeightEqualView whc_HeightEqualView;
/// 高度等于视图view 参照比例Ratio(NSObject * view ,CGFloat ratio)
@property (nonatomic ,copy , readonly)LGHeightEqualViewRatio whc_HeightEqualViewRatio;
/// 视图自身高度与宽度的比(CGFloat Ratio)
@property (nonatomic ,copy , readonly)LGHeightWidthRatio whc_HeightWidthRatio;

/// 中心X与父视图偏移(CGFloat value)
@property (nonatomic ,copy , readonly)LGCenterX whc_CenterX;
/// 中心X与视图view偏移(CGFloat value , NSObject * toView)
@property (nonatomic ,copy , readonly)LGCenterXToView whc_CenterXToView;

/// 中心Y与父视图偏移(CGFloat value)
@property (nonatomic ,copy , readonly)LGCenterY whc_CenterY;
/// 中心Y与视图view偏移(CGFloat value , NSObject * toView)
@property (nonatomic ,copy , readonly)LGCenterYToView whc_CenterYToView;

/// 中心与父视图偏移(CGFloat value)
@property (nonatomic ,copy , readonly)LGCenter whc_Center;
/// 中心与视图view偏移(CGFloat value , NSObject * toView)
@property (nonatomic ,copy , readonly)LGCenterToView whc_CenterToView;

/// size设置(CGFloat width, CGFloat height)
@property (nonatomic ,copy , readonly)LGsize whc_Size;
/// size设置(NSObject * view)
@property (nonatomic ,copy , readonly)LGSizeEqual whc_SizeEqualView;

/// frame设置(NSObject * view)
@property (nonatomic ,copy , readonly)LGFrameEqual whc_FrameEqualView;
#pragma mark - api version ~ 1.0 -


/**
 重置缓存的约束,该方法在当前视图对象移除从父视图上可能需要调用清除与父视图之前旧约束缓存对象
 
 @return 返回当前视图
 */
- (UILayoutGuide *)whc_ResetConstraints;

/**
 清除所有布局属性
 
 @return 返回当前视图
 */
- (UILayoutGuide *)whc_ClearLayoutAttrs;

/**
 移除一个或者一组约束
 
 @param attributes 约束类型（可变参数）
 @return 返回当前视图
 */
- (UILayoutGuide *)whc_RemoveLayoutAttr:(NSLayoutAttribute)attributes, ...;


/**
 移除一个单个属性
 
 @param attribute 约束类型
 @return 返回当前视图
 */
- (UILayoutGuide *)whc_RemoveLayoutOneAttr:(NSLayoutAttribute)attribute;

/**
 移除一个或者一组约束从指定的视图上
 
 @param view 指定视图
 @param attributes 约束类型（可变参数）
 @return 返回当前视图
 */
- (UILayoutGuide *)whc_RemoveFrom:(UILayoutGuide *)view layoutAttrs:(NSLayoutAttribute)attributes, ...;


/**
 移除一个约束从指定的视图上
 
 @param view 指定视图
 @param attribute 约束类型
 @return 返回当前视图
 */
- (UILayoutGuide *)whc_RemoveFrom:(UILayoutGuide *)view layoutAttr:(NSLayoutAttribute)attribute;


/**
 移除一个约束从关联的视图
 
 @param view 关联的视图
 @param attribute 移除的约束
 @return 当前视图
 */
- (UILayoutGuide *)whc_RemoveTo:(NSObject *)view attr:(NSLayoutAttribute)attribute;

/**
 移除多个约束从关联的视图
 
 @param view 关联的视图
 @param attributes 移除的约束
 @return 当前视图
 */

- (UILayoutGuide *)whc_RemoveTo:(NSObject *)view layoutAttrs:(NSLayoutAttribute)attributes, ... ;

/**
 设置当前约束的低优先级
 
 @return 返回当前视图
 */
- (UILayoutGuide *)whc_priorityLow;

/**
 设置当前约束的高优先级
 
 @return 返回当前视图
 */
- (UILayoutGuide *)whc_priorityHigh;

/**
 设置当前约束的默认优先级
 
 @return 返回当前视图
 */
- (UILayoutGuide *)whc_priorityRequired;

/**
 设置当前约束的合适优先级
 
 @return 返回当前视图
 */
- (UILayoutGuide *)whc_priorityFitting;

/**
 设置当前约束的优先级
 
 @param value 优先级大小(0-1000)
 @return 返回当前视图
 */
- (UILayoutGuide *)whc_priority:(CGFloat)value;

/**
 设置左边距(默认相对父视图)
 
 @param leftSpace 左边距
 @return 返回当前视图
 */
- (UILayoutGuide *)whc_LeftSpace:(CGFloat)leftSpace;


/**
 设置左边距
 
 @param leftSpace 左边距
 @param toView 相对视图
 @return 返回当前视图
 */
- (UILayoutGuide *)whc_LeftSpace:(CGFloat)leftSpace toView:(NSObject *)toView;

/**
 设置左边距与视图view左边距相等
 
 @param view 相对视图
 @return 返回当前视图
 */
- (UILayoutGuide *)whc_LeftSpaceEqualView:(NSObject *)view;

/**
 设置左边距与视图view左边距相等并偏移offset
 
 @param view 相对视图
 @param offset 偏移量
 @return 返回当前视图
 */
- (UILayoutGuide *)whc_LeftSpaceEqualView:(NSObject *)view offset:(CGFloat)offset;

/**
 设置右边距(默认相对父视图)
 
 @param rightSpace 右边距
 @return 返回当前视图
 */
- (UILayoutGuide *)whc_RightSpace:(CGFloat)rightSpace;

/**
 设置右边距
 
 @param rightSpace 右边距
 @param toView 相对视图
 @return 返回当前视图
 */
- (UILayoutGuide *)whc_RightSpace:(CGFloat)rightSpace toView:(NSObject *)toView;

/**
 设置右边距与视图view左对齐边距相等
 
 @param view 相对视图
 @return 返回当前视图
 */
- (UILayoutGuide *)whc_RightSpaceEqualView:(NSObject *)view;

/**
 设置右边距与视图view左对齐边距相等并偏移offset
 
 @param view 相对视图
 @param offset 偏移量
 @return 返回当前视图
 */
- (UILayoutGuide *)whc_RightSpaceEqualView:(NSObject *)view offset:(CGFloat)offset;

/**
 设置左对齐(默认相对父视图)
 
 @param leadingSpace 左边距
 @return 返回当前视图
 */
- (UILayoutGuide *)whc_LeadingSpace:(CGFloat)leadingSpace;

/**
 设置左对齐
 
 @param leadingSpace 左边距
 @param toView 相对视图
 @return 返回当前视图
 */

- (UILayoutGuide *)whc_LeadingSpace:(CGFloat)leadingSpace toView:(NSObject *)toView;

/**
 设置左对齐边距与某视图左对齐边距相等
 
 @param view 相对视图
 @return 返回当前视图
 */
- (UILayoutGuide *)whc_LeadingSpaceEqualView:(NSObject *)view;

/**
 设置左对齐边距与某视图左对齐边距相等并偏移offset
 
 @param view 相对视图
 @param offset 偏移量
 @return 返回当前视图
 */
- (UILayoutGuide *)whc_LeadingSpaceEqualView:(NSObject *)view offset:(CGFloat)offset;

/**
 设置右对齐(默认相对父视图)
 
 @param trailingSpace 右边距
 @return 返回当前视图
 */
- (UILayoutGuide *)whc_TrailingSpace:(CGFloat)trailingSpace;

/**
 设置右对齐
 
 @param trailingSpace 右边距
 @param toView 相对视图
 @return 返回当前视图
 */
- (UILayoutGuide *)whc_TrailingSpace:(CGFloat)trailingSpace toView:(NSObject *)toView;

/**
 设置右对齐边距与某视图右对齐边距相等
 
 @param view 相对视图
 @return 返回当前视图
 */
- (UILayoutGuide *)whc_TrailingSpaceEqualView:(NSObject *)view;

/**
 设置右对齐边距与某视图右对齐边距相等并偏移offset
 
 @param view 相对视图
 @param offset 偏移量
 @return 返回当前视图
 */
- (UILayoutGuide *)whc_TrailingSpaceEqualView:(NSObject *)view offset:(CGFloat)offset;

/**
 设置顶边距(默认相对父视图)
 
 @param topSpace 顶边距
 @return 返回当前视图
 */
- (UILayoutGuide *)whc_TopSpace:(CGFloat)topSpace;

/**
 设置顶边距
 
 @param topSpace 顶边距
 @param toView 相对视图
 @return 返回当前视图
 */
- (UILayoutGuide *)whc_TopSpace:(CGFloat)topSpace toView:(NSObject *)toView;

/**
 设置顶边距与视图view顶边距相等
 
 @param view 相对视图
 @return 返回当前视图
 */
- (UILayoutGuide *)whc_TopSpaceEqualView:(NSObject *)view;

/**
 设置顶边距与视图view顶边距相等并偏移offset
 
 @param view 相对视图
 @param offset 偏移量
 @return 返回当前视图
 */
- (UILayoutGuide *)whc_TopSpaceEqualView:(NSObject *)view offset:(CGFloat)offset;

/**
 设置底边距(默认相对父视图)
 
 @param bottomSpace 底边距
 @return 返回当前视图
 */
- (UILayoutGuide *)whc_BottomSpace:(CGFloat)bottomSpace;

/**
 设置底边距
 
 @param bottomSpace 底边距
 @param toView 相对视图
 @return 返回当前视图
 */
- (UILayoutGuide *)whc_BottomSpace:(CGFloat)bottomSpace toView:(NSObject *)toView;

/**
 设置底边距与视图view底边距相等
 
 @param view 相对视图
 @return 返回当前视图
 */
- (UILayoutGuide *)whc_BottomSpaceEqualView:(NSObject *)view;

/**
 设置底边距与视图view底边距相等并偏移offset
 
 @param view 相对视图
 @param offset 偏移量
 @return 返回当前视图
 */
- (UILayoutGuide *)whc_BottomSpaceEqualView:(NSObject *)view offset:(CGFloat)offset;

/**
 设置宽度
 
 @param width 宽度
 @return 返回当前视图
 */
- (UILayoutGuide *)whc_Width:(CGFloat)width;

/**
 设置宽度与某个视图相等
 
 @param view 相对视图
 @return 返回当前视图
 */
- (UILayoutGuide *)whc_WidthEqualView:(NSObject *)view;

/**
 设置宽度与视图view相等
 
 @param view 相对视图
 @param ratio 比例
 @return 返回当前视图
 */
- (UILayoutGuide *)whc_WidthEqualView:(NSObject *)view ratio:(CGFloat)ratio;

/**
 设置自动宽度
 
 @return 返回当前视图
 */
- (UILayoutGuide *)whc_AutoWidth;

/**
 设置视图自身宽度与高度的比
 
 @param ratio 比例
 @return 返回当前视图
 */
- (UILayoutGuide *)whc_WidthHeightRatio:(CGFloat)ratio;

/**
 设置高度
 
 @param height 高度
 @return 返回当前视图
 */
- (UILayoutGuide *)whc_Height:(CGFloat)height;

/**
 设置高度与视图view相等
 
 @param view 相对视图
 @return 返回当前视图
 */
- (UILayoutGuide *)whc_HeightEqualView:(NSObject *)view;

/**
 设置高度与视图view相等
 
 @param view 相对视图
 @param ratio 比例
 @return 返回当前视图
 */
- (UILayoutGuide *)whc_HeightEqualView:(NSObject *)view ratio:(CGFloat)ratio;

/**
 设置自动高度
 
 @return 返回当前视图
 */
- (UILayoutGuide *)whc_AutoHeight;

/**
 设置视图自身高度与宽度的比
 
 @param ratio 比例
 @return 返回当前视图
 */
- (UILayoutGuide *)whc_HeightWidthRatio:(CGFloat)ratio;

/**
 设置中心x与父视图中心的偏移 centerX = 0 与父视图中心x重合
 
 @param centerX 中心x坐标偏移
 @return 返回当前视图
 */
- (UILayoutGuide *)whc_CenterX:(CGFloat)centerX;

/**
 设置中心x与相对视图中心的偏移 centerX = 0 与相对视图中心x重合
 
 @param centerX 中心x坐标偏移
 @param toView 相对视图
 @return 返回当前视图
 */
- (UILayoutGuide *)whc_CenterX:(CGFloat)centerX toView:(NSObject *)toView;

/**
 设置中心y与父视图中心的偏移 centerY = 0 与父视图中心y重合
 
 @param centerY 中心y坐标偏移
 @return 返回当前视图
 */
- (UILayoutGuide *)whc_CenterY:(CGFloat)centerY;

/**
 设置中心y与相对视图中心的偏移 centerY = 0 与相对视图中心y重合
 
 @param centerY 中心y坐标偏移
 @param toView 相对视图
 @return 返回当前视图
 */
- (UILayoutGuide *)whc_CenterY:(CGFloat)centerY toView:(NSObject *)toView;

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
/**
 设置顶部基线偏移(默认相对父视图)
 
 @param space 间隙
 @return 返回当前视图
 */
- (UILayoutGuide *)whc_FirstBaseLine:(CGFloat)space;

/**
 设置顶部基线与对象视图底部基线偏移
 
 @param space 间隙
 @param toView 相对视图
 @return 返回当前视图
 */
- (UILayoutGuide *)whc_FirstBaseLine:(CGFloat)space toView:(NSObject *)toView;

/**
 设置顶部基线与相对视图顶部基线相等
 
 @param view 相对视图
 @return 返回当前视图
 */
- (UILayoutGuide *)whc_FirstBaseLineEqualView:(NSObject *)view;

/**
 设置顶部基线与相对视图顶部基线相等并偏移offset
 
 @param view 相对视图
 @param offset 偏移量
 @return 返回当前视图
 */
- (UILayoutGuide *)whc_FirstBaseLineEqualView:(NSObject *)view offset:(CGFloat)offset;

#endif

/**
 设置底部基线偏移(默认相对父视图)
 
 @param space 间隙
 @return 返回当前视图
 */
- (UILayoutGuide *)whc_LastBaseLine:(CGFloat)space;

/**
 设置底部基线与对象视图顶部基线偏移
 
 @param space 间隙
 @param toView 相对视图
 @return 返回当前视图
 */
- (UILayoutGuide *)whc_LastBaseLine:(CGFloat)space toView:(NSObject *)toView;

/**
 设置底部基线与相对视图底部基线相等
 
 @param view 相对视图
 @return 返回当前视图
 */
- (UILayoutGuide *)whc_LastBaseLineEqualView:(NSObject *)view;

/**
 设置底部基线与相对视图底部基线相等并偏移offset
 
 @param view 相对视图
 @param offset 偏移量
 @return 返回当前视图
 */
- (UILayoutGuide *)whc_LastBaseLineEqualView:(NSObject *)view offset:(CGFloat)offset;


/**
 设置中心偏移(默认相对父视图)center = CGPointZero 与父视图中心重合
 
 @param center 中心偏移xy
 @return 返回当前视图
 */
- (UILayoutGuide *)whc_Center:(CGPoint)center;

/**
 设置中心偏移(默认相对父视图)center = CGPointZero 与父视图中心重合
 
 @param center 中心偏移xy
 @param toView 相对视图
 @return 返回当前视图
 */
- (UILayoutGuide *)whc_Center:(CGPoint)center toView:(NSObject *)toView;


/**
 设置frame(默认相对父视图)
 
 @param left 左边距
 @param top 顶边距
 @param width 宽度
 @param height 高度
 @return 返回当前视图
 */
- (UILayoutGuide *)whc_Frame:(CGFloat)left top:(CGFloat)top width:(CGFloat)width height:(CGFloat)height;

/**
 设置frame (默认相对父视图)
 
 @param left 左边距
 @param top 顶边距
 @param right 右边距
 @param bottom 底边距
 @return 返回当前视图
 */

- (UILayoutGuide *)whc_AutoSize:(CGFloat)left top:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom;

/**
 设置frame
 
 @param left 左边距
 @param top 顶边距
 @param width 宽度
 @param height 高度
 @param toView 相对视图
 @return 返回当前视图
 */

- (UILayoutGuide *)whc_Frame:(CGFloat)left top:(CGFloat)top width:(CGFloat)width height:(CGFloat)height toView:(NSObject *)toView;

/**
 设置frame (默认相对父视图)
 
 @param left 左边距
 @param top 顶边距
 @param right 右边距
 @param height 高度
 @return 返回当前视图
 */

- (UILayoutGuide *)whc_AutoWidth:(CGFloat)left top:(CGFloat)top right:(CGFloat)right height:(CGFloat)height;

/**
 设置frame (默认相对父视图)
 
 @param left 左边距
 @param top 顶边距
 @param width 宽度
 @param bottom 底边距
 @return 返回当前视图
 */

- (UILayoutGuide *)whc_AutoHeight:(CGFloat)left top:(CGFloat)top width:(CGFloat)width bottom:(CGFloat)bottom;

/**
 设置frame
 
 @param left 左边距
 @param top 顶边距
 @param right 右边距
 @param bottom 底边距
 @param toView 相对视图
 @return 返回当前视图
 */

- (UILayoutGuide *)whc_AutoSize:(CGFloat)left top:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom toView:(NSObject *)toView;

/**
 设置frame
 
 @param left 左边距
 @param top 顶边距
 @param right 右边距
 @param height 高度
 @param toView 相对视图
 @return 返回当前视图
 */

- (UILayoutGuide *)whc_AutoWidth:(CGFloat)left top:(CGFloat)top right:(CGFloat)right height:(CGFloat)height toView:(NSObject *)toView;

/**
 设置frame (默认相对父视图)
 
 @param left 左边距
 @param top 顶边距
 @param width 宽度
 @param bottom 底边距
 @return 返回当前视图
 */

- (UILayoutGuide *)whc_AutoHeight:(CGFloat)left top:(CGFloat)top width:(CGFloat)width bottom:(CGFloat)bottom toView:(NSObject *)toView;

/**
 设置视图显示宽高
 
 @param size 视图宽高
 @return 返回当前视图
 */

- (UILayoutGuide *)whc_Size:(CGSize)size;

/**
 设置视图size等于view
 
 @param view 相对视图
 @return 返回当前视图
 */
- (UILayoutGuide *)whc_SizeEqualView:(NSObject *)view;

/**
 设置视图frame等于view
 @param view 相对视图
 @return 返回当前视图
 */
- (UILayoutGuide *)whc_FrameEqualView:(NSObject *)view;

@end
