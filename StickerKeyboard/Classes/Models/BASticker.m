//
//  BASticker.m
//  PPStickerKeyboard
//
//  Created by Vernon on 2018/1/14.
//  Copyright © 2018年 Vernon. All rights reserved.
//

#import "BASticker.h"
#import "BAStickerBundle.h"

@implementation BASticker

- (id)asPreview {
    NSData *imageData = [self.stickerBundle stickerData:self.animate];
    return [BAAnimatedImage animatedImageWithGIFData:imageData];
}

- (BOOL)isAnimated {
    return !!self.animate;
}

@end
