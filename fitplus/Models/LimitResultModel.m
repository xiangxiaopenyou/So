//
//  LimitResultModel.m
//  fitplus
//
//  Created by 天池邵 on 15/6/30.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "LimitResultModel.h"
#import "BaseModel.h"

@implementation LimitResultModel
- (instancetype)initWithResultDictionary:(NSDictionary *)dic modelKey:(NSString *)key modelClass:(BaseModel *)modelClass {
    self = [super init];
    if (self) {
        if ([dic[@"limit"] integerValue] < [dic[@"total"] integerValue]) {
            _haveMore = YES;
        } else {
            _haveMore = NO;
        }
        
        _limit = [dic[@"limit"] integerValue];
        id result = dic[key];
        if ([result isKindOfClass:[NSArray class]]) {
            _result = [[modelClass class] setupWithArray:result];
        } else if ([result isKindOfClass:[NSDictionary class]]) {
            _result = [[[modelClass class] alloc] initWithDictionary:result error:nil];
        }
    }
    return self;
}
- (instancetype)initWithNewResult:(NSDictionary *)dic modelKey:(NSString *)key modelClass:(BaseModel *)modelClass {
    self = [super init];
    if (self) {
        if ([dic[@"page"] integerValue] < [dic[@"totalpage"] integerValue]) {
            _haveMore = YES;
            _page = [dic[@"page"] integerValue] + 1;
        } else {
            _haveMore = NO;
        }
        id result = dic[key];
        if ([result isKindOfClass:[NSArray class]]) {
            _result = [[modelClass class] setupWithArray:result];
        } else if ([result isKindOfClass:[NSDictionary class]]) {
            _result = [[[modelClass class] alloc] initWithDictionary:result error:nil];
        }
    }
    return self;
}
@end
