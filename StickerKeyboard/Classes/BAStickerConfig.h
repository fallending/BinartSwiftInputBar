//
//  BAStickerConfig.h
//  PPStickerKeyboard
//
//  Created by Seven on 2020/8/22.
//  Copyright © 2020 Vernon. All rights reserved.
//

#import "PPUtil.h"
#import "BAStickerBundle.h"
#import "PPStickerInputView.h"
#import "BAEmoji.h"
#import "BASticker.h"

NS_ASSUME_NONNULL_BEGIN

@interface BAStickerConfig : NSObject

@property (class, nonatomic, readonly) BAStickerConfig *shared;

/// 表情配置文件
@property (nonatomic, copy) NSString *configFile;
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
