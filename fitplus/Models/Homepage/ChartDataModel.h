//
//  ChartDataModel.h
//  fitplus
//
//  Created by 天池邵 on 15/7/10.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "BaseModel.h"

@interface ChartDataModel : BaseModel
+ (void)fetchChartData:(NSString *)oldday newday:(NSString *)newday handler:(RequestResultHandler)handler;
@end
