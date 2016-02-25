//
//  RBLineData.h
//  RBChart
//
//  Created by Shao.Tc on 15/7/5.
//  Copyright (c) 2015年 rainbow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RBLineDecorator.h"
@interface RBLineData : NSObject
@property (copy, nonatomic) NSArray *values;
@property (strong, nonatomic) RBLineDecorator *lineDecorator;
@end
