//
//  BAInputExtCell.m
//  ZYXHorizontalFlowLayout
//
//  Created by Seven on 2020/10/12.
//  Copyright © 2020 zyx. All rights reserved.
//

#import "BAInputExtCell.h"

@implementation BAInputExtItem

- (instancetype)init {
    if (self = [super init]) {
        [self setupDefault];
    }
    
    return self;
}

- (void)setupDefault {
    self.tag = 0;
    
    self.iconOverlayBackgroundColor = [UIColor colorWithRed:42.f/255 green:43.f/255 blue:44.f/255 alpha:1.0];
    self.titleColor = [UIColor whiteColor];
}

@end

#define kIconOverlayWidth 60
#define kIconWidth 30

@interface BAInputExtCell ()

@property (nonatomic, strong) UIView *iconOverlayView;
@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation BAInputExtCell

- (instancetype)init {
    if (self = [super init]) {
        [self setupUI];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    // 图标底视图
    UIView *overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kIconOverlayWidth, kIconOverlayWidth)];
    overlay.layer.cornerRadius = 4;
    [self addSubview:overlay];
    
    // 图标
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kIconWidth, kIconWidth)];
    icon.center = CGPointMake(kIconOverlayWidth/2, kIconOverlayWidth/2);
    [self addSubview:icon];
    
    // 标题
    UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
    label.hidden = YES;
    label.textAlignment = NSTextAlignmentCenter;
    label.center = CGPointMake(kIconOverlayWidth/2, kIconOverlayWidth+15);
    label.font = [UIFont systemFontOfSize:14];
    [self addSubview:label];
    
    self.iconOverlayView = overlay;
    self.iconImageView = icon;
    self.titleLabel = label;
}

- (void)setupData:(BAInputExtItem *)item {
    
    self.iconOverlayView.backgroundColor = item.iconOverlayBackgroundColor;
    
    self.iconImageView.image = item.iconImage;
    
    self.titleLabel.textColor = item.titleColor;
    self.titleLabel.alpha = 0.6;
    self.titleLabel.text = item.title;
    self.titleLabel.hidden = !item.title;
}

// MARK: -

+ (CGSize)preferredSize {
    return CGSizeMake(kIconOverlayWidth, 72);
}

+ (CGSize)preferredSizeNoTitle {
    return CGSizeMake(kIconOverlayWidth, kIconOverlayWidth);
}

+ (NSString *)identifier {
    return NSStringFromClass(self.class);
}

@end
