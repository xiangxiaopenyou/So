//
//  RequestCacher.h
//  fitplus
//
//  Created by 天池邵 on 15/7/13.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestCacher : NSObject
@property (copy, nonatomic) NSString *method;
@property (copy, nonatomic) NSDictionary *param;

+ (instancetype)sharedInstance;

- (void)cacheRequest:(NSString *)request method:(NSString *)method param:(NSDictionary *)param;

- (void)reloadRequest;
@end
