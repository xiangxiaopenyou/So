//
//  CourseTrainingViewController.h
//  fitplus
//
//  Created by xlp on 15/10/8.
//  Copyright © 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseModel.h"

@interface CourseTrainingViewController : UIViewController
@property (copy, nonatomic) NSMutableDictionary *actionDictionary;
@property (strong, nonatomic) CourseModel *courseModel;
@property (strong, nonatomic) NSMutableArray *videoArray;

@end
