//
//  PPEmojiPreviewView.m
//  PPStickerKeyboard
//
//  Created by Vernon on 2018/1/14.
//  Copyright © 2018年 Vernon. All rights reserved.
//

#import "PPEmojiPreviewView.h"
#import "BASticker.h"
#import "PPUtil.h"
#import "BAStickerConfig.h"
#import "BAAnimatedImage.h"
#import "BAAnimatedImageView.h"

static CGFloat PPEmojiPreviewImageTopPadding = 18.0;
static CGFloat PPEmojiPreviewImageLeftRightPadding = 22.0;
static CGFloat PPEmojiPreviewImageLength = 48.0;
static CGFloat PPEmojiPreviewImageBottomMargin = 2.0;
static CGFloat PPEmojiPreviewTextMaxWidth = 60.0;
static CGFloat PPEmojiPreviewTextHeight = 13.0;

@interface PPEmojiPreviewView ()

@property (nonatomic, strong) UIImageView *emojiImageView;
@property (nonatomic, strong) BAAnimatedImageView *emojiAnimatedImageView;

@property (nonatomic, strong) UILabel *descriptionLabel;

@end

@implementation PPEmojiPreviewView

- (instancetype)init {
    if (self = [super init]) {
        self.image = BAStickerConfig.shared.previewImage;
        [self addSubview:self.emojiAnimatedImageView];
        [self addSubview:self.emojiImageView];
        [self addSubview:self.descriptionLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (!self.emoji) {
        return;
    }
    
    
    UIView *topElement = nil;
    
    if (self.emoji.isAnimated) {
        self.emojiImageView.hidden = YES;
        self.emojiAnimatedImageView.hidden = NO;
        
        self.emojiAnimatedImageView.animatedImage = (BAAnimatedImage *)self.emoji.asPreview;
        self.emojiAnimatedImageView.frame = CGRectMake(PPEmojiPreviewImageLeftRightPadding, PPEmojiPreviewImageTopPadding, PPEmojiPreviewImageLength, PPEmojiPreviewImageLength);
        
        topElement = self.emojiAnimatedImageView;
    } else {
        self.emojiImageView.hidden = NO;
        self.emojiAnimatedImageView.hidden = YES;
        
        self.emojiImageView.image = self.emoji.asPreview;
        self.emojiImageView.frame = CGRectMake(PPEmojiPreviewImageLeftRightPadding, PPEmojiPreviewImageTopPadding, PPEmojiPreviewImageLength, PPEmojiPreviewImageLength);
        
        topElement = self.emojiImageView;
    }
    
    self.descriptionLabel.text = self.emoji.desc;
    CGSize labelSize = [self.descriptionLabel textRectForBounds:CGRectMake(0, 0, PPEmojiPreviewTextMaxWidth, PPEmojiPreviewTextHeight) limitedToNumberOfLines:1].size;
    self.descriptionLabel.frame = CGRectMake((CGRectGetWidth(self.bounds) - labelSize.width) / 2, CGRectGetMaxY(topElement.frame) + PPEmojiPreviewImageBottomMargin, labelSize.width, labelSize.height);
}

- (void)setEmoji:(BASticker *)emoji {
    if (_emoji != emoji) {
        _emoji = emoji;
        [self setNeedsLayout];
    }
}

- (UIImageView *)emojiImageView {
    if (!_emojiImageView) {
        _emojiImageView = [[UIImageView alloc] init];
    }
    return _emojiImageView;
}


- (UIImageView *)emojiAnimatedImageView {
    if (!_emojiAnimatedImageView) {
        _emojiAnimatedImageView = [[BAAnimatedImageView alloc] init];
    }
    return _emojiAnimatedImageView;
}


- (UILabel *)descriptionLabel {
    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc] init];
        _descriptionLabel.font = [UIFont systemFontOfSize:11.0];
        _descriptionLabel.textColor = [UIColor pp_colorWithRGBString:@"#4A4A4A"];
        _descriptionLabel.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return _descriptionLabel;
}

@end
