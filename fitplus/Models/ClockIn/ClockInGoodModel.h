//
//  ClockInGoodModel.h
//  fitplus
//
//  Created by 天池邵 on 15/6/30.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "BaseModel.h"
#import "LimitResultModel.h"
#import "PhotoTagModel.h"
#import "NSArray+RBAddition.h"
#import "QNImageUploadRequest.h"

@protocol ClockInGoodModel
@end

@interface ClockInGoodModel : BaseModel
@property (assign, nonatomic) NSInteger goodId;
@property (copy, nonatomic) NSString *goodName;
@property (copy, nonatomic) NSString *formula;   // 100 卡
@property (copy, nonatomic) NSString *unit;      // 100 克
@property (copy, nonatomic) NSString<Optional> *transformUnit;    // 碗
@property (copy, nonatomic) NSString<Optional> *transformFormula; // 1
@property (copy, nonatomic) NSString<Optional> *type;      //
@property (copy, nonatomic) NSString *max_num;

+ (void)fetchGoodRank:(RequestResultHandler)handler;
+ (void)fetchGoodByName:(NSString *)name limit:(NSInteger)limit handler:(RequestResultHandler)handler;

+ (void)record:(NSArray *)goods calories:(CGFloat)calories image:(UIImage *)image tags:(NSArray *)tags content:(NSString *)content handler:(RequestResultHandler)handler;
+ (NSDictionary *)buildRecordWithRecord:(NSArray *)goods calories:(CGFloat)calories tags:(NSArray *)tags content:(NSString *)content ;
+ (void)clockInWithRecord:(NSDictionary *)record handler:(RequestResultHandler)handler;
@end
