//
//  JBSupplementaryView.h
//  JBTableView
//
//  Created by 薛靖博 on 15/5/17.
//  Copyright (c) 2015年 xjb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JBSupplementaryView : UIView
@property (readonly, nonatomic) BOOL isBegin;
@property (readonly, nonatomic) BOOL isShouldBegin;

- (void)shouldBeginWithMsg:(NSString *)msg;
- (void)willBeginWithMsg:(NSString *)msg;
- (void)didBeginWithMsg:(NSString *)msg;
- (void)endWithMsg:(NSString *)msg;

@end

@interface JBRefreshView : JBSupplementaryView

@end

@interface JBLoadView : JBSupplementaryView
@property (assign, nonatomic) BOOL isFinish;
@end