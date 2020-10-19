//
//  BAInputTextViewHelper.m
//  BinartOCStickerKeyboard
//
//  Created by Seven on 2020/10/13.
//

#import "BAInputHelper.h"
#import "BAInputConfig.h"
#import "PPStickerTextView.h"

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
__unused static CGFloat const PPStickerTextViewToggleButtonLength = 24.0;

@interface BAInputHelper () <UITextViewDelegate>

@property (nonatomic, weak) UIView *inputView;
@property (nonatomic, weak) id<BAInputHelperDelegate> delegate;

@property (nonatomic, assign, readwrite) PPKeyboardType keyboardType;

@end

@implementation BAInputHelper

+ (instancetype)withInputView:(UIView *)inputView delegate:(id<BAInputHelperDelegate>)delegate {
    BAInputHelper *helper = [BAInputHelper new];
    
    helper.inputView = inputView;
    helper.keyboardType = PPKeyboardTypeSystem;
    
    helper.textView = [[PPStickerTextView alloc] initWithFrame:[helper frameTextView]];
    helper.textView.delegate = helper;
    helper.textView.backgroundColor = [UIColor clearColor];
    helper.textView.font = [UIFont systemFontOfSize:PPStickerTextViewFontSize];
    helper.textView.scrollsToTop = NO;
    helper.textView.returnKeyType = UIReturnKeySend;
    helper.textView.enablesReturnKeyAutomatically = YES;
    helper.textView.placeholder = @"";
    helper.textView.placeholderColor = [UIColor pp_colorWithRGBString:@"#B4B4B4"];
    helper.textView.textContainerInset = UIEdgeInsetsZero;
    if (@available(iOS 11.0, *)) {
        helper.textView.textDragInteraction.enabled = NO;
    }

    helper.delegate = delegate;
    helper.isEditing = NO;
    
    return helper;
}

- (CGRect)frameTextView {
    CGFloat minX = (self.textView.isFirstResponder ? PPStickerTextViewTextViewLeftRightPadding : PPStickerTextViewTextViewUnfocusLeftRightPadding);
    CGFloat width = self.inputView.bounds.size.width - (2 * minX);

    CGFloat height = 0;
    if (!self.isEditing) {
        height = CGRectGetHeight(self.inputView.bounds) - 2 * PPStickerTextViewTextViewTopMargin;
    } else {
        height = CGRectGetHeight(self.inputView.bounds) - PPStickerTextViewTextViewTopMargin - PPStickerTextViewTextViewBottomMargin - PPStickerTextViewEmojiToggleLength;
    }
    if (height < 0) {
        height = self.inputView.bounds.size.height;
    }

    return CGRectMake(minX, PPStickerTextViewTextViewTopMargin, width, height);
}

