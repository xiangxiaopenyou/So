//
//  UserLoginViewController.m
//  fitplus
//
//  Created by xlp on 15/7/16.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "UserLoginViewController.h"
#import "Util.h"
#import "RBNoticeHelper.h"
#import "UserInfoModel.h"
#import "UIView+RBAddition.h"

@interface UserLoginViewController ()
@property (strong, nonatomic) IBOutlet UITextField *nicknameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation UserLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _nicknameTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    _nicknameTextField.leftViewMode = UITextFieldViewModeAlways;
    _passwordTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    _passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    [_nicknameTextField rb_addBorder:BorderSide_Top | BorderSide_Bottom | BorderSide_Left | BorderSide_Right width:0.5 color:[UIColor colorWithWhite:1.000 alpha:0.500]];
    [_passwordTextField rb_addBorder:BorderSide_Top | BorderSide_Bottom | BorderSide_Left | BorderSide_Right width:0.5 color:[UIColor colorWithWhite:1.000 alpha:0.500]];
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
- (IBAction)loginButtonClick:(id)sender {
    if ([Util isEmpty:_nicknameTextField.text]) {
        [RBNoticeHelper showNoticeAtViewController:self msg:@"先输入用户名"];
        return;
    }
    if ([Util isEmpty:_passwordTextField.text]) {
        [RBNoticeHelper showNoticeAtViewController:self msg:@"先输入密码"];
        return;
    }
    [UserInfoModel userLogin:_nicknameTextField.text password:_passwordTextField.text handler:^(id object, NSString *msg) {
        if (object) {
            [RBNoticeHelper showNoticeAtViewController:self msg:@"登录成功"];
            [self saveUserInfo:object[@"data"]];
        } else {
            [RBNoticeHelper showNoticeAtViewController:self msg:@"登录失败"];
        }
    }];
}
- (void)saveUserInfo:(NSDictionary *)infoDictionary {
    [[NSUserDefaults standardUserDefaults] setValue:infoDictionary[@"userid"] forKey:UserIdKey];
    [[NSUserDefaults standardUserDefaults] setValue:infoDictionary[@"usertoken"] forKey:UserTokenKey];
    [[NSUserDefaults standardUserDefaults] setValue:infoDictionary[@"nickname"] forKey:UserName];
    [[NSUserDefaults standardUserDefaults] setValue:infoDictionary[@"userheadportrait"] forKey:UserHeadportrait];
    [[NSUserDefaults standardUserDefaults] setValue:@(1) forKey:UserSex];
    [[NSUserDefaults standardUserDefaults] setValue:infoDictionary[@"isNewUser"] forKey:IsNewUserKey];
    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:IsFirstOpenTool];
    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:IsFirstOpenVideo];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:LoginStateChange object:@YES];
}

@end
