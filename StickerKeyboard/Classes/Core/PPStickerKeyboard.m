//
//  PPSktickerKeyboard.m
//  PPStickerKeyboard
//
//  Created by Vernon on 2018/1/14.
//  Copyright © 2018年 Vernon. All rights reserved.
//

#import "PPStickerKeyboard.h"
#import "PPEmojiPreviewView.h"
#import "PPStickerPageView.h"
#import "BAStickerConfig.h"
#import "PPUtil.h"
#import "BAEmoji.h"

static CGFloat const PPStickerTopInset = 12.0;


static CGFloat const PPStickerScrollViewHeight = 160.0;

static CGFloat const PPKeyboardPageControlTopMargin = 10.0;
static CGFloat const PPKeyboardPageControlHeight = 7.0;
//static CGFloat const PPKeyboardPageControlBottomMargin = 6.0;

static CGFloat const BAKeyboardSendButtonWidth = 50.f; // 退格按钮、发送按钮 一致
static CGFloat const BAKeyboardSendButtonHeight = 50.f; // 退格按钮、发送按钮 一致
__unused static CGFloat const BAKeyboardSendButtonRightMargin = 4.f;

static CGFloat const PPKeyboardCoverButtonWidth = 50.0;

static CGFloat const BAStickerCateMenuTopInset = 8.f;
static CGFloat const BAStickerCateMenuHeight = 60.f;

static CGFloat const BAStickerCateMenuItemWidth = 48.f;
__unused static CGFloat const BAStickerCateMenuItemHeight = 48.f;
static CGFloat const BAStickerCateMenuItemHorizontalMargin = 8.f;
 
static CGFloat const PPKeyboardCoverButtonHeight = 44.0;

static CGFloat const PPPreviewViewWidth = 92.0;
static CGFloat const PPPreviewViewHeight = 137.0;

static NSString *const PPStickerPageViewReuseID = @"PPStickerPageView";

@interface PPStickerKeyboard () <PPStickerPageViewDelegate, PPQueuingScrollViewDelegate, UIInputViewAudioFeedback>

@property (nonatomic, strong) NSArray<BAStickerBundle *> *stickers;

/// 表情类别菜单
@property (nonatomic, strong) UIScrollView *stickerCateMenu;
@property (nonatomic, strong) UIView *bottomBGView;
@property (nonatomic, strong) NSArray<PPSlideLineButton *> *stickerCoverButtons;

@property (nonatomic, strong) PPSlideLineButton *sendButton;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) NSTimer *deleteEmojiTimer;

@property (nonatomic, strong) PPQueuingScrollView *queuingScrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) PPEmojiPreviewView *emojiPreviewView;

@property (nonatomic, copy) NSString *inputTextTemp;
@end

@implementation PPStickerKeyboard {
    NSUInteger _currentStickerIndex;
}

- (instancetype)init {
    self = [self initWithFrame:CGRectZero];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _currentStickerIndex = 0;
        _stickers = BAStickerConfig.shared.allStickers.copy;

        self.backgroundColor = BAStickerConfig.shared.stickerBackgroundColor;
        [self addSubview:self.queuingScrollView];
        [self addSubview:self.pageControl];
        [self addSubview:self.bottomBGView];
        [self addSubview:self.stickerCateMenu];
        
        // Theirs' layer beyond stickerCateMenu
        [self addSubview:self.sendButton];
        [self addSubview:self.deleteButton];

        [self changeStickerToIndex:0];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    // 表情类别菜单
    self.stickerCateMenu.contentSize = CGSizeMake(self.stickerCoverButtons.count * (BAStickerCateMenuItemWidth+BAStickerCateMenuItemHorizontalMargin)+BAStickerCateMenuItemHorizontalMargin, PPKeyboardCoverButtonHeight);
    self.stickerCateMenu.frame =
    CGRectMake(
               0,
//               CGRectGetHeight(self.bounds) - PPKeyboardCoverButtonHeight - PP_SAFEAREAINSETS(self).bottom,
               BAStickerCateMenuTopInset,
               CGRectGetWidth(self.bounds),
               PPKeyboardCoverButtonHeight
               );
    [self reloadStickerMenuData];
    
    // 退格按钮
    self.deleteButton.frame = CGRectMake(
    CGRectGetWidth(self.bounds) - BAKeyboardSendButtonWidth*2,
    (BAStickerCateMenuHeight-BAKeyboardSendButtonHeight)/2,
    BAKeyboardSendButtonWidth,
    BAKeyboardSendButtonHeight);
    
    // 发送按钮
    self.sendButton.frame = CGRectMake(
                                       CGRectGetWidth(self.bounds) - BAKeyboardSendButtonWidth,
                                       (BAStickerCateMenuHeight-BAKeyboardSendButtonHeight)/2,
                                       BAKeyboardSendButtonWidth,
                                       BAKeyboardSendButtonHeight);
    
    self.bottomBGView.frame =
    CGRectMake(
               0,
//               CGRectGetMinY(self.stickerCateMenu.frame),
               0,
               CGRectGetWidth(self.frame),
               BAStickerCateMenuHeight// + PP_SAFEAREAINSETS(self).bottom
               );
    
    // 表情选择
    self.queuingScrollView.contentSize =
        CGSizeMake(
                   [self numberOfPageForSticker:[self stickerAtIndex:_currentStickerIndex]] * CGRectGetWidth(self.bounds),
                   PPStickerScrollViewHeight);
    self.queuingScrollView.frame =
        CGRectMake(0,
    //               PPStickerTopInset,
                   BAStickerCateMenuTopInset + BAStickerCateMenuHeight,
                   CGRectGetWidth(self.bounds),
                   PPStickerScrollViewHeight);
    self.pageControl.frame = CGRectMake(0, CGRectGetMaxY(self.queuingScrollView.frame) + PPKeyboardPageControlTopMargin, CGRectGetWidth(self.bounds), PPKeyboardPageControlHeight);
}

