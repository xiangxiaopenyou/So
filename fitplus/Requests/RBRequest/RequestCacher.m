//
//  RequestCacher.m
//  fitplus
//
//  Created by 天池邵 on 15/7/13.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "RequestCacher.h"
#import "RequestManager.h"

#define kRequestCachePath [NSString stringWithFormat:@"%@/Library/Caches/r_caches.c", NSHomeDirectory()]


@interface RequestCacher ()
@property (assign, nonatomic) BOOL isReloading;
@end


@implementation RequestCacher

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static RequestCacher *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    
    return instance;
}

- (void)cacheRequest:(NSString *)request method:(NSString *)method param:(NSDictionary *)param {
    NSDictionary *cacheRequestInfo = @{@"request" : request, @"method" : method, @"param" : param};
    NSData *cacheData = [NSData dataWithContentsOfFile:kRequestCachePath];
    NSMutableArray *cachedRequests;
    if (cacheData) {
        cachedRequests = [NSJSONSerialization JSONObjectWithData:cacheData options:NSJSONReadingMutableContainers error:nil];
    }
    if (!cachedRequests) {
        cachedRequests = [NSMutableArray array];
    }
    
    [cachedRequests addObject:cacheRequestInfo];
    NSData *newCacheData = [NSJSONSerialization dataWithJSONObject:cachedRequests options:NSJSONWritingPrettyPrinted error:nil];
    [newCacheData writeToFile:kRequestCachePath atomically:YES];
}

- (void)reloadRequest {
    if (_isReloading) {
        return;
    }
    _isReloading = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *cacheData = [NSData dataWithContentsOfFile:kRequestCachePath];
        NSMutableArray *cachedRequests;
        if (cacheData) {
            cachedRequests = [NSJSONSerialization JSONObjectWithData:cacheData options:NSJSONReadingMutableContainers error:nil];
        }
        if (!cachedRequests) {
            cachedRequests = [NSMutableArray array];
        }
        NSMutableArray *lastCacheRequests = [cachedRequests mutableCopy];
        for (NSDictionary *cachedRequest in cachedRequests) {
            if (![AFNetworkReachabilityManager sharedManager].isReachable) {
                break;
            }
            NSString *method = cachedRequest[@"method"];
            NSString *request = cachedRequest[@"request"];
            NSDictionary *param = cachedRequest[@"param"];
            id success = ^(NSURLSessionDataTask *task, id responseObject) {
                [lastCacheRequests removeObjectAtIndex:[cachedRequests indexOfObject:cachedRequest]];
                if (cachedRequest == cachedRequests.lastObject) {
                    NSData *newCacheData = [NSJSONSerialization dataWithJSONObject:lastCacheRequests options:NSJSONWritingPrettyPrinted error:nil];
                    [newCacheData writeToFile:kRequestCachePath atomically:YES];
                }
                
                if ([responseObject[@"state"] integerValue] == 1000) {
                    NSLog(@"%@", @"request send success");
                } else {
                    NSLog(@"request send failed %@", responseObject[@"msg"]);
                }
            };
            id failure = ^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"request send failed %@", error.description);
            };
            if ([method isEqualToString:@"POST"]) {
                [[RequestManager sharedInstance] POST:request parameters:param success:success failure:failure];
            } else if ([method isEqualToString:@"GET"]) {
                [[RequestManager sharedInstance] GET:request parameters:param success:success failure:failure];
            }
        }
        
        _isReloading = NO;
    });
}

@end
