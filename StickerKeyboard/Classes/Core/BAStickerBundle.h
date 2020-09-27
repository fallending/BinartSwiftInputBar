//
//  BAStickerBundle.h
//  BinartOCStickerKeyboard
//
//  Created by Seven on 2020/8/24.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class BAEmoji; // BASticker inherits from BAEmoji

// TODO: 需要支持多语言！！！！！！！！ @fallenink @fengzilijie@qq.com
// TODO: 宽高信息？

NS_ASSUME_NONNULL_BEGIN

@interface BAStickerBundle : NSObject

// MARK: = 表情包 头部 字段

#define BAStickerIDKey          @"id"
#define BAStickerVersionKey     @"version"
#define BAStickerNameKey        @"name"
#define BAStickerTypeKey        @"type"
#define BAStickerBundleKey      @"bundle"

#define BAStickerTypeSticker    @"sticker"
#define BAStickerTypeEmoji      @"emoji"

@property (nonatomic, assign) int64_t id;
@property (nonatomic, assign) int64_t version;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) NSString *bundleName;

// MARK: = 表情包 预览数据

#define BAStickerCoverKey       @"cover"
#define BAStickerCoverURLKey    @"url"

@property (nonatomic, copy) NSString *cover;
@property (nonatomic, readonly) UIImage *coverImage;
@property (nonatomic, copy) NSString *coverUrl;

// MARK: = 表情包 表情数据

#define BAStickerDataKey        @"data"

#define BAStickerImageKey       @"image"
#define BAStickerAnimateKey     @"animate"
#define BAStickerDescKey        @"desc"
#define BAStickerURLKey         @"url"

@property (nonatomic, strong) NSArray<BAEmoji *> *data;

// MARK: = 辅助属性、方法

@property (nonatomic, strong) NSBundle *bundle;
@property (nonatomic, readonly) BOOL isEmoji; // emoji or sticker

- (UIImage *)emojiImage:(NSString *)imageName;
- (NSData *)stickerData:(NSString *)animateName;

@end

NS_ASSUME_NONNULL_END
