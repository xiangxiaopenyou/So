//
//  RBLineIndicator.h
//  fitplus
//
//  Created by 天池邵 on 15/7/6.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RBLineIndicator : UIView
- (void)setupTitles:(NSArray *)titles values:(NSArray *)values;
- (void)showInView:(UIView *)view atPosition:(CGPoint)point;
@property (assign, readonly, nonatomic) NSInteger touchIdentifier;
@end
