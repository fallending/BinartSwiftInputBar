//
//  BAHorizontalPageView.h
//  ZYXHorizontalFlowLayout
//
//  Created by Seven on 2020/10/12.
//  Copyright © 2020 zyx. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class BAInputExtItem;

@interface BAHorizontalPageView : UICollectionView

+ (instancetype)inputExtContainerViewWith:(NSArray *)dataSource safeAreaSpacing:(CGFloat)safeAreaSpacing clickHandler:(void(^)(BAInputExtItem *item))clickHandler;

@end

NS_ASSUME_NONNULL_END
