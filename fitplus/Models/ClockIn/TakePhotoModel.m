//
//  TakePhotoModel.m
//  fitplus
//
//  Created by xlp on 15/8/21.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "TakePhotoModel.h"

@implementation TakePhotoModel
+ (NSDictionary *)buildRecordWithRecord:(NSArray *)goods calories:(CGFloat)calories tags:(NSArray *)tags content:(NSString *)content {
    NSMutableDictionary *record = [[super buildRecordWithRecord:goods calories:calories tags:tags content:content] mutableCopy];
    [record setObject:@(3) forKey:@"trendsportstype"];
    return record;
}

@end
