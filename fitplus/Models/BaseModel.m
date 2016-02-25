//
//  BaseModel.m
//  Coach
//
//  Created by 天池邵 on 15/6/16.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "BaseModel.h"

@implementation NSArray (ModelAddition)

- (NSArray *)rb_dictionaryArray {
    NSMutableArray *result = [NSMutableArray array];
    for (BaseModel *model in self) {
        NSDictionary * dicInfo = [model toDictionary];
        [result addObject:dicInfo];
    }
    return result;
}
@end

@implementation BaseModel

+ (NSArray *)setupWithArray:(NSArray *)arr {
    NSMutableArray *resultArr = [NSMutableArray array];
    for (NSDictionary *dicInfo in arr) {
        NSError *error;
        BaseModel *model = [[[self class] alloc] initWithDictionary:dicInfo error:&error];
        [resultArr addObject:model];
        
    }
    return resultArr;
}

+ (NSArray *)dictionaryArrayFromModelArray:(NSArray *)arr {
    NSMutableArray *result = [NSMutableArray array];
    for (BaseModel *model in arr) {
        NSDictionary * dicInfo = [model toDictionary];
        [result addObject:dicInfo];
    }
    return result;
}

@end
