//
//  VideoModel.h
//  fitplus
//
//  Created by xlp on 15/9/30.
//  Copyright © 2015年 realtech. All rights reserved.
//

#import "BaseModel.h"

@interface VideoModel : BaseModel
@property (copy, nonatomic) NSString *picurl;
@property (assign, nonatomic) NSInteger duration;
@property (copy, nonatomic) NSString *voice;
@property (copy, nonatomic) NSString *video_name;
@property (copy, nonatomic) NSString *path;
@property (copy, nonatomic) NSString *intervals;
@property (assign, nonatomic) NSInteger group_num;
@property (assign, nonatomic) NSInteger num;
@property (copy, nonatomic) NSString *tag;
@property (copy, nonatomic) NSString *id;
@property (copy, nonatomic) NSString *content;
@property (assign, nonatomic) NSInteger type;

+ (void)fetchVideoListOfDay:(NSString *)dayid handler:(RequestResultHandler)handler;

@end