- (instancetype)init {
    if (self = [super init]) {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// MARK: - Public

- (void)clearText {
    self.textView.text = nil;
    self.textView.font = [UIFont systemFontOfSize:PPStickerTextViewFontSize];
    
//    [self sizeToFit];
    
    [_stickerKeyboard notifyInputChanged:nil];
}


- (void)changeKeyboardTo:(PPKeyboardType)type {
    if (self.keyboardType == type) {
        return;
    }

    switch (type) {
        case PPKeyboardTypeNone:
            self.textView.inputView = nil;
            break;
        case PPKeyboardTypeSystem:
            self.textView.inputView = nil;                          // 切换到系统键盘
            [self.textView reloadInputViews];                       // 调用reloadInputViews方法会立刻进行键盘的切换
            break;
        case PPKeyboardTypeSticker:
            self.textView.inputView = self.stickerKeyboard;         // 切换到自定义的表情键盘
            [self.textView reloadInputViews];
            break;
        default:
            break;
    }

    self.keyboardType = type;
    
    [self.inputModeDelegate inputModeSwitchTo:type];
}

// MARK: - Notification Handler

- (CGFloat)heightWithLine:(NSInteger)lineNumber {
    NSString *onelineStr = [[NSString alloc] init];
    CGRect onelineRect = [onelineStr boundingRectWithSize:CGSizeMake(self.textView.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:PPStickerTextViewFontSize] } context:nil];
    CGFloat heigth = lineNumber * onelineRect.size.height + (lineNumber - 1) * PPStickerTextViewLineSpacing;
    return heigth;
}

- (CGFloat)heightThatFits {
    if (!self.isEditing) {
        return PPStickerTextViewHeight;
    } else {
        CGFloat textViewHeight = [self.textView.layoutManager usedRectForTextContainer:self.textView.textContainer].size.height;
        CGFloat minHeight = [self heightWithLine:PPStickerTextViewMinLineCount];
        CGFloat maxHeight = [self heightWithLine:PPStickerTextViewMaxLineCount];
        CGFloat calculateHeight = MIN(maxHeight, MAX(minHeight, textViewHeight));
        CGFloat height = PPStickerTextViewTextViewTopMargin + calculateHeight + PPStickerTextViewTextViewBottomMargin + PPStickerTextViewEmojiToggleLength;
        return height;
    }
}

// FIXME: 这个似乎可以解决InputBar那边，类似微信的输入栏，切换顺滑的体验
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect inputViewFrame = self.inputView.frame;
    CGFloat textViewHeight = [self heightThatFits];
    inputViewFrame.origin.y = CGRectGetHeight(self.inputView.superview.bounds) - CGRectGetHeight(keyboardFrame) - textViewHeight;
    inputViewFrame.size.height = textViewHeight;

    [UIView animateWithDuration:duration animations:^{
        self.inputView.frame = inputViewFrame;
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    if (!self.inputView.superview) {
        return;
    }
    
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect inputViewFrame = self.inputView.frame;
    CGFloat textViewHeight = [self heightThatFits];
    inputViewFrame.origin.y = CGRectGetHeight(self.inputView.superview.bounds) - textViewHeight - PP_SAFEAREAINSETS(self.inputView.superview).bottom;
    inputViewFrame.size.height = textViewHeight;
    
    [UIView animateWithDuration:duration animations:^{
        self.inputView.frame = inputViewFrame;
    }];
}

// MARK: - Getter & Setter

- (NSString *)plainText {
    return [self.textView.attributedText pp_plainTextForRange:NSMakeRange(0, self.textView.attributedText.length)];
}


- (PPStickerKeyboard *)stickerKeyboard {
    if (!_stickerKeyboard) {
        _stickerKeyboard = [[PPStickerKeyboard alloc] init];
        _stickerKeyboard.frame = CGRectMake(0, 0, CGRectGetWidth(self.inputView.bounds), [self.stickerKeyboard heightThatFits]);
        _stickerKeyboard.delegate = self;
        
        // 通知keyboard文本变化了
        [_stickerKeyboard notifyInputChanged:nil];
    }
    return _stickerKeyboard;
}

// MARK: -

- (void)refreshTextUI {
    // 李杰 新增
    self.textView.frame = [self frameTextView];
    // ----
    
    if (!self.textView.text.length) {
        return;
    }

    UITextRange *markedTextRange = [self.textView markedTextRange];
    UITextPosition *position = [self.textView positionFromPosition:markedTextRange.start offset:0];
    if (position) {
        return;     // 正处于输入拼音还未点确定的中间状态
    }

    NSRange selectedRange = self.textView.selectedRange;

    NSMutableAttributedString *attributedComment = [[NSMutableAttributedString alloc] initWithString:self.plainText attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:PPStickerTextViewFontSize], NSForegroundColorAttributeName: [UIColor pp_colorWithRGBString:@"#3B3B3B"] }];

    // 匹配表情
    [BAInputConfig.shared replaceEmojiForAttributedString:attributedComment font:[UIFont systemFontOfSize:PPStickerTextViewFontSize]];

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = PPStickerTextViewLineSpacing;
    [attributedComment addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:attributedComment.pp_rangeOfAll];

    NSUInteger offset = self.textView.attributedText.length - attributedComment.length;
    self.textView.attributedText = attributedComment;
    self.textView.selectedRange = NSMakeRange(selectedRange.location - offset, 0);
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(size.width, [self heightThatFits]);
}