- (CGFloat)heightThatFits {
    CGFloat bottomInset = 0;
    if (@available(iOS 11.0, *)) {
        bottomInset = UIApplication.sharedApplication.delegate.window.safeAreaInsets.bottom;
    }
    return
        PPStickerTopInset +
        PPStickerScrollViewHeight +
        PPKeyboardPageControlTopMargin +
        PPKeyboardPageControlHeight +
        BAStickerCateMenuTopInset +
        BAStickerCateMenuHeight +
        bottomInset;
}

- (void)notifyInputChanged:(NSString *)text {
    _inputTextTemp = text;
    
    [self refreshActionButtons];
}

// MARK: - getter / setter

- (PPQueuingScrollView *)queuingScrollView {
    if (!_queuingScrollView) {
        _queuingScrollView = [[PPQueuingScrollView alloc] init];
        _queuingScrollView.delegate = self;
        _queuingScrollView.pagePadding = 0;
        _queuingScrollView.alwaysBounceHorizontal = NO;
        _queuingScrollView.backgroundColor = BAStickerConfig.shared.stickerBackgroundColor;
    }
    return _queuingScrollView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.hidesForSinglePage = YES;
        _pageControl.currentPageIndicatorTintColor = [UIColor pp_colorWithRGBString:@"#F5A623"];
        _pageControl.pageIndicatorTintColor = [UIColor pp_colorWithRGBString:@"#BCBCBC"];
    }
    return _pageControl;
}

