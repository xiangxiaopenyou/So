//
//  FetchLagRequest.h
//  fitplus
//
//  Created by xlp on 15/7/15.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "RBRequest.h"

@interface FetchLagRequest : RBRequest
@property (copy, nonatomic) NSString *like;
@property (assign, nonatomic) NSInteger limit;

@end
