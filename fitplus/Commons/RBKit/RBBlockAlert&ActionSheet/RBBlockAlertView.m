//
//  RBBlockAlertView.m
//  RainbowKit
//
//  Created by 邵天池 on 14-8-4.
//  Copyright (c) 2014年 rainbow. All rights reserved.
//

#import "RBBlockAlertView.h"

@interface RBBlockAlertView ()<UIAlertViewDelegate>
@property (nonatomic, copy) ClickedBlock clickBlock;
@end

@implementation RBBlockAlertView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message block:(ClickedBlock)block cancelButtonTitle:(NSString *)cancelButtonTitle otherButtontTitle:(NSString *)otherButtontTitle {
    self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtontTitle, nil];
    if (self) {
        self.clickBlock = [block copy];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message block:(ClickedBlock)block cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
    self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles: nil];
    if (self) {
        self.clickBlock = [block copy];
        va_list _arguments;
        va_start(_arguments, otherButtonTitles);
        for (NSString *key = otherButtonTitles; key != nil; key = (__bridge NSString *)va_arg(_arguments, void *)) {
            [self addButtonWithTitle:key];
        }
        va_end(_arguments);
    }
    return self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (_clickBlock) {
        _clickBlock(buttonIndex);
    }
}

- (void)show {
    [super show];
}

@end
