//
//  FetchDrysalteryCollectionListRequest.h
//  fitplus
//
//  Created by xlp on 15/8/11.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "RBRequest.h"

@interface FetchDrysalteryCollectionListRequest : RBRequest
@property (assign, nonatomic) NSInteger limit;
@property (copy, nonatomic) NSString *friendId;

@end
