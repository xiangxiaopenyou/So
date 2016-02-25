//
//  RecommendationModel.h
//  fitplus
//
//  Created by xlp on 15/7/7.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "BaseModel.h"

@interface RecommendationModel : BaseModel

+ (void)fetchRecommendationContent:(RequestResultHandler)handler;
+ (void)fetchTopicList:(RequestResultHandler)handler;
+ (void)fetchActivities:(RequestResultHandler)handler;
+ (void)clockInLike:(NSString *)trendId handler:(RequestResultHandler)handler;
+ (void)clockInDislike:(NSString *)trendId handler:(RequestResultHandler)handler;
+ (void)clockinReport:(NSString *)reportId type:(NSString *)reportType handler:(RequestResultHandler)handler;
+ (void)fetchMoreClockInOfTopic:(NSString *)topicId handler:(RequestResultHandler)handler;
+ (void)fetchTodayRecommendation:(NSInteger)limit handler:(RequestResultHandler)handler;

@end
