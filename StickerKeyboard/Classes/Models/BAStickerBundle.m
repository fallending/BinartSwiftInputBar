//
//  BAStickerBundle.m
//  BinartOCStickerKeyboard
//
//  Created by Seven on 2020/8/24.
//

#import "BAStickerBundle.h"
#import "BASticker.h"

@implementation BAStickerBundle

- (UIImage *)coverImage {
    
    // 优先获取：如果为空则获取 name@3x
    NSString *newImageName = [NSString stringWithFormat:@"%@@3x", self.cover];
    UIImage *image = [UIImage imageWithContentsOfFile:[self.bundle pathForResource:newImageName ofType:@"png"]];
    
    // 其次获取：如果为空则获取 name@2x
    if (!image) {
        newImageName = [NSString stringWithFormat:@"%@@2x", self.cover];
        image = [UIImage imageWithContentsOfFile:[self.bundle pathForResource:newImageName ofType:@"png"]];
    }

    // 最后：默认获取 name
    if (!image) {
        image = [UIImage imageWithContentsOfFile:[self.bundle pathForResource:self.cover ofType:@"png"]];
    }
    
    return image;
}


- (BOOL)isEmoji {
//    if (self.data && self.data.count > 0) {
//        id emojiLike = self.data.firstObject;
//
//        if ([emojiLike isKindOfClass:BASticker.class]) {
//            return false;
//        } else {
//            return true;
//        }
//    }
//
//    return false;
    
    return [self.type isEqualToString:BAStickerTypeEmoji];
}

- (UIImage *)emojiImage:(NSString *)imageName {
    // 优先获取：如果为空则获取 name@3x
    NSString *newImageName = [NSString stringWithFormat:@"%@@3x", imageName];
    UIImage *image = [UIImage imageWithContentsOfFile:[self.bundle pathForResource:newImageName ofType:@"png"]];
    
    // 其次获取：如果为空则获取 name@2x
    if (!image) {
        newImageName = [NSString stringWithFormat:@"%@@2x", imageName];
        image = [UIImage imageWithContentsOfFile:[self.bundle pathForResource:newImageName ofType:@"png"]];
    }

    // 最后：默认获取 name
    if (!image) {
        image = [UIImage imageWithContentsOfFile:[self.bundle pathForResource:imageName ofType:@"png"]];
    }
    
    return image;
}

- (NSData *)stickerData:(NSString *)animateName {
    return [NSData dataWithContentsOfFile:[self.bundle pathForResource:animateName ofType:@"gif"]];
}

@end
