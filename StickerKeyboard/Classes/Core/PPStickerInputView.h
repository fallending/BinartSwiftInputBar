//
//  PPStickerTextView.h
//  PPStickerKeyboard
//
//  Created by Vernon on 2018/1/17.
//  Copyright © 2018年 Vernon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BAInputHelper.h"

@class BAAnimatedImage;
@class PPStickerInputView;

@interface PPStickerInputView : UIView

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<BAInputHelperDelegate>)delegate;

@property (nonatomic, strong) BAInputHelper *textViewHelper;

@end
