//
//  BAInputHelper.h
//  BinartOCStickerKeyboard
//
//  Created by Seven on 2020/10/13.
//

#import <Foundation/Foundation.h>
#import "PPStickerTextView.h"
#import "PPStickerKeyboard.h"
#import "BAAnimatedImage.h"

NS_ASSUME_NONNULL_BEGIN

@class BAInputHelper;

@protocol BAInputHelperDelegate <NSObject>

@optional

// 消息发送回调

- (void)onInput:(BAInputHelper *)inputHelper sendText:(NSString *)text;

- (void)onInput:(BAInputHelper *)inputHelper sendSticker:(BASticker *)sticker;

// 文本编辑回调

- (BOOL)onInputShouldBeginEditing:(BAInputHelper *)inputHelper;

// textViewDidBeginEditing
- (void)onInput:(BAInputHelper *)helper didBeginEditing:(UITextView *)textView;

- (void)onInputDidEndEditing:(BAInputHelper *)inputHelper;

- (void)onInputDidChange:(BAInputHelper *)inputHelper;

- (BOOL)onInput:(BAInputHelper *)helper shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;

@end

typedef NS_ENUM (NSUInteger, PPKeyboardType) {
    PPKeyboardTypeNone = 0,
    PPKeyboardTypeSystem,
    PPKeyboardTypeSticker,
};


@protocol BAInputModeDelegate <NSObject>

- (void)inputModeSwitchTo:(PPKeyboardType)type;

@end

@interface BAInputHelper : NSObject <PPStickerKeyboardDelegate>

+ (instancetype)withInputView:(UIView *)inputView delegate:(id<BAInputHelperDelegate>)delegate;

@property (nonatomic, weak) id<BAInputModeDelegate> inputModeDelegate;

@property (nonatomic, assign) BOOL isEditing;


// ================= 获取输入内容

// 小表情
@property (nonatomic, strong, readonly) NSString *plainText;

// 大表情
@property (nonatomic, nullable, strong) UIImage *sendImage;
@property (nonatomic, nullable, strong) BAAnimatedImage *sendAnimated;


// 临时写法

@property (nonatomic, strong) PPStickerKeyboard *stickerKeyboard;
@property (nonatomic, strong) PPStickerTextView *textView;

- (void)refreshTextUI;

- (void)clearText;

- (CGFloat)heightThatFits;

@property (nonatomic, assign, readonly) PPKeyboardType keyboardType;

- (void)changeKeyboardTo:(PPKeyboardType)type;


@end

NS_ASSUME_NONNULL_END
