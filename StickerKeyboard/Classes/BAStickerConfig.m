//
//  BAStickerKeyboardConfig.m
//  PPStickerKeyboard
//
//  Created by Seven on 2020/8/22.
//  Copyright © 2020 Vernon. All rights reserved.
//

#import "BAStickerConfig.h"

// MARK: -

@interface PPStickerMatchingResult : NSObject

@property (nonatomic, assign) NSRange range;                    // 匹配到的表情包文本的range
@property (nonatomic, strong) UIImage *emojiImage;              // 如果能在本地找到emoji的图片，则此值不为空
@property (nonatomic, strong) NSString *showingDescription;     // 表情的实际文本(形如：[哈哈])，不为空
@end

@implementation PPStickerMatchingResult
@end

// MARK: -

@interface BAStickerConfig () {
    NSBundle *_defaultBundle;
}

@property (nonatomic, strong, readwrite) NSArray<BAStickerBundle *> *allStickers;
@end

@implementation BAStickerConfig
@dynamic shared;

+ (BAStickerConfig *)shared {
    static dispatch_once_t onceToken;
    static __strong id __singleton__ = nil;
    dispatch_once(&onceToken, ^{
        __singleton__ = [BAStickerConfig new];
    });
    return __singleton__;
}

- (instancetype)init {
    if (self = [super init]) {
        _defaultBundle = NSBundle.mainBundle;
        
    }
    
    return self;
}

- (void)config {
    NSAssert(self.configFile != nil, @"配置文件为空");
    
    NSArray *fileNameSplits = [self.configFile componentsSeparatedByString:@"."];
    
    NSAssert(fileNameSplits.count==2, @"配置文件出错");
    
    NSString *path = [_defaultBundle pathForResource:fileNameSplits.firstObject ofType:fileNameSplits.lastObject];
    if (!path) {
        // main bundle 如果没有的话，尝试从 私有framework中读取
        NSBundle *bundle = [NSBundle bundleForClass:self.class];
        
        path = [bundle pathForResource:fileNameSplits.firstObject ofType:fileNameSplits.lastObject];
        
        if (path) {
            _defaultBundle = bundle;
        } else {
            return;
        }
    }

    NSArray *array = [[NSArray alloc] initWithContentsOfFile:path];
    NSMutableArray<BAStickerBundle *> *stickers = [[NSMutableArray alloc] init];
    for (NSDictionary *stickerDict in array) {
        BAStickerBundle *stickerBundle = [BAStickerBundle new];
        
        if (![stickerDict.allKeys containsObject:BAStickerBundleKey]) continue;
        if (![stickerDict.allKeys containsObject:BAStickerIDKey]) continue;
        if (![stickerDict.allKeys containsObject:BAStickerVersionKey]) continue;
        if (![stickerDict.allKeys containsObject:BAStickerCoverKey]) continue;
        if (![stickerDict.allKeys containsObject:BAStickerTypeKey]) continue;
        if (![stickerDict.allKeys containsObject:BAStickerDataKey]) continue;
        if (![stickerDict.allKeys containsObject:BAStickerCoverURLKey]) continue;
        
        NSString *bundleName = stickerDict[BAStickerBundleKey];
        
        stickerBundle.bundleName = bundleName;
        stickerBundle.id = [stickerDict[BAStickerIDKey] longLongValue];
        stickerBundle.version = [stickerDict[BAStickerVersionKey] longLongValue];
        stickerBundle.bundle = [NSBundle bundleWithPath:[_defaultBundle pathForResource:bundleName ofType:@"bundle"]];
        stickerBundle.cover = stickerDict[BAStickerCoverKey];
        stickerBundle.coverUrl = stickerDict[BAStickerCoverURLKey];
        stickerBundle.type = stickerDict[BAStickerTypeKey];
        
        NSArray *emojiArr = stickerDict[BAStickerDataKey];
        NSMutableArray<BAEmoji *> *emojis = [@[] mutableCopy];
        for (NSDictionary *emojiDict in emojiArr) {
            BAEmoji *emoji = nil;
            
            if (stickerBundle.isEmoji) {
                emoji = [BAEmoji new];
            } else {
                BASticker *sticker = [BASticker new];
                
                // 是否是动态表情
                if ([emojiDict.allKeys containsObject:BAStickerAnimateKey]) {
                    sticker.animate = emojiDict[BAStickerAnimateKey];
                }
                
                emoji = sticker;
            }
            
            emoji.image = emojiDict[BAStickerImageKey];
            emoji.desc = emojiDict[BAStickerDescKey];
            emoji.url = emojiDict[BAStickerURLKey];
            
            emoji.stickerBundle = stickerBundle;
            
            [emojis addObject:emoji];
        }
        
        stickerBundle.data = emojis;
        
        [stickers addObject:stickerBundle];
    }
    self.allStickers = stickers;
}

