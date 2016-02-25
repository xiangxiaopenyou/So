//
//  CourseDayCell.h
//  fitplus
//
//  Created by xlp on 15/9/29.
//  Copyright © 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^SelectedDay)(NSInteger index);


@interface CourseDayCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *stateImage;
@property (weak, nonatomic) IBOutlet UILabel *courseDayNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseDaysTime;
@property (assign, nonatomic) NSInteger rowIndex;
@property (assign, nonatomic) BOOL canClick;
@property (strong, nonatomic) SelectedDay selectedDay;

//- (void)setupContentWith:(NSDictionary *)dayDictionary;
- (void)selected:(SelectedDay)day;

@end
