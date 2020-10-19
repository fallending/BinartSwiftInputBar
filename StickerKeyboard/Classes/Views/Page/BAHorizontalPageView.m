//
//  BAHorizontalPageView.m
//  ZYXHorizontalFlowLayout
//
//  Created by Seven on 2020/10/12.
//  Copyright © 2020 zyx. All rights reserved.
//

#import "BAHorizontalPageView.h"
#import "BAInputExtCell.h"
#import "BAHorizontalLayout.h"

@interface BAHorizontalPageView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) void(^clickHandler)(BAInputExtItem *item);

@end

@implementation BAHorizontalPageView

// MARK: - Init

- (instancetype)init {
    if (self = [super init]) {
        [self setupDefault];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupDefault];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        [self setupDefault];
    }
    
    return self;
}

// MARK: - Setup


- (void)setupDefault {
    self.backgroundColor = [UIColor redColor];
    self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.alwaysBounceHorizontal = YES;
    self.alwaysBounceVertical = NO;
}

// MARK: -

+ (instancetype)inputExtContainerViewWith:(NSArray *)dataSource safeAreaSpacing:(CGFloat)safeAreaSpacing clickHandler:(nonnull void (^)(BAInputExtItem * _Nonnull))clickHandler {
    BAHorizontalLayout *layout = [[BAHorizontalLayout alloc] init];
    layout.itemSize = BAInputExtCell.preferredSize;
    layout.rowCount = 4;
    layout.columCount = 2;
    layout.containerSize = CGSizeMake(UIScreen.mainScreen.bounds.size.width, 440);

    CGFloat windowWidth = UIScreen.mainScreen.bounds.size.width;
    
    // FIXME: 需要适配安全区域
    BAHorizontalPageView *collectionView = [[BAHorizontalPageView alloc] initWithFrame:CGRectMake(0, 0, windowWidth, 244+safeAreaSpacing) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor colorWithRed:55.f/255 green:55.f/255 blue:55.f/255 alpha:1.f];
    collectionView.delegate = collectionView;
    collectionView.dataSource = collectionView;
    collectionView.items = dataSource;
    
    collectionView.clickHandler = clickHandler;

    [collectionView registerClass:[BAInputExtCell class] forCellWithReuseIdentifier:BAInputExtCell.identifier];
    
    return collectionView;
}

// MARK: -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BAInputExtCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BAInputExtCell.identifier forIndexPath:indexPath];
    
    BAInputExtItem *item = [self.items objectAtIndex:indexPath.row];
    [cell setupData:item];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BAInputExtItem *item = [self.items objectAtIndex:indexPath.row];

    self.clickHandler(item);
}

@end
