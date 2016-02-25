//
//  TipCloseView.m
//  fitplus
//
//  Created by xlp on 15/10/12.
//  Copyright © 2015年 realtech. All rights reserved.
//

#import "TipCloseView.h"

@implementation TipCloseView
- (instancetype)initWithFrame:(CGRect)frame clickBlock:(ClickBlock)block title:(NSString *)title closeButtonTitle:(NSString *)closeTitle continueButtonTitle:(NSString *)continueString {
    self = [super initWithFrame:frame];
    if (self) {
        _clickBlock = [block copy];
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 4.0;
        
        _closeViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeViewButton.frame = CGRectMake(CGRectGetWidth(self.frame) - 20, 5, 14, 14);
        [_closeViewButton setBackgroundImage:[UIImage imageNamed:@"pop_button_close"] forState:UIControlStateNormal];
        [_closeViewButton addTarget:self action:@selector(tipViewClose) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_closeViewButton];
        
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 47, CGRectGetWidth(self.frame) / 2 - 1, 47);
        [_closeButton setBackgroundColor:[UIColor colorWithRed:109/255.0 green:86/255.0 blue:132/255.0 alpha:1.0]];
        [_closeButton setTitle:closeTitle forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_closeButton];
        
        _continueButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _continueButton.frame = CGRectMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) - 47, CGRectGetWidth(self.frame) / 2, 47);
        [_continueButton setBackgroundColor:[UIColor colorWithRed:109/255.0 green:86/255.0 blue:132/255.0 alpha:1.0]];
        [_continueButton setTitle:continueString forState:UIControlStateNormal];
        [_continueButton addTarget:self action:@selector(continueButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_continueButton];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 30, CGRectGetWidth(self.frame) - 30, 60)];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor colorWithRed:81/255.0 green:81/255.0 blue:81/255.0 alpha:1.0];
        _titleLabel.numberOfLines = 0;
        _titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _titleLabel.text = title;
        [self addSubview:_titleLabel];
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)tipViewClose {
    if (_clickBlock) {
        _clickBlock(2);
    }
    //[self removeFromSuperview];
}
- (void)closeButtonClick {
    if (_clickBlock) {
        _clickBlock(1);
    }
}
- (void)continueButtonClick {
    if (_clickBlock) {
        _clickBlock(2);
    }
    //[self removeFromSuperview];
}

@end
