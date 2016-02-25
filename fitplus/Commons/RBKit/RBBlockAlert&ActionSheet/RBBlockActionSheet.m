//
//  RBBlockActionSheet.m
//  RainbowKit
//
//  Created by ShaoTianchi on 14/10/30.
//  Copyright (c) 2014年 Rainbow. All rights reserved.
//

#import "RBBlockActionSheet.h"

@interface RBBlockActionSheet ()<UIActionSheetDelegate>
@property (nonatomic, copy) ClickedBlock clickBlock;

@end

@implementation RBBlockActionSheet

- (instancetype)initWithTitle:(NSString *)title clickBlock:(ClickedBlock)block cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
    self = [super initWithTitle:title delegate:self cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:nil];
    if (self) {
        if (self) {
            self.clickBlock = [block copy];
            va_list _arguments;
            va_start(_arguments, otherButtonTitles);
            for (NSString *key = otherButtonTitles; key != nil; key = (__bridge NSString *)va_arg(_arguments, void *)) {
                [self addButtonWithTitle:key];
            }
            va_end(_arguments);
        }
    }
    return self;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (_clickBlock) {
        _clickBlock(buttonIndex);
    } 
}

@end
