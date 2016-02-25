//
//  CourseDayCell.m
//  fitplus
//
//  Created by xlp on 15/9/29.
//  Copyright © 2015年 realtech. All rights reserved.
//

#import "CourseDayCell.h"

@implementation CourseDayCell
//- (void)setupContentWith:(NSDictionary *)dayDictionary {
//    if ([dayDictionary[@"enable"] integerValue] == 0) {
//        
//    }
//}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)buttonClick:(id)sender {
    if (_canClick) {
        if (_selectedDay) {
            _selectedDay(_rowIndex);
        }
    }
    
}
- (void)selected:(SelectedDay)day {
    _selectedDay = day;
}

@end