- (void)set:(UIView *)view frame:(CGRect)frame animated:(BOOL)animated {
    if (CGRectEqualToRect(frame, view.frame)) {
        return;
    }

    void (^ changesAnimations)(void) = ^{
        [view setFrame:frame];
        [view setNeedsLayout];
    };

    if (changesAnimations) {
        if (animated) {
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:changesAnimations completion:nil];
        } else {
            changesAnimations();
        }
    }
}

// MARK: - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    self.isEditing = YES;
    
    [self changeKeyboardTo:PPKeyboardTypeSystem];

    if ([self.delegate respondsToSelector:@selector(onInputShouldBeginEditing:)]) {
        return [self.delegate onInputShouldBeginEditing:self];
    } else {
        return YES;
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(onInput:didBeginEditing:)]) {
        return [self.delegate onInput:self didBeginEditing:textView];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([@"\n" isEqualToString:text]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(onInput:sendText:)]) {
            [self.delegate onInput:self sendText:[self plainText]];
            
            [self.textView setAttributedText:nil];
            [self textViewDidChange:self.textView];
        }
        return NO;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onInput:shouldChangeTextInRange:replacementText:)]) {
        [self.delegate onInput:self shouldChangeTextInRange:range replacementText:text];
    }

    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.isEditing = NO;
    
//    CGRect inputViewFrame = self.inputView.frame;
//    CGFloat textViewHeight = [self heightThatFits];
//    inputViewFrame.origin.y = CGRectGetHeight(self.inputView.superview.bounds) - textViewHeight - PP_SAFEAREAINSETS(self.inputView.superview).bottom;
//    inputViewFrame.size.height = textViewHeight;
//    self.inputView.frame = inputViewFrame;

    if ([self.delegate respondsToSelector:@selector(onInputDidEndEditing:)]) {
        [self.delegate onInputDidEndEditing:self];
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    [self refreshTextUI];

    CGSize size = [self sizeThatFits:self.inputView.bounds.size];
    CGRect newFrame = CGRectMake(CGRectGetMinX(self.inputView.frame), CGRectGetMaxY(self.inputView.frame) - size.height, size.width, size.height);
//    [self set:self.inputView frame:newFrame animated:YES];

    if (self.isEditing) {
//        self.textView.frame = [self frameTextView];
    }
    
    [self.textView scrollRangeToVisible:self.textView.selectedRange];

    if ([self.delegate respondsToSelector:@selector(onInputDidChange:)]) {
        [self.delegate onInputDidChange:self];
    }

    // 通知keyboard文本变化了
    [_stickerKeyboard notifyInputChanged:textView.text];
}

//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
//    if ([self.textView isFirstResponder]) {
//        return YES;
//    }
//    return [super pointInside:point withEvent:event];
//}

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

- (BOOL)isFirstResponder {
    return [self.textView isFirstResponder];
}

- (BOOL)resignFirstResponder {
    [self.inputView resignFirstResponder];
    
    self.isEditing = NO;
    
    [self changeKeyboardTo:PPKeyboardTypeNone];
    
    [self.inputView setNeedsLayout];
    
    return [self.textView resignFirstResponder];
}

// MARK: - PPStickerKeyboardDelegate

