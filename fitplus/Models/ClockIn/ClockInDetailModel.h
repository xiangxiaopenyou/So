//
//  ClockInDetailModel.h
//  fitplus
//
//  Created by xlp on 15/7/6.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "BaseModel.h"

@interface ClockInDetailModel : BaseModel
@property (copy, nonatomic) NSString *id;
@property (copy, nonatomic) NSString *userid;
@property (copy, nonatomic) NSString *headPortraintString;
@property (copy, nonatomic) NSString *nickname;
@property (copy, nonatomic) NSString *created_time;
@property (copy, nonatomic) NSString *clockinContent;
@property (copy, nonatomic) NSString *clockinPicture;
@property (copy, nonatomic) NSString *clockinAddress;
@property (assign, nonatomic) float foodEnergy;
@property (copy, nonatomic) NSString *foodName;
@property (assign, nonatomic) float sportsEnergy;
@property (copy, nonatomic) NSString *sportsName;
@property (copy, nonatomic) NSString *clockinTag;
@property (assign, nonatomic) NSInteger isfavorite;
@property (assign, nonatomic) NSInteger clockinType;
@property (assign, nonatomic) NSInteger commentNumber;
@property (assign, nonatomic) NSInteger likeNumber;

+ (void)fetchClockInDetail:(NSString *)trendid handler:(RequestResultHandler)handler;
+ (void)fetchFriendsClockIn:(NSInteger)limit handler:(RequestResultHandler)handler;

@end
