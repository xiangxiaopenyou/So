//
//  ClockInGoodModel.m
//  fitplus
//
//  Created by 天池邵 on 15/6/30.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "ClockInGoodModel.h"
#import "ClockInRecordRequest.h"

@implementation ClockInGoodModel

- (BOOL)isEqual:(id)object {
    BOOL isEqual = YES;
    if ([object isMemberOfClass:[ClockInGoodModel class]]) {
        isEqual = NO;
    } else if (self.goodId != [(ClockInGoodModel *)object goodId]) {
        isEqual = NO;
    } else if (![self.goodName isEqualToString:[(ClockInGoodModel *)object goodName]]) {
        isEqual = NO;
    }
    
    return isEqual;
}

+ (void)fetchGoodRank:(RequestResultHandler)handler {
}

+ (void)fetchGoodByName:(NSString *)name limit:(NSInteger)limit handler:(RequestResultHandler)handler {
}

+ (void)clockIn:(NSArray *)modelArray handler:(RequestResultHandler)handler {
}

+ (void)record:(NSArray *)goods calories:(CGFloat)calories image:(UIImage *)image tags:(NSArray *)tags content:(NSString *)content handler:(RequestResultHandler)handler {
    NSMutableDictionary *record = [[[self class] buildRecordWithRecord:goods calories:calories tags:tags content:content] mutableCopy];
    if (image) {
        [[QNImageUploadRequest new] request:^BOOL(QNImageUploadRequest *request) {
            request.images = @[image];
            return YES;
        } result:^(id object, NSString *msg) {
            if (msg) {
                !handler ?: handler(nil, msg);
            } else {
                [record setObject:[object firstObject] forKey:@"trendpicture"];
                [[self class] clockInWithRecord:record handler:handler];
            }
        }];
    } else {
        [[self class] clockInWithRecord:record handler:handler];
    }
}

+ (void)clockInWithRecord:(NSDictionary *)record handler:(RequestResultHandler)handler {
    [[ClockInRecordRequest new] request:^BOOL(ClockInRecordRequest *request) {
        request.records = @[record];
        return YES;
    } result:handler];
}

+ (NSDictionary *)buildRecordWithRecord:(NSArray *)goods calories:(CGFloat)calories tags:(NSArray *)tags content:(NSString *)content {
    NSMutableDictionary *record = [@{
                                    @"time"            : @([[NSDate date] timeIntervalSince1970]),
                                    } mutableCopy];
    
    if (content && ![content isEqualToString:@""]) {
        [record setObject:content forKey:@"trendcontent"];
    }
    
    NSMutableString *trendtype = [NSMutableString string];
    for (PhotoTagModel *tag in tags) {
        [trendtype appendFormat:@"%@;", @(tag.tagId).stringValue];
    }
    if (trendtype.length > 0) {
        [trendtype deleteCharactersInRange:NSMakeRange(trendtype.length - 1, 1)];
        [record setObject:trendtype forKey:@"trendtype"];
        NSString *tags_json = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:[tags rb_dictionaryArray] options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
        [record setObject:tags_json forKey:@"playcard_tag"];
    }
    return record;
}
@end
