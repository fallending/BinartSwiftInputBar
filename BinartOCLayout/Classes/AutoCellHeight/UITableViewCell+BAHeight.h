#import "BALayoutUtil.h"

////////////////////////////列表视图//////////////////////////////

@interface UITableViewCell (WHC_AutoHeightForCell)
/// cell最底部视图
@property (nonatomic , strong) UIView * whc_CellBottomView;
/// cell最底部视图集合
@property (nonatomic , strong) NSArray * whc_CellBottomViews;
/// cell最底部视图与cell底部的间隙
@property (nonatomic , assign) CGFloat  whc_CellBottomOffset;
/// cell中包含的UITableView
@property (nonatomic , strong) UITableView * whc_CellTableView;
/// 指定tableview宽度（有助于提高自动计算效率）
@property (nonatomic , assign) CGFloat whc_TableViewWidth;

/// 自动计算cell高度
+ (CGFloat)whc_CellHeightForIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView;


/**
 自动计算cell高度: 重用cell api

 @param indexPath cell index
 @param tableView 列表
 @param identifier 重用标示
 @param block cell 布局回调
 @return cell高度
 
 @note 改api定要实现block回调才能正确计算cell高度
 */
+ (CGFloat)whc_CellHeightForIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView identifier:(NSString *)identifier layoutBlock:(void (^)(UITableViewCell * cell))block;
@end

