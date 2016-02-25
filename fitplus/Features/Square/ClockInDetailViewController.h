//
//  ClockInViewController.h
//  fitplus
//
//  Created by xlp on 15/7/6.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClockInDetailViewController : UIViewController
@property (copy, nonatomic) NSString *clockinId;
@property (assign, nonatomic) BOOL isCommentIn;

- (IBAction)sendButtonClick:(id)sender;

@end
