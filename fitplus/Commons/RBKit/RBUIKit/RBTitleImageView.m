//
//  RBLabel.m
//  RainbowKit
//
//  Created by 天池邵 on 15/5/12.
//  Copyright (c) 2015年 Rainbow. All rights reserved.
//

#import "RBTitleImageView.h"

@interface RBTitleImageView ()
@property (strong, nonatomic) UILabel *titleLabel;
@end

@implementation RBTitleImageView

- (void)xibSetup {
    if (_titleLabel) {
        return;
    }
    
    _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:_titleLabel];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    [self xibSetup];
    
    _titleLabel.text = title;
}

- (void)setFontSize:(CGFloat)fontSize {
    _fontSize = fontSize;
    [self xibSetup];
    _titleLabel.font = [UIFont systemFontOfSize:fontSize];
}

- (void)setTextAlignment:(NSInteger)textAlignment {
    _textAlignment = textAlignment;
    [self xibSetup];
    _titleLabel.textAlignment = textAlignment;
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    [self xibSetup];
    _titleLabel.textColor = titleColor;
}

- (void)setOffset_x:(CGFloat)offset_x {
    _offset_x = offset_x;
    [self xibSetup];
    _titleLabel.frame = CGRectMake(CGRectGetMinX(_titleLabel.frame) + offset_x, CGRectGetMinY(_titleLabel.frame), CGRectGetWidth(_titleLabel.frame) - offset_x, CGRectGetHeight(_titleLabel.frame));
    [self addSubview:_titleLabel];
}

- (void)setOffset_y:(CGFloat)offset_y {
    _offset_y = offset_y;
    [self xibSetup];
    _titleLabel.frame = CGRectMake(CGRectGetMinX(_titleLabel.frame), CGRectGetMinY(_titleLabel.frame) + offset_y, CGRectGetWidth(_titleLabel.frame), CGRectGetHeight(_titleLabel.frame) - offset_y);
}

@end
