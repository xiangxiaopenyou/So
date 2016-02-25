//
//  RBNoticeHelper.h
//  RainbowKit
//
//  Created by 天池邵 on 15/3/18.
//  Copyright (c) 2015年 Rainbow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RBNoticeHelper : NSObject
+ (void)showNoticeAtView:(UIView *)view msg:(NSString *)msg;
+ (void)showNoticeAtViewController:(UIViewController *)viewControlelr msg:(NSString *)msg;
+ (void)showNoticeAtView:(UIView *)view y:(CGFloat)y msg:(NSString *)msg;
@end
