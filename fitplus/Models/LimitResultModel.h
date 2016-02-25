//
//  LimitResultModel.h
//  fitplus
//
//  Created by 天池邵 on 15/6/30.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BaseModel;

@interface LimitResultModel : NSObject
@property (strong, nonatomic) id result;
@property (assign, nonatomic) BOOL haveMore;
@property (assign, nonatomic) NSInteger limit;
@property (assign, nonatomic) NSInteger page;

- (instancetype)initWithResultDictionary:(NSDictionary *)dic modelKey:(NSString *)key modelClass:(BaseModel *)modelClass;
- (instancetype)initWithNewResult:(NSDictionary *)dic modelKey:(NSString *)key modelClass:(BaseModel *)modelClass;
@end
