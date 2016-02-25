//
//  BaseModel.h
//  Coach
//
//  Created by 天池邵 on 15/6/16.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "JSONModel.h"
#import "RBRequest.h"

@interface NSArray (ModelAddition)
- (NSArray *)rb_dictionaryArray;
@end

@interface BaseModel : JSONModel
+ (NSArray *)setupWithArray:(NSArray *)arr;
+ (NSArray *)dictionaryArrayFromModelArray:(NSArray *)arr;
@end
