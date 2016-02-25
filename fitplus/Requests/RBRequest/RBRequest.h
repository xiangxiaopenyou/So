//
//  RBRequest.h
//  RainbowKit
//
//  Created by 天池邵 on 15/4/23.
//  Copyright (c) 2015年 Rainbow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestManager.h"
#import "CommonsDefines.h"

typedef BOOL(^ParamsBlock)(id request);
typedef void(^RequestResultHandler)(id object, NSString *msg);
@protocol RequestProtocol <NSObject>

@required
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler;

@end

@interface RBRequest : NSObject <RequestProtocol>
- (NSString *)token;
- (NSDictionary *)buildParam:(NSDictionary *)dic;

- (void)cacheRequest:(NSString *)request method:(NSString *)method param:(NSDictionary *)param;

- (NSString *)handlerError:(NSError *)error;
@end
