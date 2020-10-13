//
//  BAInputExtCell.h
//  ZYXHorizontalFlowLayout
//
//  Created by Seven on 2020/10/12.
//  Copyright © 2020 zyx. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BAInputExtItem : NSObject

@property (nonatomic, assign) int32_t tag;

// -- 样式

@property (nonatomic, copy) UIColor *iconOverlayBackgroundColor;
@property (nonatomic, copy) UIColor *titleColor;

// -- 数据

@property (nonatomic, strong) UIImage *iconImage;
@property (nonatomic, copy) NSString *title; // NoTitle模式下，传空

@end

/// 类微信输入面板的扩展区按钮
@interface BAInputExtCell : UICollectionViewCell

@property (class, nonatomic, readonly) CGSize preferredSize;
@property (class, nonatomic, readonly) CGSize preferredSizeNoTitle;
@property (class, nonatomic, readonly) NSString *identifier;

- (void)setupData:(BAInputExtItem *)item;

@end

NS_ASSUME_NONNULL_END
