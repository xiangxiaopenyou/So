//
//  FetchSportRequest.h
//  fitplus
//
//  Created by 天池邵 on 15/6/30.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "RBRequest.h"

@interface FetchSportRequest : RBRequest
@property (copy, nonatomic) NSString *sportName;
@property (assign, nonatomic) NSInteger limit;
@end
