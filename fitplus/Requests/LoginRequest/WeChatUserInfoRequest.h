//
//  WeChatUserInfoRequest.h
//  fitplus
//
//  Created by xlp on 15/6/29.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "RBRequest.h"

@interface WeChatUserInfoRequest : RBRequest

@property (nonatomic, copy) NSString *openid;
@property (nonatomic, copy) NSString *accessToken;

@end
