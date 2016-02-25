//
//  QNImageUploadRequest.h
//  fitplus
//
//  Created by 天池邵 on 15/7/2.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "RBRequest.h"

@interface QNImageUploadRequest : RBRequest
@property (copy, nonatomic) NSArray *images;
@end
