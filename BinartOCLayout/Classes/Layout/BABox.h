//
//  BABox.h
//  BinartOCLayout
//
//  Created by Seven on 2020/8/12.
//

#import "BALayoutUtil.h"

NS_ASSUME_NONNULL_BEGIN

// 盒子
typedef struct BABox {
    BAPadding padding;
    BAMargin margin;
    
    CGFloat width;
    CGFloat height;
    CGFloat x;
    CGFloat y;
} BABox;

@interface BABoxEngine : NSObject

@property (nonatomic, weak) UIView *target; // 修饰的目标视图

@end

NS_ASSUME_NONNULL_END
