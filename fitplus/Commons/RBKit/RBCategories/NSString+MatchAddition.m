//
//  NSString+MatchAddition.m
//  RainbowKit
//
//  Created by 天池邵 on 15/5/6.
//  Copyright (c) 2015年 Rainbow. All rights reserved.
//

#import "NSString+MatchAddition.h"

@implementation NSString (MatchAddition)
- (BOOL)matchEmail {
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:@"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}" options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray *match = [reg matchesInString:self options:NSMatchingReportCompletion range:NSMakeRange(0, [self length])];
    return (match && match.count > 0);
}

- (BOOL)matchTel {
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:@"^(134|135|136|137|138|139|147|150|151|152|157|158|159|182|187|188|130|131|132|155|156|185|186|133|153|180|189|177|178|176)\\d{8}$" options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *match = [reg matchesInString:self options:NSMatchingReportCompletion range:NSMakeRange(0, [self length])];
    return (match && match.count > 0);
}

@end
