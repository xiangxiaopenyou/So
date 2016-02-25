//
//  FirstGuideViewController.h
//  fitplus
//
//  Created by xlp on 15/6/29.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstGuideViewController : UIViewController
@property (assign, nonatomic) NSInteger sex;
@property (strong, nonatomic) NSString *age;

@property (strong, nonatomic) IBOutlet UIPickerView *agePickerView;
@property (strong, nonatomic) IBOutlet UIButton *famaleButton;
@property (strong, nonatomic) IBOutlet UIButton *maleButton;

- (IBAction)maleButtonClick:(id)sender;
- (IBAction)famaleButtonClick:(id)sender;

@end