- (PPSlideLineButton *)sendButton {
    if (!_sendButton) {
        _sendButton = [[PPSlideLineButton alloc] init];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton setTitleColor:BAStickerConfig.shared.sendColorNormal forState:UIControlStateNormal];
//        [_sendButton setTitleColor:BAStickerConfig.shared.sendColorDisabled forState:UIControlStateDisabled];
        [_sendButton setBackgroundColor:BAStickerConfig.shared.sendBackgroundColor];
        _sendButton.linePosition = PPSlideLineButtonPositionLeft;
        _sendButton.lineWidth = 1.f;
        _sendButton.lineColor = [UIColor pp_colorWithRGBString:@"#D1D6DA"];
        [_sendButton addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _sendButton;
}

- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [[UIButton alloc] init];
//        _deleteButton.userInteractionEnabled = YES;
        [_deleteButton setBackgroundColor:BAStickerConfig.shared.deleteBackgroundColor];
        [_deleteButton setImage:BAStickerConfig.shared.deleteImageNormal forState:UIControlStateNormal];
//        [_deleteButton setImage:BAStickerConfig.shared.deleteImageDisabled forState:UIControlStateDisabled];
        [_deleteButton addTarget:self action:@selector(didTouchDownDeleteButton:) forControlEvents:UIControlEventTouchDown];
        [_deleteButton addTarget:self action:@selector(didTouchUpInsideDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
        [_deleteButton addTarget:self action:@selector(didTouchUpOutsideDeleteButton:) forControlEvents:UIControlEventTouchUpOutside];
    }
    return _deleteButton;
}

- (UIScrollView *)stickerCateMenu {
    if (!_stickerCateMenu) {
        _stickerCateMenu = [[UIScrollView alloc] init];
        _stickerCateMenu.showsHorizontalScrollIndicator = NO;
        _stickerCateMenu.showsVerticalScrollIndicator = NO;
        _stickerCateMenu.backgroundColor = [UIColor clearColor];
    }
    return _stickerCateMenu;
}

- (UIView *)bottomBGView {
    if (!_bottomBGView) {
        _bottomBGView = [[UIView alloc] init];
        _bottomBGView.backgroundColor = BAStickerConfig.shared.cateBackgroundColor;
    }
    return _bottomBGView;
}

- (PPEmojiPreviewView *)emojiPreviewView {
    if (!_emojiPreviewView) {
        _emojiPreviewView = [[PPEmojiPreviewView alloc] init];
        _emojiPreviewView.backgroundColor = [UIColor clearColor];
    }
    return _emojiPreviewView;
}

// MARK: - private method

- (BAStickerBundle *)stickerAtIndex:(NSUInteger)index {
    if (self.stickers && index < self.stickers.count) {
        return self.stickers[index];
    }
    return nil;
}

- (NSUInteger)numberOfPageForSticker:(BAStickerBundle *)stickerBundle {
    if (!stickerBundle) {
        return 0;
    }

    NSUInteger numberOfPage = (stickerBundle.data.count / PPStickerPageViewMaxEmojiCount) + ((stickerBundle.data.count % PPStickerPageViewMaxEmojiCount == 0) ? 0 : 1);
    return numberOfPage;
}

- (void)reloadStickerMenuData {
    for (UIButton *button in self.stickerCoverButtons) {
        [button removeFromSuperview];
    }
    self.stickerCoverButtons = nil;

    if (!self.stickers || !self.stickers.count) {
        return;
    }

    NSMutableArray *stickerCoverButtons = [[NSMutableArray alloc] init];
    for (NSUInteger index = 0, max = self.stickers.count; index < max; index++) {
        BAStickerBundle *stickerBundle = self.stickers[index];
        if (!stickerBundle) {
            return;
        }

        PPSlideLineButton *button = [[PPSlideLineButton alloc] init];
        button.tag = index;
        button.imageView.contentMode = UIViewContentModeScaleAspectFit;
        button.layer.cornerRadius = 2.f;
//        button.linePosition = PPSlideLineButtonPositionRight;
//        button.lineColor = [UIColor pp_colorWithRGBString:@"#D1D1D1"];
        button.backgroundColor = (_currentStickerIndex == index ? [UIColor pp_colorWithRGBString:@"#434343"] : [UIColor clearColor]);
        [button setImage:stickerBundle.coverImage forState:UIControlStateNormal];
        [button addTarget:self action:@selector(changeSticker:) forControlEvents:UIControlEventTouchUpInside];
        [self.stickerCateMenu addSubview:button];
        [stickerCoverButtons addObject:button];
        button.frame = CGRectMake(index * (BAStickerCateMenuItemWidth +BAStickerCateMenuItemHorizontalMargin), 0, PPKeyboardCoverButtonWidth, PPKeyboardCoverButtonHeight);
    }
    self.stickerCoverButtons = stickerCoverButtons;
    
    [self refreshActionButtons];
}

- (void)changeStickerToIndex:(NSUInteger)toIndex {
    if (toIndex >= self.stickers.count) {
        return;
    }

    BAStickerBundle *stickerBundle = [self stickerAtIndex:toIndex];
    if (!stickerBundle) {
        return;
    }
    
    _currentStickerIndex = toIndex;

    PPStickerPageView *pageView = [self queuingScrollView:self.queuingScrollView pageViewForStickerAtIndex:0];
    [self.queuingScrollView displayView:pageView];

    [self reloadStickerMenuData];
}

- (void)refreshActionButtons {
    BAStickerBundle *stickerBundle = [self stickerAtIndex:_currentStickerIndex];
    if (!stickerBundle) {
        return;
    }
    
    // 只有小表情，才存在退格、发送
    self.sendButton.hidden = !stickerBundle.isEmoji;
    self.deleteButton.hidden = !stickerBundle.isEmoji;
    
    // 如果是小表情，inputtext有效，才有显示
//    if (stickerBundle.isEmoji) {
        BOOL inputEnabled = _inputTextTemp && _inputTextTemp.length > 0;
        
        self.sendButton.hidden = !inputEnabled;
        self.deleteButton.hidden = !inputEnabled;
//    }
}

// MARK: - target / action

- (void)changeSticker:(UIButton *)button {
    [self changeStickerToIndex:button.tag];
}

- (void)sendAction:(PPSlideLineButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onEmojiSend)]) {
        [self.delegate onEmojiSend];
    }
}

// MARK: - 退格处理

- (void)didTouchDownDeleteButton:(UIButton *)button {
    if (self.deleteEmojiTimer) {
        [self.deleteEmojiTimer invalidate];
        self.deleteEmojiTimer = nil;
    }

    self.deleteEmojiTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(delegateDeleteEmoji) userInfo:nil repeats:YES];
}

