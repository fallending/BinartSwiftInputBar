//
//  BAHorizontalLayout.h
//  ZYXHorizontalFlowLayout
//
//  Created by 张哈哈 on 2018/6/23.
//  Copyright © 2018年 zyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BAHorizontalLayout : UICollectionViewFlowLayout

/// 行数量
@property (nonatomic, assign) NSInteger rowCount;

/// 列数量
@property (nonatomic, assign) NSInteger columCount;

/// 容器大小
/// 在itemSize/rowCount/columnCount设置后
@property (nonatomic, assign) CGSize containerSize;

/// 是否支持分页
@property (nonatomic, assign) BOOL pagingEnabled;

/// 是否显示页指示器
@property (nonatomic, assign) BOOL pagingIndicatorEnabled;

/// 页指示器正常颜色
@property (nonatomic, copy) UIColor *pagingIndicatorNormalColor;

/// 页指示器高亮颜色
@property (nonatomic, copy) UIColor *pagingIndicatorHighlightColor;

@end
