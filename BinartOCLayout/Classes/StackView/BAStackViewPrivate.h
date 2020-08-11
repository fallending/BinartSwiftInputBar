//
//  BAStackViewPrivate.h
//  BinartOCLayout
//
//  Created by Seven on 2020/8/11.
//

#import "BALayoutUtil.h"

/// 填充空白视图类
@interface WHC_VacntView : UIView

@end

/// 分割线视图
@interface BAStackViewLineView : UIView

@end

@interface BAStackView () {
    BOOL      _autoHeight;
    BOOL      _autoWidth;
    NSInteger _lastRowVacantCount;
}

- (BAStackViewLineView *)makeLine;

@end
