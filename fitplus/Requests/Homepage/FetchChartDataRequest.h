//
//  FetchChartDataRequest.h
//  fitplus
//
//  Created by 天池邵 on 15/7/10.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "RBRequest.h"

@interface FetchChartDataRequest : RBRequest
@property (copy, nonatomic) NSString *oldday;
@property (copy, nonatomic) NSString *newday;
@end
