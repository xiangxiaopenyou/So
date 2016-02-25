//
//  ThirdGuideViewController.m
//  fitplus
//
//  Created by xlp on 15/6/30.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "ThirdGuideViewController.h"
#import "CommonsDefines.h"
#import "PersonalModel.h"
#import "ForthGuideViewController.h"

@interface ThirdGuideViewController ()
@property (weak, nonatomic) IBOutlet UIButton *runningButton;
@property (weak, nonatomic) IBOutlet UIButton *reduceButton;
@property (weak, nonatomic) IBOutlet UIButton *rideButton;
@property (weak, nonatomic) IBOutlet UIButton *fitButton;
@property (weak, nonatomic) IBOutlet UIButton *foodButton;
@property (copy, nonatomic) NSString *hobbiesId;

@end

@implementation ThirdGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)chooseHobbies {
    [PersonalModel chooseMyHobbiesWith:_hobbiesId handler:^(id object, NSString *msg) {
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:IsNewUserKey];
        //[self.navigationController popToRootViewControllerAnimated:YES];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        ForthGuideViewController *forthView = [[UIStoryboard storyboardWithName:@"Guide" bundle:nil] instantiateViewControllerWithIdentifier:@"ForthGuideView"];
        [self.navigationController pushViewController:forthView animated:YES];
    }];
}
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)finishButtonClick:(id)sender {
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
