//
//  TipCloseView.h
//  fitplus
//
//  Created by xlp on 15/10/12.
//  Copyright © 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ClickBlock) (NSInteger buttonIndex);

@interface TipCloseView : UIView
@property (strong, nonatomic) UIButton *closeViewButton;
@property (strong, nonatomic) UIButton *closeButton;
@property (strong, nonatomic) UIButton *continueButton;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) ClickBlock clickBlock;

- (instancetype)initWithFrame:(CGRect)frame clickBlock:(ClickBlock)block title:(NSString *)title closeButtonTitle:(NSString *)closeTitle continueButtonTitle:(NSString *)continueString;


@end
