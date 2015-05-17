//
//  JBTableVIew.h
//  JBTableView
//
//  Created by 薛靖博 on 15/5/17.
//  Copyright (c) 2015年 xjb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JBTableView;
@protocol JBTableViewDelegate <NSObject>

@optional
- (void)tableViewDidStartRefreshing:(JBTableView *)tableView;
- (void)tableViewDidStartLoading:(JBTableView *)tableView;

@end

@protocol JBTableViewTouchDelegate <NSObject>
@optional
- (void)tableView:(JBTableView *)tableView touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)tableView:(JBTableView *)tableView touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)tableView:(JBTableView *)tableView touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

@end

@interface JBTableView : UITableView {
    BOOL  _isHaveRefreshView;
    BOOL  _isHaveLoadView;
}

@property (weak, nonatomic) IBOutlet id<JBTableViewDelegate>JBDelegate;
@property (weak, nonatomic) IBOutlet id<JBTableViewTouchDelegate>JBTouchDelegate;
@property (assign, nonatomic) BOOL  isHaveRefreshView;
@property (assign, nonatomic) BOOL  isHaveLoadView;

@property (assign, nonatomic) BOOL isFinish;
@property (strong, nonatomic) NSString *shouldStatUp;
@property (strong, nonatomic) NSString *shouldStatDown;
@property (strong, nonatomic) NSString *willStatUp;
@property (strong, nonatomic) NSString *willStatDown;
@property (strong, nonatomic) NSString *didStatUp;
@property (strong, nonatomic) NSString *didStatDown;
@property (strong, nonatomic) NSString *endStatUp;
@property (strong, nonatomic) NSString *endStatDown;

/**
 *刷新、加载结束
 **/
- (void)end;

@end
