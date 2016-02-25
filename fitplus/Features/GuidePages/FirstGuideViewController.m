//
//  FirstGuideViewController.m
//  fitplus
//
//  Created by xlp on 15/6/29.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "FirstGuideViewController.h"
#import "SecondGuideViewController.h"

@interface FirstGuideViewController ()<UIPickerViewDataSource, UIPickerViewDelegate>

@end

@implementation FirstGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    _sex = 1;
    
    _agePickerView.delegate = self;
    _agePickerView.dataSource = self;
    [_agePickerView selectRow:14 inComponent:0 animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIPickerView Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 90;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 34;
}
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%ld", (long)row + 10];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual:@"TurnToSecondGuide"]) {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
        NSInteger ageRow = [_agePickerView selectedRowInComponent:0];
        SecondGuideViewController *secondVC = segue.destinationViewController;
        secondVC.sex = _sex;
        secondVC.age = [NSString stringWithFormat:@"%ld", (long)ageRow + 10];
    }
}


- (IBAction)maleButtonClick:(id)sender {
    _sex = 1;
    [_maleButton setBackgroundImage:[UIImage imageNamed:@"male_selected"] forState:UIControlStateNormal];
    [_famaleButton setBackgroundImage:[UIImage imageNamed:@"female"] forState:UIControlStateNormal];
}

- (IBAction)famaleButtonClick:(id)sender {
    _sex = 2;
    [_maleButton setBackgroundImage:[UIImage imageNamed:@"male"] forState:UIControlStateNormal];
    [_famaleButton setBackgroundImage:[UIImage imageNamed:@"female_selected"] forState:UIControlStateNormal];
}
@end
