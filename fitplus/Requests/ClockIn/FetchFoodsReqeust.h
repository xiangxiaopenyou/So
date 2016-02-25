//
//  FetchFoodsReqeust.h
//  fitplus
//
//  Created by 天池邵 on 15/6/29.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "RBRequest.h"

@interface FetchFoodsReqeust : RBRequest
@property (copy, nonatomic) NSString *foodName;
@property (assign, nonatomic) NSInteger limit;
@end
