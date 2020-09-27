//
//  PPStickerTextView.h
//  PPStickerKeyboard
//
//  Created by Vernon on 2018/1/17.
//  Copyright © 2018年 Vernon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BAAnimatedImage;
@class PPStickerInputView;

typedef NS_ENUM (NSUInteger, PPKeyboardType) {
    PPKeyboardTypeNone = 0,
    PPKeyboardTypeSystem,
    PPKeyboardTypeSticker,
};

@protocol PPStickerInputViewDelegate <NSObject>

@optional

- (BOOL)stickerInputViewShouldBeginEditing:(PPStickerInputView *)inputView;

- (void)stickerInputViewDidEndEditing:(PPStickerInputView *)inputView;

- (void)stickerInputViewDidChange:(PPStickerInputView *)inputView;

- (void)stickerInputViewDidClickSendButton:(PPStickerInputView *)inputView;

@end

@interface PPStickerInputView : UIView

@property (nonatomic, weak) id<PPStickerInputViewDelegate> delegate;

// 小表情
@property (nonatomic, strong, readonly) NSString *plainText;

// 大表情
@property (nonatomic, strong) UIImage *sendImage;
@property (nonatomic, strong) BAAnimatedImage *sendAnimated;

@property (nonatomic, assign, readonly) PPKeyboardType keyboardType;

- (CGFloat)heightThatFits;

- (void)clearText;

- (void)changeKeyboardTo:(PPKeyboardType)toType;

@end
