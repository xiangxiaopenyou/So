//
//  FoodCell.m
//  fitplus
//
//  Created by 天池邵 on 15/6/29.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "GoodCell.h"
#import "ClockInCommons.h"
#import "FoodModel.h"
#import "ClockInGoodModel.h"
#import "HigherSlider.h"

@interface GoodCell ()
@property (weak, nonatomic) IBOutlet HigherSlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *calorieLabel;
@property (weak, nonatomic) IBOutlet UILabel *usageLabel;
@property (weak, nonatomic) IBOutlet UILabel *transformLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *formulaLabel;
@property (copy, nonatomic) CalorieChangeHandler handler;
@property (strong, nonatomic) ClockInGoodModel *good;

@end

@implementation GoodCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupWithGood:(ClockInGoodModel *)good value:(NSInteger)value handler:(CalorieChangeHandler)handler {
    _handler = handler;
    _good = good;
    [_slider setThumbImage:[UIImage imageNamed:@"higherslider_thumb"] forState:UIControlStateNormal];
    [_slider setThumbImage:[UIImage imageNamed:@"higherslider_thumb"] forState:UIControlStateHighlighted];
    [_slider setValue:0];
    
    if (value != 0) {
        [self.slider setValue:value];
        return;
    }
    
    _titleLabel.text = good.goodName;
    if (good.type) {
        _formulaLabel.text = [NSString stringWithFormat:@"%@大卡/%@", good.formula, good.unit];
        _transformLabel.text = [good.type integerValue] == 1 ? @"有氧运动" : @"无氧运动";
        
        _calorieLabel.textColor = kSportLabelOrangeColor;
        _usageLabel.textColor = kSportLabelOrangeColor;
        _slider.minimumTrackTintColor = kSportLabelOrangeColor;
        _transformLabel.textColor = kSportLabelOrangeColor;
    } else {
        _formulaLabel.text = [NSString stringWithFormat:@"%@大卡/%@克", good.formula, good.unit];
        _transformLabel.attributedText = [self transform:0 unit:good.transformUnit];
        _calorieLabel.textColor = kFoodLabelGreenColor;
        _usageLabel.textColor = kFoodLabelGreenColor;
        _slider.minimumTrackTintColor = kFoodLabelGreenColor;
        _transformLabel.textColor = kFoodLabelGreenColor;
    }
    _calorieLabel.text = @(0).stringValue;
    _usageLabel.attributedText = [self usage:0 unit:_good.type ? _good.unit : @"克"];
    _slider.maximumValue = [good.max_num floatValue];
}

- (IBAction)sliderValueChanged:(id)sender {
    NSInteger value = (NSInteger)(_slider.value + .5);
    _usageLabel.attributedText = [self usage:value unit:_good.type ? _good.unit : @"克"];
    if (_good.type) {
        _calorieLabel.text = [NSString stringWithFormat:@"%.1f", (value * [_good.formula doubleValue])];
    } else {
        _calorieLabel.text = [NSString stringWithFormat:@"%.1f", (value * [_good.formula doubleValue] / [_good.unit doubleValue])];
        _transformLabel.attributedText = [self transform:value / [_good.transformFormula doubleValue] unit:_good.transformUnit];
    }
    !_handler ?: _handler(value, _calorieLabel.text.doubleValue);
}

- (NSAttributedString *)usage:(NSInteger)value unit:(NSString *)unit {
    NSMutableAttributedString *usageString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld%@",(long)value, unit]];
    [usageString setAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithWhite:0.665 alpha:1.000]}
                         range:[usageString.string rangeOfString:unit]];
    return usageString;
}

- (NSAttributedString *)transform:(CGFloat)value unit:(NSString *)unit {
    NSMutableAttributedString *usageString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"约%.1f%@",value ,unit]];
    [usageString setAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithWhite:0.665 alpha:1.000]}
                         range:[usageString.string rangeOfString:@"约"]];
    
    [usageString setAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithWhite:0.665 alpha:1.000]}
                         range:[usageString.string rangeOfString:unit]];
    return usageString;
}
@end
