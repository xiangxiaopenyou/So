//
//  ClockInRecordRequest.h
//  fitplus
//
//  Created by 天池邵 on 15/7/2.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "RBRequest.h"

@interface ClockInRecordRequest : RBRequest
@property (strong, nonatomic) NSArray *records;
@end
