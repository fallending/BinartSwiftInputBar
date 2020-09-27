//
//  BAEmoji.h
//  BinartOCStickerKeyboard
//
//  Created by Seven on 2020/8/25.
//

#import <Foundation/Foundation.h>

/// 可以入输入框的emoji

@class BAStickerBundle;

NS_ASSUME_NONNULL_BEGIN

@interface BAEmoji : NSObject

@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *url;

// MARK: = 抽象方法

@property (nonatomic, readonly) id asImage; // UIImage or BAAnimatedImage
@property (nonatomic, readonly) id asPreview; // UIImage or BAAnimatedImage

// MARK: = 工具属性

@property (nonatomic, weak) BAStickerBundle *stickerBundle;
@property (nonatomic, readonly) BOOL isEmoji; // 是否是emoji：为了回调
@property (nonatomic, readonly) BOOL isAnimated; // 是否是动态图：为了预览

@end

NS_ASSUME_NONNULL_END
