//
//  AttentionRequest.h
//  fitplus
//
//  Created by 陈 on 15/7/4.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "RBRequest.h"
@interface AttentionRequest : RBRequest
@property (nonatomic ,strong)NSString *frendid;
@property (nonatomic ,assign)NSInteger limit;
@end
