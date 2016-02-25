//
//  CourseDetailRequest.h
//  fitplus
//
//  Created by xlp on 15/9/28.
//  Copyright © 2015年 realtech. All rights reserved.
//

#import "RBRequest.h"

@interface CourseDetailRequest : RBRequest
@property (copy, nonatomic) NSString *courseId;
@end
