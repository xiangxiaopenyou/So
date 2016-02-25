//
//  BackHomeViewController.h
//  fitplus
//
//  Created by 陈 on 15/6/30.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InformationViewController : UIViewController
@property (strong, nonatomic)NSString *friendid;
@property (assign, nonatomic)NSInteger limit;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIButton *Attention;
@property (weak, nonatomic) IBOutlet UIButton *fansButton;
@property (weak, nonatomic) IBOutlet UILabel *signatureLabel;
@property (weak, nonatomic) IBOutlet UIButton *VariableButton;
@property (weak, nonatomic) IBOutlet UILabel *cardDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *imagePageLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardSumDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *ConsumptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *infoSexImage;

@end
