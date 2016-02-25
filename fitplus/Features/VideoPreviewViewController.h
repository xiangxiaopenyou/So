//
//  VideoPreviewViewController.h
//  fitplus
//
//  Created by xlp on 15/9/30.
//  Copyright © 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseModel.h"

@interface VideoPreviewViewController : UIViewController
@property (assign, nonatomic) NSInteger previewIndex;
@property (copy, nonatomic) NSArray *actionArray;
@property (strong, nonatomic) CourseModel *model;
@property (copy, nonatomic) NSString *dayId;


@end
