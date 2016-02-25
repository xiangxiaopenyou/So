//
//  RBChartDefines.h
//  RBChart
//
//  Created by Shao.Tc on 15/7/5.
//  Copyright (c) 2015年 rainbow. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RBChartInitHandler)(id);

#define t(x, y) ^(CGRect rect){\
UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect:rect];\
[x setFill];\
[y setStroke];\
return ovalPath;\
}

#define kSolidRound(F, S) ^(CGRect rect){\
                        UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect:rect];\
                        [F setFill];\
                        [ovalPath fill];\
                        [S setStroke];\
                        [ovalPath stroke];\
                    }

#define kHollowRound(F, S, W) ^(CGRect rect) {\
                        UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect:rect];\
                        [F setFill];\
                        [ovalPath fill];\
                        ovalPath.lineWidth = W;\
                        [S setStroke];\
                        [ovalPath stroke];\
                     }