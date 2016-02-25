//
//  FinishCourseTipView.m
//  fitplus
//
//  Created by xlp on 15/10/14.
//  Copyright © 2015年 realtech. All rights reserved.
//
#define KMainColor [UIColor colorWithRed:104/255.0 green:64/255.0 blue:148/255.0 alpha:1.0]
#define kNormalButtonTitleColor [UIColor colorWithRed:160/255.0 green:153/255.0 blue:168/255.0 alpha:1.0]
#import "FinishCourseTipView.h"

@implementation FinishCourseTipView
- (instancetype)initWithFrame:(CGRect)frame clickBlock:(SelectedDifficulty)block {
    self = [super initWithFrame:frame];
    if (self) {
        _selectBlock = [block copy];
        _difficulty = 1;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 4.0;
        
        _finishLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 56)];
        _finishLabel.font = [UIFont systemFontOfSize:17];
        _finishLabel.textColor = KMainColor;
        _finishLabel.textAlignment = NSTextAlignmentCenter;
        _finishLabel.text = @"恭喜完成训练!";
        [self addSubview:_finishLabel];
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 56, CGRectGetWidth(self.frame), 0.5)];
        line.backgroundColor = KMainColor;
        [self addSubview:line];
        
        _feelLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 66, CGRectGetWidth(self.frame), 15)];
        _feelLabel.font = [UIFont systemFontOfSize:13];
        _feelLabel.textColor = kNormalButtonTitleColor;
        _feelLabel.textAlignment = NSTextAlignmentCenter;
        _feelLabel.text = @"感觉如何";
        [self addSubview:_feelLabel];
        
        _easyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _easyButton.frame = CGRectMake(15, 110, 45, 20);
        _easyButton.layer.masksToBounds = YES;
        _easyButton.layer.cornerRadius = 5.0;
        [_easyButton setTitle:@"轻松" forState:UIControlStateNormal];
        [_easyButton setTitleColor:kNormalButtonTitleColor forState:UIControlStateNormal];
        [_easyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        _easyButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_easyButton setBackgroundColor:KMainColor];
        [_easyButton addTarget:self action:@selector(easyBUttonClick) forControlEvents:UIControlEventTouchUpInside];
        _easyButton.selected = YES;
        [self addSubview:_easyButton];
        
        _normalButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _normalButton.frame = CGRectMake(80, 110, 45, 20);
        _normalButton.layer.masksToBounds = YES;
        _normalButton.layer.cornerRadius = 5.0;
        [_normalButton setTitle:@"一般" forState:UIControlStateNormal];
        [_normalButton setTitleColor:kNormalButtonTitleColor forState:UIControlStateNormal];
        [_normalButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        _normalButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_normalButton setBackgroundColor:[UIColor clearColor]];
        [_normalButton addTarget:self action:@selector(normalButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _normalButton.selected = NO;
        [self addSubview:_normalButton];
        
        _littleDifficultButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _littleDifficultButton.frame = CGRectMake(145, 110, 45, 20);
        _littleDifficultButton.layer.masksToBounds = YES;
        _littleDifficultButton.layer.cornerRadius = 5.0;
        [_littleDifficultButton setTitle:@"较难" forState:UIControlStateNormal];
        [_littleDifficultButton setTitleColor:kNormalButtonTitleColor forState:UIControlStateNormal];
        [_littleDifficultButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        _littleDifficultButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_littleDifficultButton setBackgroundColor:[UIColor clearColor]];
        [_littleDifficultButton addTarget:self action:@selector(littleDifficultButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _littleDifficultButton.selected = NO;
        [self addSubview:_littleDifficultButton];
        
        _difficultButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _difficultButton.frame = CGRectMake(210, 110, 45, 20);
        _difficultButton.layer.masksToBounds = YES;
        _difficultButton.layer.cornerRadius = 5.0;
        [_difficultButton setTitle:@"困难" forState:UIControlStateNormal];
        [_difficultButton setTitleColor:kNormalButtonTitleColor forState:UIControlStateNormal];
        [_difficultButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        _difficultButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_difficultButton setBackgroundColor:[UIColor clearColor]];
        [_difficultButton addTarget:self action:@selector(difficultButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _difficultButton.selected = NO;
        [self addSubview:_difficultButton];
        
        _continueButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _continueButton.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 47, CGRectGetWidth(self.frame), 47);
        [_continueButton setTitle:@"继续" forState:UIControlStateNormal];
        [_continueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _continueButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_continueButton setBackgroundColor:KMainColor];
        [_continueButton addTarget:self action:@selector(continueButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_continueButton];
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
- (void)easyBUttonClick {
    if (_difficulty != 1) {
        _easyButton.selected = YES;
        _normalButton.selected = NO;
        _littleDifficultButton.selected = NO;
        _difficultButton.selected = NO;
        [_easyButton setBackgroundColor:KMainColor];
        [_normalButton setBackgroundColor:[UIColor clearColor]];
        [_littleDifficultButton setBackgroundColor:[UIColor clearColor]];
        [_difficultButton setBackgroundColor:[UIColor clearColor]];
        _difficulty = 1;
    }
    
    
    
}
- (void)normalButtonClick {
    if (_difficulty != 2) {
        _easyButton.selected = NO;
        _normalButton.selected = YES;
        _littleDifficultButton.selected = NO;
        _difficultButton.selected = NO;
        [_easyButton setBackgroundColor:[UIColor clearColor]];
        [_normalButton setBackgroundColor:KMainColor];
        [_littleDifficultButton setBackgroundColor:[UIColor clearColor]];
        [_difficultButton setBackgroundColor:[UIColor clearColor]];
        _difficulty = 2;
    }
    
}
- (void)littleDifficultButtonClick {
    if (_difficulty != 3) {
        _easyButton.selected = NO;
        _normalButton.selected = NO;
        _littleDifficultButton.selected = YES;
        _difficultButton.selected = NO;
        [_easyButton setBackgroundColor:[UIColor clearColor]];
        [_normalButton setBackgroundColor:[UIColor clearColor]];
        [_littleDifficultButton setBackgroundColor:KMainColor];
        [_difficultButton setBackgroundColor:[UIColor clearColor]];
        _difficulty = 3;
    }
    
}
- (void)difficultButtonClick {
    if (_difficulty != 4) {
        _easyButton.selected = NO;
        _normalButton.selected = NO;
        _littleDifficultButton.selected = NO;
        _difficultButton.selected = YES;
        [_easyButton setBackgroundColor:[UIColor clearColor]];
        [_normalButton setBackgroundColor:[UIColor clearColor]];
        [_littleDifficultButton setBackgroundColor:[UIColor clearColor]];
        [_difficultButton setBackgroundColor:KMainColor];
        _difficulty = 4;
    }
    
}
- (void)continueButtonClick {
    if (_selectBlock) {
        _selectBlock(_difficulty);
    }
}


@end