- (void)on:(BAStickerBundle *)stickerBundle emojiClicked:(BAEmoji *)emoji {
    if (!emoji) {
        return;
    }
    
    UIImage *emojiImage = emoji.asImage;
    if (!emojiImage) {
        return;
    }

    NSRange selectedRange = self.textView.selectedRange;
    NSString *emojiString = [NSString stringWithFormat:@"[%@]", emoji.desc];
    NSMutableAttributedString *emojiAttributedString = [[NSMutableAttributedString alloc] initWithString:emojiString];
    [emojiAttributedString pp_setTextBackedString:[PPTextBackedString stringWithString:emojiString] range:emojiAttributedString.pp_rangeOfAll];

    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];
    [attributedText replaceCharactersInRange:selectedRange withAttributedString:emojiAttributedString];
    self.textView.attributedText = attributedText;
    self.textView.selectedRange = NSMakeRange(selectedRange.location + emojiAttributedString.length, 0);

    [self textViewDidChange:self.textView];
}

- (void)on:(BAStickerBundle *)stickerBundle stickerClicked:(BASticker *)sticker {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onInput:sendSticker:)]) {
        if (sticker.isAnimated) {
            self.sendAnimated = sticker.asPreview;
        } else {
            self.sendImage = sticker.asImage;
        }
        
        [self.delegate onInput:self sendSticker:sticker];
        
        self.sendImage = nil;
        self.sendAnimated = nil;
    }
}

- (void)onEmojiDelete {
    NSRange selectedRange = self.textView.selectedRange;
    if (selectedRange.location == 0 && selectedRange.length == 0) {
        return;
    }

    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];
    if (selectedRange.length > 0) {
        [attributedText deleteCharactersInRange:selectedRange];
        self.textView.attributedText = attributedText;
        self.textView.selectedRange = NSMakeRange(selectedRange.location, 0);
    } else {
        NSUInteger deleteCharactersCount = 1;
        
        // 下面这段正则匹配是用来匹配文本中的所有系统自带的 emoji 表情，以确认删除按钮将要删除的是否是 emoji。这个正则匹配可以匹配绝大部分的 emoji，得到该 emoji 的正确的 length 值；不过会将某些 combined emoji（如 👨‍👩‍👧‍👦 👨‍👩‍👧‍👦 👨‍👨‍👧‍👧），这种几个 emoji 拼在一起的 combined emoji 则会被匹配成几个个体，删除时会把 combine emoji 拆成个体。瑕不掩瑜，大部分情况下表现正确，至少也不会出现删除 emoji 时崩溃的问题了。
        NSString *emojiPattern1 = @"[\\u2600-\\u27BF\\U0001F300-\\U0001F77F\\U0001F900-\\U0001F9FF]";
        NSString *emojiPattern2 = @"[\\u2600-\\u27BF\\U0001F300-\\U0001F77F\\U0001F900–\\U0001F9FF]\\uFE0F";
        NSString *emojiPattern3 = @"[\\u2600-\\u27BF\\U0001F300-\\U0001F77F\\U0001F900–\\U0001F9FF][\\U0001F3FB-\\U0001F3FF]";
        NSString *emojiPattern4 = @"[\\rU0001F1E6-\\U0001F1FF][\\U0001F1E6-\\U0001F1FF]";
        NSString *pattern = [[NSString alloc] initWithFormat:@"%@|%@|%@|%@", emojiPattern4, emojiPattern3, emojiPattern2, emojiPattern1];
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:kNilOptions error:NULL];
        NSArray<NSTextCheckingResult *> *matches = [regex matchesInString:attributedText.string options:kNilOptions range:NSMakeRange(0, attributedText.string.length)];
        for (NSTextCheckingResult *match in matches) {
            if (match.range.location + match.range.length == selectedRange.location) {
                deleteCharactersCount = match.range.length;
                break;
            }
        }
        
        [attributedText deleteCharactersInRange:NSMakeRange(selectedRange.location - deleteCharactersCount, deleteCharactersCount)];
        self.textView.attributedText = attributedText;
        self.textView.selectedRange = NSMakeRange(selectedRange.location - deleteCharactersCount, 0);
    }

    [self textViewDidChange:self.textView];
}

//
- (void)onEmojiSend {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onInput:sendText:)]) {
        [self.delegate onInput:self sendText:[self plainText]];
        
        [self.textView setAttributedText:nil];
        [self textViewDidChange:self.textView];
    }
}

@end
