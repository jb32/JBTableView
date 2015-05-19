//
//  JBTableVIew.h
//  JBTableView
//
//  Created by 薛靖博 on 15/5/17.
//  Copyright (c) 2015年 xjb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JBTableView;
///刷新加载代理
@protocol JBTableViewDelegate <NSObject>

@optional
/**
 *下拉刷新 开始时调用
 *@param tableView
 */
- (void)tableViewDidStartRefreshing:(JBTableView *)tableView;
/**
 *上拉加载 开始时调用
 *@param tableView
 */
- (void)tableViewDidStartLoading:(JBTableView *)tableView;

@end

@protocol JBTableViewTouchDelegate <NSObject>
@optional
/**
 *table view began touch
 */
- (void)tableView:(JBTableView *)tableView touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
/**
 *table view touch moved
 */
- (void)tableView:(JBTableView *)tableView touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
/**
 *table view touch end
 */
- (void)tableView:(JBTableView *)tableView touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

@end

@interface JBTableView : UITableView {
    BOOL  _isHaveRefreshView;
    BOOL  _isHaveLoadView;
}
///上拉，下拉 刷新 代理
@property (weak, nonatomic) IBOutlet id<JBTableViewDelegate>JBDelegate;
///点击tableview 时调用的 代理
@property (weak, nonatomic) IBOutlet id<JBTableViewTouchDelegate>JBTouchDelegate;
///NO 没有下拉刷新 默认YES
@property (assign, nonatomic) BOOL  isHaveRefreshView;
///NO 没有上拉加载 默认YES
@property (assign, nonatomic) BOOL  isHaveLoadView;
///NO 正在刷新、加载 YES 刷新、加载完成
@property (readonly, nonatomic) BOOL isFinish;

/**
 *刷新、加载结束
 **/
- (void)end;

@end
