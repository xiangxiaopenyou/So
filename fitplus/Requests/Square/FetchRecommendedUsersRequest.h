//
//  FetchRecommendedUsersRequest.h
//  fitplus
//
//  Created by xlp on 15/7/9.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "RBRequest.h"

@interface FetchRecommendedUsersRequest : RBRequest
@property (assign, nonatomic) NSInteger limit;

@end
