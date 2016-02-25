//
//  MobileBindingViewController.m
//  fitplus
//
//  Created by xlp on 15/7/10.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "MobileBindingViewController.h"
#import "NSString+MatchAddition.h"
#import "RBNoticeHelper.h"
#import "PersonalModel.h"
#import "MobileBindingSecondViewController.h"

@interface MobileBindingViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *tipImage;
@property (strong, nonatomic) IBOutlet UIButton *getIdentifierButton;
@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;

@end

@implementation MobileBindingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _getIdentifierButton.layer.masksToBounds = YES;
    _getIdentifierButton.layer.cornerRadius = 4.0;
    
    _phoneTextField.delegate = self;
    [_phoneTextField becomeFirstResponder];
}
- (void)getVerificationCode {
    [PersonalModel getVerificationCodeWith:_phoneTextField.text handler:^(id object, NSString *msg) {
        if (object) {
        }
        MobileBindingSecondViewController *mobileBinidingSecondViewController = [[UIStoryboard storyboardWithName:@"Personal" bundle:nil] instantiateViewControllerWithIdentifier:@"MobileBindingSecondView"];
        mobileBinidingSecondViewController.phoneNumber = _phoneTextField.text;
        [self.navigationController pushViewController:mobileBinidingSecondViewController animated:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (range.location == 10) {
        _tipImage.image = [UIImage imageNamed:@"mobile_binding_background_selected"];
    } else {
        _tipImage.image = [UIImage imageNamed:@"mobile_binding_background"];
    }
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (BOOL)isErrorBeforeSubmit {
    BOOL isError = NO;
    NSString *msg;
    if ([_phoneTextField.text isEqualToString:@""]) {
        isError = YES;
        msg = @"请输入手机号";
    }
    
    if (![_phoneTextField.text matchTel]) {
        isError = YES;
        msg = @"手机号格式错误";
    }
    if (msg) {
        [RBNoticeHelper showNoticeAtViewController:self msg:msg];
    }
    return isError;
}

- (IBAction)getIdentifierClick:(id)sender {
    if ([self isErrorBeforeSubmit]) {
        return;
    }
    [self getVerificationCode];
}

//- (void)viewWillAppear:(BOOL)animated{
//    self.navigationController.navigationBarHidden = NO;
//}
@end
