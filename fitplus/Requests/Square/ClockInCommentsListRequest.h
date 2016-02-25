//
//  ClockInCommentsListRequest.h
//  fitplus
//
//  Created by xlp on 15/7/8.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "RBRequest.h"

@interface ClockInCommentsListRequest : RBRequest
@property (copy, nonatomic) NSString *trendid;
@property (assign, nonatomic) NSInteger limit;

@end
