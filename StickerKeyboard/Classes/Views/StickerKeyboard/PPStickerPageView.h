//
//  PPStickerPageView.h
//  PPStickerKeyboard
//
//  Created by Vernon on 2018/1/15.
//  Copyright © 2018年 Vernon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BAExtensions.h"

@class PPStickerPageView;
@class BAStickerBundle;
@class BASticker;

extern NSUInteger const PPStickerPageViewMaxEmojiCount;

@protocol PPStickerPageViewDelegate <NSObject>

- (void)stickerPageView:(PPStickerPageView *)stickerPageView didClickEmoji:(BASticker *)emoji;
- (void)stickerPageView:(PPStickerPageView *)stickerKeyboard showEmojiPreviewViewWithEmoji:(BASticker *)emoji buttonFrame:(CGRect)buttonFrame;
- (void)stickerPageViewHideEmojiPreviewView:(PPStickerPageView *)stickerKeyboard;

@end

@interface PPStickerPageView : UIView <PPReusablePage>

@property (nonatomic, weak) id<PPStickerPageViewDelegate> delegate;
@property (nonatomic, assign) NSUInteger pageIndex;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

- (void)configureWithSticker:(BAStickerBundle *)sticker;

@end
