//
//  WeChatAccessRequest.h
//  fitplus
//
//  Created by xlp on 15/6/26.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "RBRequest.h"

@interface WeChatAccessRequest : RBRequest

@property (nonatomic, copy) NSString *code;

@end
