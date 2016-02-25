//
//  ClockInReportRequest.h
//  fitplus
//
//  Created by xlp on 15/7/10.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "RBRequest.h"

@interface ClockInReportRequest : RBRequest
@property (copy, nonatomic) NSString *reportId;
@property (copy, nonatomic) NSString *reportType;

@end
