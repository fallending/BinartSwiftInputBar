//
//  PPStickerTextView.m
//  PPStickerKeyboard
//
//  Created by Vernon on 2018/1/17.
//  Copyright © 2018年 Vernon. All rights reserved.
//

#import "PPStickerInputView.h"
#import "PPStickerKeyboard.h"
#import "PPStickerTextView.h"
#import "BAExtensions.h"
#import "BAInputConfig.h"
#import "BAEmoji.h"
#import "BAInputHelper.h"

static CGFloat const PPStickerTextViewHeight = 44.0;

static CGFloat const PPStickerTextViewTextViewTopMargin = 10.0;
static CGFloat const PPStickerTextViewTextViewUnfocusLeftRightPadding = 5.0;
static CGFloat const PPStickerTextViewTextViewLeftRightPadding = 16.0;
static CGFloat const PPStickerTextViewTextViewBottomMargin = 10.0;
static NSUInteger const PPStickerTextViewMaxLineCount = 6;
static NSUInteger const PPStickerTextViewMinLineCount = 3;
static CGFloat const PPStickerTextViewLineSpacing = 5.0;
static CGFloat const PPStickerTextViewFontSize = 16.0;

static CGFloat const PPStickerTextViewEmojiToggleLength = 48.0;
static CGFloat const PPStickerTextViewToggleButtonLength = 24.0;

@interface PPStickerInputView () <UITextViewDelegate, BAInputModeDelegate>

@property (nonatomic, weak) id<BAInputHelperDelegate> delegate;

@property (nonatomic, strong) UIView *separatedLine;
@property (nonatomic, strong) PPButton *emojiToggleButton;
@property (nonatomic, strong) UIView *bottomBGView;     // 消除语音键盘的空隙

@end

@implementation PPStickerInputView

- (id)initWithFrame:(CGRect)frame delegate:(id<BAInputHelperDelegate>)delegate {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentMode = UIViewContentModeRedraw;
        self.exclusiveTouch = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.delegate = delegate;
        
        _textViewHelper = [BAInputHelper withInputView:self delegate:delegate];

        [self addSubview:_textViewHelper.textView];
        [self addSubview:self.separatedLine];
        [self addSubview:self.emojiToggleButton];
    }
    return self;
}

// 输入栏上面的分割线
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();

    [[UIColor pp_colorWithRGBString:@"#D2D2D2"] setStroke];

    CGContextSaveGState(context);
    CGContextSetLineWidth(context, PPOnePixelToPoint(1.f));
    CGContextMoveToPoint(context, 0, PPOnePixelToPoint(1.f) / 2);
    CGContextAddLineToPoint(context, CGRectGetMaxX(self.bounds), PPOnePixelToPoint(1.f) / 2);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (self.textViewHelper.isEditing) {
        self.separatedLine.frame = [self frameSeparatedLine];
        self.emojiToggleButton.frame = [self frameEmojiToggleButton];
    } else {
        self.separatedLine.frame = CGRectZero;
        self.emojiToggleButton.frame = CGRectZero;
    }

    [self.textViewHelper refreshTextUI];
}

//- (CGSize)sizeThatFits:(CGSize)size {
//    return CGSizeMake(size.width, [self heightThatFits]);
//}

//- (void)sizeToFit {
//    CGSize size = [self sizeThatFits:self.bounds.size];
//    self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMaxY(self.frame) - size.height, size.width, size.height);
//}

#pragma mark - public method

- (void)inputModeSwitchTo:(PPKeyboardType)type {
    switch (type) {
        case PPKeyboardTypeNone:
            [self.emojiToggleButton setImage:BAInputConfig.shared.toggleEmoji forState:UIControlStateNormal];
//            self.textView.inputView = nil;
            break;
        case PPKeyboardTypeSystem:
            [self.emojiToggleButton setImage:BAInputConfig.shared.toggleEmoji forState:UIControlStateNormal];
//            self.textView.inputView = nil;                          // 切换到系统键盘
//            [self.textView reloadInputViews];                       // 调用reloadInputViews方法会立刻进行键盘的切换
            break;
        case PPKeyboardTypeSticker:
            [self.emojiToggleButton setImage:BAInputConfig.shared.toggleKeyboard forState:UIControlStateNormal];
//            self.textView.inputView = self.stickerKeyboard;         // 切换到自定义的表情键盘
//            [self.textView reloadInputViews];
            break;
        default:
            break;
    }
}

