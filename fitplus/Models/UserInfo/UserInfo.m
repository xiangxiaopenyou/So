//
//  UserInfo.m
//  fitplus
//
//  Created by xlp on 15/6/26.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "UserInfo.h"
#import "CommonsDefines.h"

@implementation UserInfo
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"portrait" : @"headportrait",
                                                       @"flag" : @"isAttention"}];
}

+ (BOOL)userHaveLogin {
    return [[NSUserDefaults  standardUserDefaults] objectForKey:UserIdKey] && [[NSUserDefaults standardUserDefaults] objectForKey:UserTokenKey];
}
@end
