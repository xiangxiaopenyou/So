//
//  JoinCourseRequest.h
//  fitplus
//
//  Created by xlp on 15/10/9.
//  Copyright © 2015年 realtech. All rights reserved.
//

#import "RBRequest.h"

@interface JoinCourseRequest : RBRequest
@property (copy, nonatomic) NSString *courseId;
@property (copy, nonatomic) NSString *dayIdString;

@end
