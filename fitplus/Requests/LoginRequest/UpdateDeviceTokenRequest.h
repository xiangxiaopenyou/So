//
//  UpdateDeviceTokenRequest.h
//  fitplus
//
//  Created by 天池邵 on 15/7/13.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "RBRequest.h"

@interface UpdateDeviceTokenRequest : RBRequest
@property (copy, nonatomic) NSString *deviceToken;
@end
