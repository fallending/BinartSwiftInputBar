//
//  BAInputConfig.h
//  PPStickerKeyboard
//
//  Created by Seven on 2020/8/22.
//  Copyright © 2020 Vernon. All rights reserved.
//

#import "BAExtensions.h"
#import "BAStickerBundle.h"
#import "PPStickerInputView.h"
#import "BAEmoji.h"
#import "BASticker.h"

NS_ASSUME_NONNULL_BEGIN

@interface BAInputConfig : NSObject

@property (class, nonatomic, readonly) BAInputConfig *shared;

/// 表情配置文件 v1
@property (nonatomic, copy) NSString *configFile;

// v2
// 支持运行时reload，发通知，界面刷新
// 建议将预设置的表情包，拷贝到指定目录，然后统一管理。
@property (nonatomic, strong) NSArray<NSBundle *> *stickerBundles;

/// 预览背景图
@property (nonatomic, strong) UIImage *previewImage;
/// 切换表情图标
@property (nonatomic, strong) UIImage *toggleEmoji;
/// 切换键盘图标
@property (nonatomic, strong) UIImage *toggleKeyboard;
/// 退格按钮正常图标
@property (nonatomic, strong) UIImage *deleteImageNormal;
/// 退格按钮禁用图标
//@property (nonatomic, strong) UIImage *deleteImageDisabled;
/// 退格按钮背景色
@property (nonatomic, copy) UIColor *deleteBackgroundColor;
/// 发送按钮正常色
@property (nonatomic, copy) UIColor *sendColorNormal;
/// 发送按钮禁用色
//@property (nonatomic, copy) UIColor *sendColorDisabled;
/// 发送按钮背景色
@property (nonatomic, copy) UIColor *sendBackgroundColor;
/// 类别选择面板背景色
@property (nonatomic, copy) UIColor *cateBackgroundColor;
/// 表情包面板背景色
@property (nonatomic, copy) UIColor *stickerBackgroundColor;

/// 执行配置文件解析
- (void)config;

/// 所有的表情包
@property (nonatomic, strong, readonly) NSArray<BAStickerBundle *> *allStickers;

/**
 匹配给定attributedString中的所有emoji，如果匹配到的emoji有本地图片的话会直接换成本地的图片
 
 @param attributedString 可能包含表情包的attributedString
 @param font 表情图片的对齐字体大小
 */
- (void)replaceEmojiForAttributedString:(NSMutableAttributedString *)attributedString font:(UIFont *)font;


@end

NS_ASSUME_NONNULL_END
