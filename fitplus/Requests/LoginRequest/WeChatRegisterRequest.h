//
//  WeChatRegisterRequest.h
//  fitplus
//
//  Created by xlp on 15/6/29.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "RBRequest.h"

@interface WeChatRegisterRequest : RBRequest

@property (nonatomic, copy) NSString *openid;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *systemType;
@property (nonatomic, copy) NSString *headportrait;

@end
