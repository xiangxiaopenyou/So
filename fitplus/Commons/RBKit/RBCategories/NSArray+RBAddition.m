//
//  NSArray+RBAddition.m
//  RainbowKit
//
//  Created by 天池邵 on 15/3/26.
//  Copyright (c) 2015年 rainbow. All rights reserved.
//

#import "NSArray+RBAddition.h"
#import "BaseModel.h"

@implementation NSArray (RBAddition)
- (NSArray *)rb_map:(id (^)(id))mapBlock {
    NSMutableArray *mapResultArr = [NSMutableArray array];
    for (id object in self) {
        [mapResultArr addObject:mapBlock(object)];
    }
    
    return mapResultArr;
}

- (NSArray *)rb_filte:(BOOL (^)(id))filterBlock {
    NSMutableArray *filteResultArr = [NSMutableArray array];
    for (id object in self) {
        if (filterBlock(object)) {
            [filteResultArr addObject:object];
        }
    }
    
    return filteResultArr;
}

- (NSString *)rb_mergerString {
    NSMutableString *resultString = [NSMutableString string];
    for (id object in self) {
        if ([object isKindOfClass:[NSString class]]) {
            [resultString appendString:object];
        }
    }
    
    return resultString;
}

- (NSString *)rb_mergerStringWithSymbol:(NSString *)symbol {
    NSMutableString *resultString = [NSMutableString string];
    for (id object in self) {
        if ([object isKindOfClass:[NSString class]]) {
            [resultString appendString:object];
            [resultString appendString:symbol];
        }
    }
    
    [resultString deleteCharactersInRange:NSMakeRange(resultString.length - 1, 1)];
    
    return resultString;
}
@end
