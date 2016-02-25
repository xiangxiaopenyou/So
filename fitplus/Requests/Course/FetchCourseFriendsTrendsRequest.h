//
//  FetchCourseFriendsTrendsRequest.h
//  fitplus
//
//  Created by xlp on 15/9/29.
//  Copyright © 2015年 realtech. All rights reserved.
//

#import "RBRequest.h"

@interface FetchCourseFriendsTrendsRequest : RBRequest
@property (copy, nonatomic) NSString *courseId;
@property (assign, nonatomic) NSInteger limit;

@end
