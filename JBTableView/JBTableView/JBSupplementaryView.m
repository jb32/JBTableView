//
//  JBSupplementaryView.m
//  JBTableView
//
//  Created by 薛靖博 on 15/5/17.
//  Copyright (c) 2015年 xjb. All rights reserved.
//

#import "JBSupplementaryView.h"

#define KMargin             20.f

@interface JBSupplementaryView ()

@end

@implementation JBSupplementaryView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)shouldBegin {
    _isShouldBegin = YES;
}

- (void)willBegin {
    _isBegin = YES;
    _isShouldBegin = NO;
}

- (void)didBegin {
    
}

- (void)end {
    _isBegin = NO;
}

@end

@interface JBRefreshView ()
@property (strong, nonatomic) UIActivityIndicatorView       *indicatorView;
@property (strong, nonatomic) UIView                        *line;
@property (strong, nonatomic) UILabel                       *lbState;
@property (strong, nonatomic) NSString                      *beginMsg;
@end

@implementation JBRefreshView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _indicatorView.color = [UIColor blackColor];
        [self addSubview:_indicatorView];
        
        _lbState = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbState.text = @"下拉刷新";
        _lbState.font = [UIFont systemFontOfSize:13];
        [_lbState sizeToFit];
        [self addSubview:_lbState];
        
        _line = [[UIView alloc] initWithFrame:CGRectZero];
        [_line setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        [self addSubview:_line];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = _lbState.frame.size;
    CGFloat x = CGRectGetWidth(self.frame)/2 - size.width/2;
    CGFloat y = CGRectGetHeight(self.frame) - size.height - KMargin;
    _lbState.frame = CGRectMake(x, y, size.width, size.height);
    
    CGSize sizeIndicator = _indicatorView.frame.size;
    y = CGRectGetHeight(self.frame) - sizeIndicator.height - KMargin;
    _indicatorView.frame = CGRectMake(20, y, sizeIndicator.width, sizeIndicator.height);
    
    _line.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 0.5, CGRectGetWidth(self.frame), 0.5);
}

- (void)shouldBegin {
    [super shouldBegin];
}

- (void)willBegin {
    [super willBegin];
    
    [_lbState setText:@"释放刷新"];
    [_lbState sizeToFit];
}

- (void)didBegin {
    [super didBegin];
    
    [_lbState setText:@"正在刷新"];
    [_lbState sizeToFit];
    
    [_indicatorView startAnimating];
}

- (void)end {
    [super end];
    
    [_lbState setText:@"刷新完毕"];
    [_lbState sizeToFit];
    
    [_indicatorView stopAnimating];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_lbState setText:@"下拉刷新"];
        [_lbState sizeToFit];
    });
}

@end

@interface JBLoadView ()
@property (strong, nonatomic) UIActivityIndicatorView       *indicatorView;
@property (strong, nonatomic) UIView                        *line;
@property (strong, nonatomic) UILabel                       *lbState;
@property (strong, nonatomic) NSString *beginMsg;
@end

@implementation JBLoadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _isFinish = NO;
        
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _indicatorView.color = [UIColor blackColor];
        [self addSubview:_indicatorView];
        
        _lbState = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbState.text = @"上拉加载更多";
        _lbState.font = [UIFont systemFontOfSize:13];
        [_lbState sizeToFit];
        [self addSubview:_lbState];
        
        _line = [[UIView alloc] initWithFrame:CGRectZero];
        [_line setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        [self addSubview:_line];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize size = _lbState.frame.size;
    CGFloat x = CGRectGetWidth(self.frame)/2 - size.width/2;
    CGFloat y = KMargin;
    _lbState.frame = CGRectMake(x, y, size.width, size.height);
    
    CGSize sizeIndicator = _indicatorView.frame.size;
    _indicatorView.frame = CGRectMake(20, y, sizeIndicator.width, sizeIndicator.height);
    
    _line.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 0.5);
}

- (void)shouldBegin {
    [super shouldBegin];
}

- (void)willBegin {
    [super willBegin];
    [_lbState setText:@"释放加载"];
    [_lbState sizeToFit];
}

- (void)didBegin {
    [super didBegin];
    
    [_lbState setText:@"加载中……"];
    [_lbState sizeToFit];
    
    [_indicatorView startAnimating];
}

- (void)end {
    [super end];
    
    if (_isFinish) {
        [_lbState setText:@"加载完毕"];
        [_lbState sizeToFit];
    }
    [_indicatorView stopAnimating];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_lbState setText:@"上拉加载更多"];
        [_lbState sizeToFit];
    });
}

@end