#pragma mark - public method

- (void)replaceEmojiForAttributedString:(NSMutableAttributedString *)attributedString font:(UIFont *)font {
    if (!attributedString || !attributedString.length || !font) {
        return;
    }

    NSArray<PPStickerMatchingResult *> *matchingResults = [self matchingEmojiForString:attributedString.string];

    if (matchingResults && matchingResults.count) {
        NSUInteger offset = 0;
        for (PPStickerMatchingResult *result in matchingResults) {
            if (result.emojiImage) {
                CGFloat emojiHeight = font.lineHeight;
                NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
                attachment.image = result.emojiImage;
                attachment.bounds = CGRectMake(0, font.descender, emojiHeight, emojiHeight);
                NSMutableAttributedString *emojiAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:[NSAttributedString attributedStringWithAttachment:attachment]];
                [emojiAttributedString pp_setTextBackedString:[PPTextBackedString stringWithString:result.showingDescription] range:NSMakeRange(0, emojiAttributedString.length)];
                if (!emojiAttributedString) {
                    continue;
                }
                NSRange actualRange = NSMakeRange(result.range.location - offset, result.showingDescription.length);
                [attributedString replaceCharactersInRange:actualRange withAttributedString:emojiAttributedString];
                offset += result.showingDescription.length - emojiAttributedString.length;
            }
        }
    }
}

#pragma mark - private method

- (NSArray<PPStickerMatchingResult *> *)matchingEmojiForString:(NSString *)string {
    if (!string.length) {
        return nil;
    }
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\[.+?\\]" options:0 error:NULL];
    NSArray<NSTextCheckingResult *> *results = [regex matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    if (results && results.count) {
        NSMutableArray *emojiMatchingResults = [[NSMutableArray alloc] init];
        for (NSTextCheckingResult *result in results) {
            NSString *showingDescription = [string substringWithRange:result.range];
            NSString *emojiSubString = [showingDescription substringFromIndex:1];       // 去掉[
            emojiSubString = [emojiSubString substringWithRange:NSMakeRange(0, emojiSubString.length - 1)];    // 去掉]
            BAEmoji *emoji = [self emojiWithEmojiDescription:emojiSubString];
            if (emoji) {
                PPStickerMatchingResult *emojiMatchingResult = [[PPStickerMatchingResult alloc] init];
                emojiMatchingResult.range = result.range;
                emojiMatchingResult.showingDescription = showingDescription;
                emojiMatchingResult.emojiImage = emoji.asImage;
                [emojiMatchingResults addObject:emojiMatchingResult];
            }
        }
        return emojiMatchingResults;
    }
    return nil;
}

- (BAEmoji *)emojiWithEmojiDescription:(NSString *)emojiDescription {
    for (BAStickerBundle *stickerBundle in self.allStickers) {
        for (BAEmoji *emoji in stickerBundle.data) {
            if ([emoji.desc isEqualToString:emojiDescription]) {
                return emoji;
            }
        }
    }
    return nil;
}

@end
