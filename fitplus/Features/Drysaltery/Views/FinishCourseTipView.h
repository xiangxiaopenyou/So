//
//  FinishCourseTipView.h
//  fitplus
//
//  Created by xlp on 15/10/14.
//  Copyright © 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^SelectedDifficulty) (NSInteger index);

@interface FinishCourseTipView : UIView
@property (strong, nonatomic) UILabel *finishLabel;
@property (strong, nonatomic) UILabel *feelLabel;
@property (strong, nonatomic) UIButton *easyButton;
@property (strong, nonatomic) UIButton *normalButton;
@property (strong, nonatomic) UIButton *littleDifficultButton;
@property (strong, nonatomic) UIButton *difficultButton;
@property (strong, nonatomic) UIButton *continueButton;
@property (assign, nonatomic) NSInteger difficulty;

@property (strong, nonatomic) SelectedDifficulty selectBlock;

- (instancetype)initWithFrame:(CGRect)frame clickBlock:(SelectedDifficulty)block;


@end
