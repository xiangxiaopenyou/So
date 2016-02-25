//
//  UILabel+PlaceholderAddition.m
//  RainbowKit
//
//  Created by 天池邵 on 15/5/6.
//  Copyright (c) 2015年 Rainbow. All rights reserved.
//

#import "UITextField+PlaceholderAddition.h"
#import <objc/runtime.h>

@implementation UITextField (PlaceholderAddition)

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        // Class class = object_getClass((id)self);
        
        SEL originalSelector = @selector(drawPlaceholderInRect:);
        SEL swizzledSelector = @selector(rainbow_drawPlaceholderInRect:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)rainbow_drawPlaceholderInRect:(CGRect)rect {
    CGSize contentSize = [self.placeholder sizeWithAttributes:@{NSFontAttributeName : self.font}];
    rect = CGRectOffset(rect, 0, (CGRectGetHeight(self.frame) - contentSize.height) / 2);
    [[self placeholder] drawInRect:rect withAttributes:@{NSFontAttributeName : self.font,
                                                         NSForegroundColorAttributeName : [UIColor colorWithRed:0.697 green:0.723 blue:0.746 alpha:1.000]}];
}

@end
