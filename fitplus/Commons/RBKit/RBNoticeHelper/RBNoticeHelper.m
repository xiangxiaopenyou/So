//
//  RBNoticeHelper.m
//  RainbowKit
//
//  Created by 天池邵 on 15/3/18.
//  Copyright (c) 2015年 Rainbow. All rights reserved.
//

#import "RBNoticeHelper.h"

@interface RBNoticeHelper ()
@property (strong, nonatomic) UILabel *noticeLb;
@end

@implementation RBNoticeHelper

+ (instancetype)singleInstance {
    static RBNoticeHelper *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _noticeLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 20)];
        _noticeLb.font = [UIFont systemFontOfSize:13];
        _noticeLb.textColor = [UIColor whiteColor];
        _noticeLb.textAlignment = NSTextAlignmentCenter;
        _noticeLb.backgroundColor = [UIColor colorWithWhite:0.191 alpha:0.700];
    }
    return self;
}

+ (void)showNoticeAtView:(UIView *)view msg:(NSString *)msg {
    [self showNoticeAtView:view y:20.0 msg:msg];
}

+ (void)showNoticeAtViewController:(UIViewController *)viewControlelr msg:(NSString *)msg {
    UIView *showingView;
    BOOL isTableViewController = [viewControlelr isKindOfClass:[UITableViewController class]];
    if (isTableViewController) {
        showingView = viewControlelr.view.superview;
    } else {
        showingView = viewControlelr.view;
    }
    
    if (viewControlelr.navigationController && !viewControlelr.navigationController.navigationBarHidden /*&& [viewControlelr respondsToSelector:@selector(edgesForExtendedLayout)] && viewControlelr.edgesForExtendedLayout == UIRectEdgeNone*/) {
        [self showNoticeAtView:showingView y:64 - CGRectGetMinY(showingView.frame) msg:msg];
    } else {
        [self showNoticeAtView:showingView y:20 msg:msg];
    }
}

+ (void)showNoticeAtView:(UIView *)view y:(CGFloat)y msg:(NSString *)msg {
    RBNoticeHelper *helper = [RBNoticeHelper singleInstance];
    if (helper.noticeLb.superview) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [RBNoticeHelper showNoticeAtView:view y:y msg:msg];
        });
    } else {
        helper.noticeLb.frame = CGRectMake(0, y, CGRectGetWidth([UIScreen mainScreen].bounds), 20);
        helper.noticeLb.text = msg;
        [view addSubview:helper.noticeLb];
        
        [UIView animateWithDuration:0.3 delay:1.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
            helper.noticeLb.alpha = 0.0;
        } completion:^(BOOL finished) {
            [helper.noticeLb removeFromSuperview];
            helper.noticeLb.alpha = 1.0;
        }];
    }
    
}

@end
