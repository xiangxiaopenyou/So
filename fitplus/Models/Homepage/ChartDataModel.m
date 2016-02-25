//
//  ChartDataModel.m
//  fitplus
//
//  Created by 天池邵 on 15/7/10.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "ChartDataModel.h"
#import "FetchChartDataRequest.h"

@implementation ChartDataModel
+ (void)fetchChartData:(NSString *)oldday newday:(NSString *)newday handler:(RequestResultHandler)handler {
     [[FetchChartDataRequest new] request:^BOOL(FetchChartDataRequest *request) {
         request.oldday = oldday;
         request.newday = newday;
         return YES;
     } result: handler];
}
@end
