//
//  FetchCalorieDataRequest.h
//  fitplus
//
//  Created by 天池邵 on 15/7/3.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "RBRequest.h"

@interface FetchCalorieDataRequest : RBRequest
@property (assign, nonatomic) NSInteger friendId;
@property (copy, nonatomic) NSString *day;
@end
