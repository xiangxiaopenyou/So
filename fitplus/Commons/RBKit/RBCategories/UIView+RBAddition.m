//
//  UIView+RBAddition.m
//  fitplus
//
//  Created by 天池邵 on 15/7/3.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "UIView+RBAddition.h"
#import <Masonry.h>
#import "RBBorderView.h"

@implementation UIView (RBAddition)
- (void)rb_addBorder:(RB_BorderSide)side width:(CGFloat)width color:(UIColor *)color {
    
    UIView *targetView = self;
    if ([self isKindOfClass:[UITableView class]]) {
        targetView = self.subviews[0];
    }
    
    BOOL needTop = side & BorderSide_Top, needBottom = side & BorderSide_Bottom,
    needLeft = side & BorderSide_Left, needRight = side & BorderSide_Right;
    
    RBBorderView *borderView = [RBBorderView new];
    borderView.userInteractionEnabled = NO;
    borderView.backgroundColor = [UIColor clearColor];
    borderView.borderWidth = 1;
    borderView.borderColor = color;
    
    CGSize size = targetView.frame.size;
    if (needBottom && !needTop) {
        size.height += width;
    } else if (!needBottom) {
        size.height += width * 2;
    }
    
    if (needRight && !needLeft) {
        size.width += width;
    } else if (!needRight) {
        size.width += width * 2;
    }
    
    borderView.frame = CGRectMake(needLeft ? 0 : -width, needTop ? 0 : -width, size.width, size.height);
    
    targetView.layer.masksToBounds = YES;
    [targetView addSubview:borderView];
    [targetView sendSubviewToBack:borderView];
    
    [borderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(targetView.mas_leading).offset(needLeft ? 0 : -width);
        make.top.equalTo(targetView.mas_top).offset(needTop ? 0 : -width);
        make.bottom.equalTo(targetView.mas_bottom).offset(needBottom ? 0 : width);
        make.trailing.equalTo(targetView.mas_trailing).offset(needRight ? 0 : width);
    }];
    
    [targetView layoutIfNeeded];
}
@end
