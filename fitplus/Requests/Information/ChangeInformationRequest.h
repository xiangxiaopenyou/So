//
//  ChangeInformationRequest.h
//  fitplus
//
//  Created by 陈 on 15/7/15.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "RBRequest.h"

@interface ChangeInformationRequest : RBRequest

@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *weightT;
@property (nonatomic, strong) NSString *weight;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *duration;
@property (nonatomic, strong) UIImage *portrait;
@property (nonatomic, strong) NSString *introduce;
@property (nonatomic, strong) NSString *height;
@property (nonatomic, strong) NSString *portrait2;

@end
