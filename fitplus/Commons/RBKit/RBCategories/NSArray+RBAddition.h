//
//  NSArray+RBAddition.m
//  RainbowKit
//
//  Created by 天池邵 on 15/3/26.
//  Copyright (c) 2015年 rainbow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (RBAddition)
- (NSArray *)rb_map:(id(^)(id object))mapBlock;
- (NSArray *)rb_filte:(BOOL (^)(id))filterBlock;
- (NSString *)rb_mergerString;
- (NSString *)rb_mergerStringWithSymbol:(NSString *)symbol;
@end
