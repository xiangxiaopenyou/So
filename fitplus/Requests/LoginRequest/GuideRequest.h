//
//  GuideRequest.h
//  fitplus
//
//  Created by xlp on 15/6/30.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "RBRequest.h"

@interface GuideRequest : RBRequest

@property (copy, nonatomic) NSString *height;
//@property (copy, nonatomic) NSString *targetWeight;
@property (copy, nonatomic) NSString *weight;
@property (copy, nonatomic) NSString *sex;
//@property (copy, nonatomic) NSString *duration;
@property (copy, nonatomic) NSString *age;

@end
