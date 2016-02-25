//
//  SecondGuideViewController.h
//  fitplus
//
//  Created by xlp on 15/6/30.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondGuideViewController : UIViewController

@property (assign, nonatomic) NSInteger sex;
@property (strong, nonatomic) NSString *age;
@property (strong, nonatomic) NSString *weight;
@property (strong, nonatomic) NSString *height;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;

@end
