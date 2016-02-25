//
//  CourseDetailViewController.h
//  fitplus
//
//  Created by xlp on 15/9/28.
//  Copyright © 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseModel.h"

@interface CourseDetailViewController : UIViewController
@property (strong, nonatomic) CourseModel *courseModel;
@property (assign, nonatomic) NSInteger selectedType;
@property (assign, nonatomic) BOOL isJoin;

@end
