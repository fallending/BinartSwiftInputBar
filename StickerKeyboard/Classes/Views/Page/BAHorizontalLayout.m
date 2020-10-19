//
//  BAHorizontalLayout.m
//  ZYXHorizontalFlowLayout
//
//  Created by 张哈哈 on 2018/6/23.
//  Copyright © 2018年 zyx. All rights reserved.
//

#import "BAHorizontalLayout.h"

@interface BAHorizontalLayout ()

@property (nonatomic,strong) NSMutableArray *attrs;
@property (nonatomic,strong) NSMutableDictionary *pageDict;

@end

@implementation BAHorizontalLayout

#pragma mark - life cycle

- (instancetype)init {
    if (self = [super init]) {
        // 默认配置
        self.pagingEnabled = YES;
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView.pagingEnabled = self.pagingEnabled;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    // 获取section数量
    NSInteger section = [self.collectionView numberOfSections];
    for (int i = 0; i < section; i++) {
        // 获取当前分区的item数量
        NSInteger items = [self.collectionView numberOfItemsInSection:i];
        for (int j = 0; j < items; j++) {
            // 设置item位置
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:indexPath];
            [self.attrs addObject:attr];
        }
    }
    
    //
    
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attr = [super layoutAttributesForItemAtIndexPath:indexPath].copy;
    [self resetItemLocation:attr];
    return attr;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attrs;
}

- (CGSize)collectionViewContentSize {
    // 将所有section页面数量相加
    NSInteger allPagesCount = 0;
    for (NSString *page in [self.pageDict allKeys]) {
        allPagesCount += allPagesCount + [self.pageDict[page] integerValue];
    }
    CGFloat width = allPagesCount * self.collectionView.bounds.size.width;
    CGFloat hegith = self.collectionView.bounds.size.height;
    return CGSizeMake(width, hegith);
}

// MARK: - Private

- (void)resetItemLocation:(UICollectionViewLayoutAttributes *)attr {
    if (attr.representedElementKind != nil) {
        return;
    }
    // 获取当前item的大小
    CGFloat itemW = self.itemSize.width;
    CGFloat itemH = self.itemSize.height;
    
    UIEdgeInsets edgeInsets = self.sectionInset;
    
    // 获取当前section的item数量
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:attr.indexPath.section];
    
    // 获取横排item数量
    CGFloat width = self.collectionView.bounds.size.width;
    // 获取行间距和item最小间距
    CGFloat lineDis = self.minimumLineSpacing;
    CGFloat itemDis = self.minimumInteritemSpacing;
    // 获取当前item的索引index
    NSInteger index = attr.indexPath.item;
    // 获取每页item数量
    NSInteger allCount = self.rowCount * self.columCount;
    // 获取item在当前section的页码
    NSInteger page = index / allCount;
    // 获取item x y方向偏移量
    NSInteger xIndex = index % self.rowCount;
    NSInteger yIndex = (index - page * allCount)/self.rowCount;
    
    // 获取x y方向偏移距离
    CGFloat xOffset = xIndex * (itemW + lineDis) + edgeInsets.left;
    CGFloat yOffset = yIndex * (itemH + itemDis) + edgeInsets.top;
    
    // 获取每个item占了几页
    NSInteger sectionPage = (itemCount % allCount == 0) ? itemCount/allCount : (itemCount/allCount + 1);
    // 保存每个section的page数量
    [self.pageDict setObject:@(sectionPage) forKey:[NSString stringWithFormat:@"%lu",attr.indexPath.section]];
    // 将所有section页面数量相加
    NSInteger allPagesCount = 0;
    for (NSString *page in [self.pageDict allKeys]) {
        allPagesCount += allPagesCount + [self.pageDict[page] integerValue];
    }
    // 获取到的数减去最后一页的页码数
    NSInteger lastIndex = self.pageDict.allKeys.count - 1;
    allPagesCount -= [self.pageDict[[NSString stringWithFormat:@"%lu",lastIndex]] integerValue];
    xOffset += page * width + allPagesCount * width;
    
    attr.frame = CGRectMake(xOffset, yOffset, itemW, itemH);
}

// MARK: - Getter & Setter

- (NSMutableArray *)attrs {
    if (!_attrs) {
        _attrs = [NSMutableArray array];
    }
    return _attrs;
}

- (NSMutableDictionary *)pageDict {
    if (!_pageDict) {
        _pageDict = [NSMutableDictionary dictionary];
    }
    return _pageDict;
}

- (void)setContainerSize:(CGSize)containerSize {
    CGFloat horizontalSpacing = ((containerSize.width - self.rowCount * self.itemSize.width) / (self.rowCount + 1));
    self.minimumLineSpacing = horizontalSpacing;
    self.minimumInteritemSpacing = 30;
    
    self.sectionInset = UIEdgeInsetsMake(horizontalSpacing, horizontalSpacing, horizontalSpacing, horizontalSpacing);
}

@end
