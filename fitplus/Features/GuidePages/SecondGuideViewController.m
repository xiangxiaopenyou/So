//
//  SecondGuideViewController.m
//  fitplus
//
//  Created by xlp on 15/6/30.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "SecondGuideViewController.h"
#import "ThirdGuideViewController.h"
#import "CommonsDefines.h"
#import "ChooseHobbyViewController.h"
#import "UserInfoModel.h"

@interface SecondGuideViewController ()<UIPickerViewDelegate, UIPickerViewDataSource>

@end

@implementation SecondGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_sex == 1) {
        _imageView.image = [UIImage imageNamed:@"height_male"];
    }
    else {
        _imageView.image = [UIImage imageNamed:@"height_female"];
    }
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    
    [_pickerView selectRow:70 inComponent:0 animated:YES];
    [_pickerView selectRow:50 inComponent:1 animated:YES];
    
    UILabel *cmLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4 + 20, 65, 30, 30)];
    cmLabel.text = @"cm";
    cmLabel.font = [UIFont systemFontOfSize:18];
    [_pickerView addSubview:cmLabel];
    
    UILabel *pointLabel = [[UILabel alloc] initWithFrame:CGRectMake(3* SCREEN_WIDTH/4 - 20, 65, 30, 30)];
    pointLabel.text = @".";
    pointLabel.font = [UIFont systemFontOfSize:18];
    [_pickerView addSubview:pointLabel];
    
    UILabel *kgLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 30, 65, 30, 30)];
    kgLabel.text = @"kg";
    kgLabel.font = [UIFont systemFontOfSize:18];
    [_pickerView addSubview:kgLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIPickerView Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (component) {
        case 0:
            return 100;
            break;
        case 1:
            return 130;
            break;
        case 2:
            return 10;
            break;
        default:
            return 0;
            break;
    }
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    switch (component) {
        case 0:
            return CGRectGetWidth(_pickerView.frame)/2 - 30;
            break;
        case 1:
            return CGRectGetWidth(_pickerView.frame)/4 - 20;
            break;
        case 2:
            return CGRectGetWidth(_pickerView.frame)/4 + 50;
            break;
        default:
            return 0;
            break;
    }
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 34;
}
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (component) {
        case 0:
            return [NSString stringWithFormat:@"%ld", (long)row + 100];
            break;
        case 1:
            return [NSString stringWithFormat:@"%ld", (long)row + 20];
            break;
        case 2:
            return [NSString stringWithFormat:@"%ld", (long)row];
            break;
        default:
            return nil;
            break;
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual:@"TurnToThirdGuide"]) {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        NSInteger heightRow = [_pickerView selectedRowInComponent:0];
        NSInteger weightRow1 = [_pickerView selectedRowInComponent:1];
        NSInteger weightRow2 = [_pickerView selectedRowInComponent:2];
        NSDictionary *dic = @{@"sex" : [NSString stringWithFormat:@"%ld", (long)_sex],
                              @"weight" : [NSString stringWithFormat:@"%ld.%ld", (long)weightRow1 + 20, (long)weightRow2],
                              @"age" : _age,
                              @"height" : [NSString stringWithFormat:@"%ld", (long)heightRow + 100]};
        [UserInfoModel finishGuide:dic handler:^(id object, NSString *msg) {
            if (msg) {
                NSLog(@"fail");
            } else {
                NSLog(@"success");
            }
        }];
    }
    
}

@end
