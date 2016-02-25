//
//  RBBlockAlertView.m
//  RainbowKit
//
//  Created by 邵天池 on 14-8-4.
//  Copyright (c) 2014年 rainbow. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ClickedBlock) (NSInteger buttonIndex);

@interface RBBlockAlertView : UIAlertView
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message block:(ClickedBlock)block cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message block:(ClickedBlock)block cancelButtonTitle:(NSString *)cancelButtonTitle otherButtontTitle:(NSString *)otherButtontTitle;
@end
