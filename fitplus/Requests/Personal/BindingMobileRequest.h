//
//  BindingMobileRequest.h
//  fitplus
//
//  Created by xlp on 15/7/13.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "RBRequest.h"

@interface BindingMobileRequest : RBRequest
@property (copy, nonatomic) NSString *phoneNumber;
@property (copy, nonatomic) NSString *code;

@end