#pragma mark - getter / setter

- (UIView *)separatedLine {
    if (!_separatedLine) {
        _separatedLine = [[UIView alloc]init];
        _separatedLine.backgroundColor = [UIColor pp_colorWithRGBString:@"#DEDEDE"];
    }
    return _separatedLine;
}

- (PPButton *)emojiToggleButton {
    if (!_emojiToggleButton) {
        _emojiToggleButton = [[PPButton alloc] init];
        [_emojiToggleButton setImage:BAInputConfig.shared.toggleEmoji forState:UIControlStateNormal];
        _emojiToggleButton.touchInsets = UIEdgeInsetsMake(-12, -20, -12, -20);
        [_emojiToggleButton addTarget:self action:@selector(toggleKeyboardDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _emojiToggleButton;
}

- (UIView *)bottomBGView {
    if (!_bottomBGView) {
        _bottomBGView = [[UIView alloc] init];
        _bottomBGView.backgroundColor = [UIColor clearColor];
    }
    return _bottomBGView;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.bottomBGView.frame = CGRectMake(0, CGRectGetMaxY(frame), CGRectGetWidth(self.bounds), UIScreen.mainScreen.bounds.size.height - CGRectGetMaxY(frame));
}

#pragma mark - private method

- (void)toggleKeyboardDidClick:(id)sender {
    [self.textViewHelper changeKeyboardTo:(self.textViewHelper.keyboardType == PPKeyboardTypeSystem ? PPKeyboardTypeSticker : PPKeyboardTypeSystem)];
}

- (CGFloat)heightWithLine:(NSInteger)lineNumber {
    NSString *onelineStr = [[NSString alloc] init];
    CGRect onelineRect = [onelineStr boundingRectWithSize:CGSizeMake(_textViewHelper.textView.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:PPStickerTextViewFontSize] } context:nil];
    CGFloat heigth = lineNumber * onelineRect.size.height + (lineNumber - 1) * PPStickerTextViewLineSpacing;
    return heigth;
}

- (CGRect)frameSeparatedLine {
    return CGRectMake(0, CGRectGetHeight(self.bounds) - PPStickerTextViewEmojiToggleLength, self.bounds.size.width, PPOnePixelToPoint(1.f));
}

- (CGRect)frameEmojiToggleButton {
    return CGRectMake(PPStickerTextViewTextViewLeftRightPadding, CGRectGetHeight(self.bounds) - (PPStickerTextViewEmojiToggleLength + PPStickerTextViewToggleButtonLength) / 2, PPStickerTextViewToggleButtonLength, PPStickerTextViewToggleButtonLength);
}

//// MARK: - UITextView Helper
//
//- (void)refreshTextUI {
//    if (!self.textView.text.length) {
//        return;
//    }
//
//    UITextRange *markedTextRange = [self.textView markedTextRange];
//    UITextPosition *position = [self.textView positionFromPosition:markedTextRange.start offset:0];
//    if (position) {
//        return;     // 正处于输入拼音还未点确定的中间状态
//    }
//
//    NSRange selectedRange = self.textView.selectedRange;
//
//    NSMutableAttributedString *attributedComment = [[NSMutableAttributedString alloc] initWithString:self.plainText attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:PPStickerTextViewFontSize], NSForegroundColorAttributeName: [UIColor pp_colorWithRGBString:@"#3B3B3B"] }];
//
//    // 匹配表情
//    [BAInputConfig.shared replaceEmojiForAttributedString:attributedComment font:[UIFont systemFontOfSize:PPStickerTextViewFontSize]];
//
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.lineSpacing = PPStickerTextViewLineSpacing;
//    [attributedComment addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:attributedComment.pp_rangeOfAll];
//
//    NSUInteger offset = self.textView.attributedText.length - attributedComment.length;
//    self.textView.attributedText = attributedComment;
//    self.textView.selectedRange = NSMakeRange(selectedRange.location - offset, 0);
//}

// MARK: - UITextView

//- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
//    self.keepsPreModeTextViewWillEdited = NO;
//    [self.inputView changeKeyboardTo:PPKeyboardTypeSystem];
//
//    if ([self.delegate respondsToSelector:@selector(stickerInputViewShouldBeginEditing:)]) {
//        return [self.delegate stickerInputViewShouldBeginEditing:self];
//    } else {
//        return YES;
//    }
//}
//
//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//    if ([@"\n" isEqualToString:text]) {
//        if (self.delegate && [self.delegate respondsToSelector:@selector(stickerInputViewDidClickSendButton:)]) {
//            [self.delegate stickerInputViewDidClickSendButton:self];
//        }
//        return NO;
//    }
//
//    return YES;
//}
//
//- (void)textViewDidEndEditing:(UITextView *)textView {
//    self.keepsPreModeTextViewWillEdited = YES;
//    CGRect inputViewFrame = self.frame;
//    CGFloat textViewHeight = [self heightThatFits];
//    inputViewFrame.origin.y = CGRectGetHeight(self.superview.bounds) - textViewHeight - PP_SAFEAREAINSETS(self.superview).bottom;
//    inputViewFrame.size.height = textViewHeight;
//    self.frame = inputViewFrame;
//
//    if ([self.delegate respondsToSelector:@selector(stickerInputViewDidEndEditing:)]) {
//        [self.delegate stickerInputViewDidEndEditing:self];
//    }
//}
//
//- (void)textViewDidChange:(UITextView *)textView {
//    [self refreshTextUI];
//
//    CGSize size = [self sizeThatFits:self.bounds.size];
//    CGRect newFrame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMaxY(self.frame) - size.height, size.width, size.height);
//    [self setFrame:newFrame animated:YES];
//
//    if (!self.keepsPreModeTextViewWillEdited) {
//        self.textView.frame = [self frameTextView];
//    }
//    [self.textView scrollRangeToVisible:self.textView.selectedRange];
//
//
//    if ([self.delegate respondsToSelector:@selector(stickerInputViewDidChange:)]) {
//        [self.delegate stickerInputViewDidChange:self];
//    }
//
//    // 通知keyboard文本变化了
//    [_stickerKeyboard notifyInputChanged:textView.text];
//}
//
//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
//    if ([self.textView isFirstResponder]) {
//        return YES;
//    }
//    return [super pointInside:point withEvent:event];
//}
//
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    UITouch *touch = [touches anyObject];
//    CGPoint touchPoint = [touch locationInView:self];
//    if (!CGRectContainsPoint(self.bounds, touchPoint)) {
//        if ([self isFirstResponder]) {
//            [self resignFirstResponder];
//        }
//    } else {
//        [super touchesBegan:touches withEvent:event];
//    }
//}
//
//- (BOOL)isFirstResponder {
//    return [self.textView isFirstResponder];
//}
//
//- (BOOL)resignFirstResponder {
//    [super resignFirstResponder];
//    self.keepsPreModeTextViewWillEdited = YES;
//    [self changeKeyboardTo:PPKeyboardTypeNone];
//    [self setNeedsLayout];
//    return [self.textView resignFirstResponder];
//}

//#pragma mark - Keyboard
//
//// FIXME: 这个似乎可以解决InputBar那边，类似微信的输入栏，切换顺滑的体验
//- (void)keyboardWillShow:(NSNotification *)notification {
//    if (!self.superview) {
//        return;
//    }
//
//    if (!self.bottomBGView.superview) {
//        [self.superview insertSubview:self.bottomBGView belowSubview:self];
//    }
//
//    NSDictionary *userInfo = [notification userInfo];
//    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    CGRect inputViewFrame = self.frame;
//    CGFloat textViewHeight = [self heightThatFits];
//    inputViewFrame.origin.y = CGRectGetHeight(self.superview.bounds) - CGRectGetHeight(keyboardFrame) - textViewHeight;
//    inputViewFrame.size.height = textViewHeight;
//
//    [UIView animateWithDuration:duration animations:^{
//        self.frame = inputViewFrame;
//    }];
//}
//
//- (void)keyboardWillHide:(NSNotification *)notification {
//    if (!self.superview) {
//        return;
//    }
//
//    if (self.bottomBGView.superview) {
//        [self.bottomBGView removeFromSuperview];
//    }
//
//    NSDictionary *userInfo = [notification userInfo];
//    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    CGRect inputViewFrame = self.frame;
//    CGFloat textViewHeight = [self heightThatFits];
//    inputViewFrame.origin.y = CGRectGetHeight(self.superview.bounds) - textViewHeight - PP_SAFEAREAINSETS(self.superview).bottom;
//    inputViewFrame.size.height = textViewHeight;
//
//    [UIView animateWithDuration:duration animations:^{
//        self.frame = inputViewFrame;
//    }];
//}

@end
