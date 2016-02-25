//
//  ChooseHobbyViewController.m
//  fitplus
//
//  Created by xlp on 15/8/24.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "ChooseHobbyViewController.h"
#import "RBNoticeHelper.h"
#import "PersonalModel.h"

@interface ChooseHobbyViewController ()
@property (weak, nonatomic) IBOutlet UIButton *runningButton;
@property (weak, nonatomic) IBOutlet UIButton *reduceButton;
@property (weak, nonatomic) IBOutlet UIButton *rideButton;
@property (weak, nonatomic) IBOutlet UIButton *fitButton;
@property (weak, nonatomic) IBOutlet UIButton *foodButton;
@property (copy, nonatomic) NSString *hobbiesId;
@property (strong, nonatomic) NSMutableArray *hobbiesArray;

@end

@implementation ChooseHobbyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"选择你的兴趣";
    
    [self fetchMyHobbies];
}
- (void)fetchMyHobbies {
    [PersonalModel fetchMyHobbies:^(id object, NSString *msg) {
        if (!msg) {
            _hobbiesArray = [object[@"userData"] mutableCopy];
            if (_hobbiesArray.count > 0) {
                for (NSDictionary *tempDictionary in _hobbiesArray) {
                    if ([tempDictionary[@"partsid"] integerValue] == 10) {
                        _runningButton.selected = YES;
                    }
                    if ([tempDictionary[@"partsid"] integerValue] == 12) {
                        _reduceButton.selected = YES;
                    }
                    if ([tempDictionary[@"partsid"] integerValue] == 13) {
                        _rideButton.selected = YES;
                    }
                    if ([tempDictionary[@"partsid"] integerValue] == 11) {
                        _fitButton.selected = YES;
                    }
                    if ([tempDictionary[@"partsid"] integerValue] == 14) {
                        _foodButton.selected = YES;
                    }
                }
            }
        }
    }];
}
- (void)chooseHobbies {
    [PersonalModel chooseMyHobbiesWith:_hobbiesId handler:^(id object, NSString *msg) {
        if (msg) {
            [RBNoticeHelper showNoticeAtViewController:self msg:@"保存失败"];
        } else {
            [RBNoticeHelper showNoticeAtViewController:self msg:@"保存成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)runningButtonClick:(id)sender {
    if (_runningButton.selected) {
        _runningButton.selected = NO;
    } else {
        _runningButton.selected = YES;
    }
}
- (IBAction)reduceButtonClick:(id)sender {
    if (_reduceButton.selected) {
        _reduceButton.selected = NO;
    } else {
        _reduceButton.selected = YES;
    }
}
- (IBAction)rideButtonClick:(id)sender {
    if (_rideButton.selected) {
        _rideButton.selected = NO;
    } else {
        _rideButton.selected = YES;
    }
}
- (IBAction)fitButtonClick:(id)sender {
    if (_fitButton.selected) {
        _fitButton.selected = NO;
    } else {
        _fitButton.selected = YES;
    }
}
- (IBAction)foodButtonClick:(id)sender {
    if (_foodButton.selected) {
        _foodButton.selected = NO;
    } else {
        _foodButton.selected = YES;
    }
}
- (IBAction)finishButton:(id)sender {
    
    _hobbiesId = @"";
    if (_runningButton.selected) {
        _hobbiesId = [_hobbiesId stringByAppendingString:@"10,"];
    }
    if (_reduceButton.selected) {
        _hobbiesId = [_hobbiesId stringByAppendingString:@"12,"];
    }
    if (_rideButton.selected) {
        _hobbiesId = [_hobbiesId stringByAppendingString:@"13,"];
    }
    if (_fitButton.selected) {
        _hobbiesId = [_hobbiesId stringByAppendingString:@"11,"];
    }
    if (_foodButton.selected) {
        _hobbiesId = [_hobbiesId stringByAppendingString:@"14,"];
    }
    if ([_hobbiesId length] > 0) {
        _hobbiesId = [_hobbiesId substringWithRange:NSMakeRange(0, [_hobbiesId length] - 1)];
    } else {
        _hobbiesId = @"0";
    }
    [self chooseHobbies];
}

@end
