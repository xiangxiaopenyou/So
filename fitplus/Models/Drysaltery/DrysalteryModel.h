//
//  DrysalteryModel.h
//  fitplus
//
//  Created by xlp on 15/8/7.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "BaseModel.h"

@interface DrysalteryModel : BaseModel
@property (copy, nonatomic) NSString *dryId;
@property (copy, nonatomic) NSString *userid;
@property (copy, nonatomic) NSString *nickname;
@property (copy, nonatomic) NSString *createdate;
@property (copy, nonatomic) NSString *headimage;
@property (copy, nonatomic) NSNumber *commendSum;
@property (copy, nonatomic) NSNumber *readsum;
@property (copy, nonatomic) NSString *area;
@property (copy, nonatomic) NSString *labelName;
@property (copy, nonatomic) NSString *portrait;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString<Optional> *articleFavoriteId;


+ (void)fetchDryListWith:(NSInteger)limit handler:(RequestResultHandler)handler;
+ (void)drysalteryDetailWith:(NSString *)articleId handler:(RequestResultHandler)handler;
+ (void)collectDrysalteryWith:(NSString *)articleId handler:(RequestResultHandler)handler;
+ (void)cancelCollectDrysalteryWith:(NSString *)articleId handler:(RequestResultHandler)handler;
+ (void)drysalteryCollectionListWith:(NSInteger)limit friendId:(NSString *)friendId handler:(RequestResultHandler)handler;
+ (void)fetchDryVideoWith:(NSString *)articleId handler:(RequestResultHandler)handler;

@end
