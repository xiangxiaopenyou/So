//
//  ChooseLabelViewController.h
//  fitplus
//
//  Created by xlp on 15/7/15.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ChooseLabelDelegate<NSObject>
@optional
- (void)chooseLabel:(NSString *)labelName id:(NSInteger)labelId;
@end

@interface ChooseLabelViewController : UIViewController
@property (strong, nonatomic) id<ChooseLabelDelegate> delegate;

@end
