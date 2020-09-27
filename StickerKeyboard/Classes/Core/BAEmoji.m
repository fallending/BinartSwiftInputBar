//
//  BAEmoji.m
//  BinartOCStickerKeyboard
//
//  Created by Seven on 2020/8/25.
//

#import "BAEmoji.h"
#import "BAStickerBundle.h"

@implementation BAEmoji

- (id)asImage {
    return [self.stickerBundle emojiImage:self.image];
}

- (id)asPreview {
    return [self.stickerBundle emojiImage:self.image];
}

- (BOOL)isEmoji {
    return self.stickerBundle.isEmoji;
}

- (BOOL)isAnimated {
    return NO;
}

@end
