//
//  JBTableVIew.m
//  JBTableView
//
//  Created by 薛靖博 on 15/5/17.
//  Copyright (c) 2015年 xjb. All rights reserved.
//

#import "JBTableView.h"
#import "JBSupplementaryView.h"

#define KTriggerOffsetY 60.f
#define KStayOffsetY 40.f
#define kPRAnimationDuration 0.18f

typedef enum : NSUInteger {
    ITRStateNormal = 0,
    ITRStateStay,
    ITRStatePulling,
    ITRStateLoading,
} KTableState;

@interface JBTableView ()
@property (strong, nonatomic) JBRefreshView *refreshView;
@property (strong, nonatomic) JBLoadView    *loadView;
@property (assign, nonatomic) KTableState   state;
@property (assign, nonatomic) UIEdgeInsets  insets;
@end

@implementation JBTableView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self initUI];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    
    if (self) {
        [self initUI];
    }
    
    return self;
}

- (void)setIsHaveRefreshView:(BOOL)hiddenRefreshView {
    _isHaveRefreshView = hiddenRefreshView;
    [self setNeedsLayout];
}

- (void)setIsHaveLoadView:(BOOL)hiddenLoadView {
    _isHaveLoadView = hiddenLoadView;
    [self setNeedsLayout];
}

- (void)initUI {
    _isFinish = NO;
    
    _isHaveLoadView = YES;
    _isHaveRefreshView = YES;
    self.tableFooterView = nil;
    
    _refreshView = [[JBRefreshView alloc] initWithFrame:CGRectZero];
    [self addSubview:_refreshView];
    
    _loadView = [[JBLoadView alloc] initWithFrame:CGRectZero];
    [self addSubview:_loadView];
    
    [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [self addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _refreshView.frame = CGRectMake(0, -self.frame.size.height, self.frame.size.width, self.frame.size.height);
    _refreshView.hidden = !_isHaveRefreshView;
    
    CGRect frame = _loadView.frame;
    frame.size = self.frame.size;
    _loadView.frame = frame;
    _loadView.hidden = !_isHaveLoadView;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"contentSize"];
    [self removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"contentOffset"]) {
        if ([_JBTouchDelegate respondsToSelector:@selector(tableView:touchesMoved:withEvent:)]) {
            [_JBTouchDelegate tableView:self touchesMoved:nil withEvent:nil];
        }
        
        CGPoint new = [[change objectForKey:@"new"] CGPointValue];
        CGPoint old = [[change objectForKey:@"old"] CGPointValue];
        
        CGFloat offsetY = new.y + self.contentInset.top;
        CGFloat offsetY_old = old.y + self.contentInset.top;
        
        if (self.tracking && !self.dragging) {
            [self tableViewDidBeginDragging];
        }
        
        if (self.tracking) {
            if (offsetY >= -KTriggerOffsetY && new.y+CGRectGetHeight(self.frame) - self.contentSize.height < KTriggerOffsetY && _state != ITRStateStay) {
                _state = ITRStateNormal;
                [self tableViewDidDragging];
            } else if ((offsetY <= -KTriggerOffsetY && offsetY_old >= -KTriggerOffsetY) && _state == ITRStateNormal) {
//                NSLog(@"进入刷新区域");
                
                if (_isHaveRefreshView) {
                    _state = ITRStatePulling;
                }
                [_refreshView willBegin];
            } else if (new.y + CGRectGetHeight(self.frame) - self.contentSize.height >= KTriggerOffsetY
                       && old.y + CGRectGetHeight(self.frame) - self.contentSize.height <= KTriggerOffsetY
                       && _state == ITRStateNormal) {
//                NSLog(@"进入加载区域");
                
                if (_isHaveLoadView) {
                    _state = ITRStateLoading;
                }
                [_loadView willBegin];
            }
        } else if (self.decelerating && (_state == ITRStatePulling || _state == ITRStateLoading)) {
//            NSLog(@"开始刷新/加载");
            [self tableViewDidEndDragging];
        }
    } else if ([keyPath isEqualToString:@"contentSize"]) {
        id new = [change objectForKey:@"new"];
        id old = [change objectForKey:@"old"];
        
        if (![old isEqual:new]) {
            CGRect frame = _loadView.frame;
            CGSize contentSize = self.contentSize;
            UIEdgeInsets insets = self.contentInset;
            frame.origin.y = contentSize.height < self.frame.size.height ? self.frame.size.height - insets.bottom - insets.top: contentSize.height;
            _loadView.frame = frame;
            
            _isHaveLoadView = contentSize.height >= self.frame.size.height;
            _loadView.hidden = !_isHaveLoadView;
        }
    }
}

- (void)tableViewDidBeginDragging {
//    NSLog(@"开始拖拽");
}

- (void)tableViewDidDragging {
//    NSLog(@"正在拖动");
    [_refreshView shouldBegin];
    [_loadView shouldBegin];
}

- (void)tableViewDidEndDragging {
    self.insets = self.contentInset;
    
    if (_refreshView.isBegin) {
        [_refreshView didBegin];
    } else if (_loadView.isBegin) {
        [_loadView didBegin];
    }
    
    if (_state == ITRStatePulling) {
        _state = ITRStateStay;
        [UIView animateWithDuration:kPRAnimationDuration animations:^{
            self.contentInset = UIEdgeInsetsMake(_insets.top+KTriggerOffsetY, _insets.left, _insets.bottom , _insets.right);
        }];
        
        if ([_JBDelegate respondsToSelector:@selector(tableViewDidStartRefreshing:)]) {
            [_JBDelegate tableViewDidStartRefreshing:self];
        }
    } else if (_state == ITRStateLoading) {
        _state = ITRStateStay;
        [UIView animateWithDuration:kPRAnimationDuration animations:^{
            self.contentInset = UIEdgeInsetsMake(_insets.top, _insets.left, _insets.bottom + KTriggerOffsetY , _insets.right);
        }];
        
        if ([_JBDelegate respondsToSelector:@selector(tableViewDidStartLoading:)]) {
            [_JBDelegate tableViewDidStartLoading:self];
        }
    }
}

- (void)end {
    if (_state == ITRStateStay) {
        _state = ITRStateNormal;
        NSTimeInterval delay = 0.f;
        
        if (_isFinish) {
            delay = 1.f;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:kPRAnimationDuration animations:^{
                self.contentInset = _insets;
            }];
        });
    }
    
    if (_refreshView.isBegin) {
        [_refreshView end];
    } else if (_loadView.isBegin) {
        _loadView.isFinish = _isFinish;
        [_loadView end];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    if ([_JBTouchDelegate respondsToSelector:@selector(tableView:touchesBegan:withEvent:)]) {
        [_JBTouchDelegate tableView:self touchesBegan:touches withEvent:event];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    if ([_JBTouchDelegate respondsToSelector:@selector(tableView:touchesMoved:withEvent:)]) {
        [_JBTouchDelegate tableView:self touchesMoved:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    if ([_JBTouchDelegate respondsToSelector:@selector(tableView:touchesEnded:withEvent:)]) {
        [_JBTouchDelegate tableView:self touchesEnded:touches withEvent:event];
    }
}

@end
