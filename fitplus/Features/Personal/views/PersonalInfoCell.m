//
//  PersonalInfoCell.m
//  fitplus
//
//  Created by xlp on 15/7/2.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "PersonalInfoCell.h"
#import "PersonalCommons.h"

@interface PersonalInfoCell()
@property (strong, nonatomic) IBOutlet UIImageView *infoImage;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;

@end

@implementation PersonalInfoCell

- (void)setupInformation:(NSString *)imageString withInfoName:(NSString *)nameString {
  
    _infoLabel.textColor = kCellTextColor;
    _infoLabel.text = nameString;
    _infoImage.image = [UIImage imageNamed:imageString];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    UIView *selectedView = [[UIView alloc] initWithFrame:self.contentView.frame];
    selectedView.backgroundColor = [UIColor colorWithRed:94/255.0 green:81/255.0 blue:109/255.0 alpha:1.0];
    self.selectedBackgroundView = selectedView;

    // Configure the view for the selected state
}

@end
