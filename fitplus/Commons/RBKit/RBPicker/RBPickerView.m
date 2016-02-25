//
//  RBPickerView.m
//  Coach
//
//  Created by 天池邵 on 15/6/15.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "RBPickerView.h"
#import <Masonry.h>

@interface RBPickerView ()
@property (copy, nonatomic) void (^handler)(NSInteger);
@end

@implementation RBPickerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
        bgView.backgroundColor = [UIColor colorWithRed:0.4078 green:0.4078 blue:0.4078 alpha:0.65];
        [self addSubview:bgView];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
        bgView.backgroundColor = [UIColor colorWithRed:0.4078 green:0.4078 blue:0.4078 alpha:0.65];
        [self addSubview:bgView];
    }
    return self;
}

- (void)setPicker:(UIView *)picker handler:(void (^)(NSInteger))handler buttonTitles:(NSString *)titles, ... {
    _handler = handler;
    va_list _arguments;
    va_start(_arguments, titles);
    NSInteger index = 0;
    for (NSString *key = titles; key != nil; key = (__bridge NSString *)va_arg(_arguments, void *)) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:key forState:UIControlStateNormal];
        button.tag = index;
        [self addSubview:button];
        button.backgroundColor = [UIColor whiteColor];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonTaped:) forControlEvents:UIControlEventTouchUpInside];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.mas_leading);
            make.trailing.equalTo(self.mas_trailing);
            make.bottom.equalTo(self.mas_bottom).with.offset(-49 * index - 5);
            make.height.mas_equalTo(44);
        }];
        index ++;
    }
    va_end(_arguments);
    
    [self addSubview:picker];
    picker.backgroundColor = [UIColor whiteColor];
    [picker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mas_leading);
        make.trailing.equalTo(self.mas_trailing);
        make.bottom.equalTo(self.mas_bottom).with.offset(-49 * index - 10);
        make.height.mas_equalTo(CGRectGetHeight(picker.frame));
    }];
}

- (void)buttonTaped:(UIButton *)button {
    !_handler ?: _handler(button.tag);
}

@end
