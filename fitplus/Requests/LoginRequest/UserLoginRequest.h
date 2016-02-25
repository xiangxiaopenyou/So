//
//  UserLoginRequest.h
//  fitplus
//
//  Created by xlp on 15/7/16.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "RBRequest.h"

@interface UserLoginRequest : RBRequest
@property (copy, nonatomic) NSString *nickname;
@property (copy, nonatomic) NSString *password;


@end
