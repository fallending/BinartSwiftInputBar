//
//  BAStackViewPrivate.h
//  BinartOCLayout
//
//  Created by Seven on 2020/8/11.
//

#import "BALayoutUtil.h"

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