- (void)didTouchUpInsideDeleteButton:(UIButton *)button {
    [self delegateDeleteEmoji];

    if (self.deleteEmojiTimer) {
        [self.deleteEmojiTimer invalidate];
        self.deleteEmojiTimer = nil;
    }
}

- (void)didTouchUpOutsideDeleteButton:(UIButton *)button {
    if (self.deleteEmojiTimer) {
        [self.deleteEmojiTimer invalidate];
        self.deleteEmojiTimer = nil;
    }
}

- (void)delegateDeleteEmoji {
    [self stickerPageViewDidClickDeleteButton];
}

#pragma mark - PPQueuingScrollViewDelegate

- (void)queuingScrollViewChangedFocusView:(PPQueuingScrollView *)queuingScrollView previousFocusView:(UIView *)previousFocusView {
    PPStickerPageView *currentView = (PPStickerPageView *)self.queuingScrollView.focusView;
    self.pageControl.currentPage = currentView.pageIndex;
}

- (UIView<PPReusablePage> *)queuingScrollView:(PPQueuingScrollView *)queuingScrollView viewBeforeView:(UIView *)view {
    return [self queuingScrollView:queuingScrollView pageViewForStickerAtIndex:((PPStickerPageView *)view).pageIndex - 1];
}

- (UIView<PPReusablePage> *)queuingScrollView:(PPQueuingScrollView *)queuingScrollView viewAfterView:(UIView *)view {
    return [self queuingScrollView:queuingScrollView pageViewForStickerAtIndex:((PPStickerPageView *)view).pageIndex + 1];
}

- (PPStickerPageView *)queuingScrollView:(PPQueuingScrollView *)queuingScrollView pageViewForStickerAtIndex:(NSUInteger)index {
    BAStickerBundle *stickerBundle = [self stickerAtIndex:_currentStickerIndex];
    if (!stickerBundle) {
        return nil;
    }

    NSUInteger numberOfPages = [self numberOfPageForSticker:stickerBundle];
    self.pageControl.numberOfPages = numberOfPages;
    if (index >= numberOfPages) {
        return nil;
    }

    PPStickerPageView *pageView = [queuingScrollView reusableViewWithIdentifer:PPStickerPageViewReuseID];
    if (!pageView) {
        pageView = [[PPStickerPageView alloc] initWithReuseIdentifier:PPStickerPageViewReuseID];
        pageView.delegate = self;
    }
    pageView.pageIndex = index;
    [pageView configureWithSticker:stickerBundle];
    return pageView;
}

#pragma mark - PPStickerPageViewDelegate

- (void)stickerPageView:(PPStickerPageView *)stickerPageView didClickEmoji:(BAEmoji *)emoji {
    if (emoji.isEmoji) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(on:emojiClicked:)]) {
            [[UIDevice currentDevice] playInputClick];
            [self.delegate on:emoji.stickerBundle emojiClicked:emoji];
        }
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(on:stickerClicked:)]) {
            [[UIDevice currentDevice] playInputClick];
            [self.delegate on:emoji.stickerBundle stickerClicked:(BASticker *)emoji];
        }
    }
}

- (void)stickerPageViewDidClickDeleteButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(onEmojiDelete)]) {
        [[UIDevice currentDevice] playInputClick];
        [self.delegate onEmojiDelete];
    }
}

- (void)stickerPageView:(PPStickerPageView *)stickerKeyboard showEmojiPreviewViewWithEmoji:(BASticker *)emoji buttonFrame:(CGRect)buttonFrame {
    if (!emoji) {
        return;
    }

    self.emojiPreviewView.emoji = emoji;

    CGRect buttonFrameAtKeybord = CGRectMake(buttonFrame.origin.x, PPStickerTopInset + buttonFrame.origin.y, buttonFrame.size.width, buttonFrame.size.height);
    self.emojiPreviewView.frame = CGRectMake(
                                             CGRectGetMidX(buttonFrameAtKeybord) - PPPreviewViewWidth / 2,
                                             UIScreen.mainScreen.bounds.size.height - CGRectGetHeight(self.bounds) + CGRectGetMaxY(buttonFrameAtKeybord) - PPPreviewViewHeight + BAStickerCateMenuHeight + BAStickerCateMenuTopInset,
                                             PPPreviewViewWidth,
                                             PPPreviewViewHeight);

    UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
    if (window) {
        [window addSubview:self.emojiPreviewView];
    }
}

- (void)stickerPageViewHideEmojiPreviewView:(PPStickerPageView *)stickerKeyboard {
    [self.emojiPreviewView removeFromSuperview];
}

#pragma mark - UIInputViewAudioFeedback

- (BOOL)enableInputClicksWhenVisible {
    return YES;
}

@end
