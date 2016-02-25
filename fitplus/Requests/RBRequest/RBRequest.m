//
//  RBRequest.m
//  RainbowKit
//
//  Created by 天池邵 on 15/4/23.
//  Copyright (c) 2015年 Rainbow. All rights reserved.
//

#import "RBRequest.h"
#import "CommonsDefines.h"
#import <CommonCrypto/CommonDigest.h>
#import "RequestCacher.h"

static NSString *const AppId = @"*}{rA4_|:,";
static NSString *const Secret = @"e799a8ce9b00ddaa";

@implementation RBRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    
}

- (BOOL)checkToken:(NSDictionary *)responseObject {
    if ([responseObject[@"state"] integerValue] == 1006 || [responseObject[@"state"] integerValue] == 1008) {
        [[NSNotificationCenter defaultCenter] postNotificationName:LogoutKey object:nil userInfo:nil];
        return NO;
    } else {
        return YES;
    }
}

- (NSString *)token {
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"token"];
}

- (NSDictionary *)buildParam:(NSDictionary *)dic {
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithDictionary:dic];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //设置+8区 北京时间
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    NSTimeInterval signTime = [[formatter dateFromString:dateStr] timeIntervalSince1970];
    [param setObject:@(signTime) forKey:@"signtime"];
    [param setObject:@"md5" forKey:@"signmethod"];
    [param setObject:AppId forKey:@"appid"];
    
    NSArray *keys = [[param allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    NSMutableString *sign_str = [NSMutableString string];
    for (NSString *key in keys) {
        [sign_str appendFormat:@"%@%@",key,param[key]];
    }
    [sign_str appendString:Secret];
    
    [param setObject:[self md5:sign_str] forKey:@"signid"];
    
    return param;
}

- (NSString *)md5:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (unsigned int)strlen(cStr),result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

- (void)cacheRequest:(NSString *)request method:(NSString *)method param:(NSDictionary *)param {
    [[RequestCacher sharedInstance] cacheRequest:request method:method param:param];
}

- (NSString *)handlerError:(NSError *)error {
    NSString *errorMsg;
    if (error.code == -1009) {
        errorMsg = @"没有网络";
    } else {
        errorMsg = error.description;
    }
    
    return errorMsg;
}
@end
