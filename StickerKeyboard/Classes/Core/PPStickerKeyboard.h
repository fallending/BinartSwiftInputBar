//
//  PPSktickerKeyboard.h
//  PPStickerKeyboard
//
//  Created by Vernon on 2018/1/14.
//  Copyright © 2018年 Vernon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BAStickerBundle.h"

@class BAEmoji;
@class BASticker;
@class BAStickerBundle;
@class PPStickerKeyboard;

@protocol PPStickerKeyboardDelegate <NSObject>

/// 大表情点击
- (void)on:(BAStickerBundle *)stickerBundle stickerClicked:(BASticker *)sticker;

/// 小表情点击
- (void)on:(BAStickerBundle *)stickerBundle emojiClicked:(BAEmoji *)emoji;

/// 小表情删除
- (void)onEmojiDelete;

/// 小表情发送
- (void)onEmojiSend;

@end

@interface PPStickerKeyboard : UIView

/// 事件通知代理
@property (nonatomic, weak) id<PPStickerKeyboardDelegate> delegate;

/// 获取表情键盘高度
- (CGFloat)heightThatFits;

/// 输入框变化通知
- (void)notifyInputChanged:(NSString *)text;

@end
