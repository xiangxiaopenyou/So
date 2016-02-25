//
//  FetchUserTrendsRequest.h
//  fitplus
//
//  Created by xlp on 15/10/28.
//  Copyright © 2015年 realtech. All rights reserved.
//

#import "RBRequest.h"

@interface FetchUserTrendsRequest : RBRequest
@property (copy, nonatomic) NSString *otherId;
@property (assign, nonatomic) NSInteger page;

@end
