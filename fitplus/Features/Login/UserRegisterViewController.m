//
//  UserRegisterViewController.m
//  fitplus
//
//  Created by xlp on 15/7/16.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "UserRegisterViewController.h"
#import "Util.h"
#import "RBNoticeHelper.h"
#import "UserInfoModel.h"
#import "UIView+RBAddition.h"

@interface UserRegisterViewController ()
@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *rePasswordTextfield;

@end

@implementation UserRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _usernameTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    _usernameTextField.leftViewMode = UITextFieldViewModeAlways;
    _passwordTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    _passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    _rePasswordTextfield.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    _rePasswordTextfield.leftViewMode = UITextFieldViewModeAlways;
    [_usernameTextField rb_addBorder:BorderSide_Top | BorderSide_Bottom | BorderSide_Left | BorderSide_Right width:0.5 color:[UIColor colorWithWhite:1.000 alpha:0.500]];
    [_passwordTextField rb_addBorder:BorderSide_Top | BorderSide_Bottom | BorderSide_Left | BorderSide_Right width:0.5 color:[UIColor colorWithWhite:1.000 alpha:0.500]];
    [_rePasswordTextfield rb_addBorder:BorderSide_Top | BorderSide_Bottom | BorderSide_Left | BorderSide_Right width:0.5 color:[UIColor colorWithWhite:1.000 alpha:0.500]];
}
- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
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
- (IBAction)registerButtonClick:(id)sender {
    if ([Util isEmpty:_usernameTextField.text]) {
        [RBNoticeHelper showNoticeAtViewController:self msg:@"先输入用户名"];
        return;
    }
    if ([Util isEmpty:_passwordTextField.text]) {
        [RBNoticeHelper showNoticeAtViewController:self msg:@"先输入密码"];
        return;
    }
    if (![_passwordTextField.text isEqualToString:_rePasswordTextfield.text]) {
        [RBNoticeHelper showNoticeAtViewController:self msg:@"两次密码不一致"];
        return;
    }
    [UserInfoModel userRegister:_usernameTextField.text password:_passwordTextField.text handler:^(id object, NSString *msg) {
        if (object) {
            [RBNoticeHelper showNoticeAtViewController:self msg:@"注册成功,请登录"];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            if ([msg isEqualToString:@"name survived"]) {
                [RBNoticeHelper showNoticeAtViewController:self msg:@"用户已存在"];
            } else {
                [RBNoticeHelper showNoticeAtViewController:self msg:@"注册失败"];
            }
        }
    }];
}

@end
