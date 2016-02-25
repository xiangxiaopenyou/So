//
//  MobileBindingSecondViewController.m
//  fitplus
//
//  Created by xlp on 15/7/13.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "MobileBindingSecondViewController.h"
#import "PersonalCommons.h"
#import "RBNoticeHelper.h"
#import "RBBlockAlertView.h"
#import "PersonalModel.h"

@interface MobileBindingSecondViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *verifyTextField;
@property (strong, nonatomic) IBOutlet UIImageView *tipImage;
@property (strong, nonatomic) IBOutlet UIButton *bindingButton;
@property (strong, nonatomic) IBOutlet UIButton *reAcquisitionButton;

@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSInteger time;
@end

@implementation MobileBindingSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _bindingButton.layer.masksToBounds = YES;
    _bindingButton.layer.cornerRadius = 4.0;
    _reAcquisitionButton.layer.masksToBounds = YES;
    _reAcquisitionButton.layer.cornerRadius = 4.0;
    
    [_verifyTextField becomeFirstResponder];
    _verifyTextField.delegate = self;
    
    
    [self addTimer];
    
}
- (void)addTimer {
    _time = 60;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeTime) userInfo:nil repeats:YES];;
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
- (void)changeTime {
    if (_time > 0) {
        _reAcquisitionButton.enabled = NO;
        _time --;
        NSString *tempString = [NSString stringWithFormat:@"重新获取(%lds)", (long)_time];
        [_reAcquisitionButton setTitle:tempString forState:UIControlStateNormal];
        [_reAcquisitionButton setBackgroundColor:kReAcquisitionButtonColor];
    } else {
        [_timer invalidate];
        _reAcquisitionButton.enabled = YES;
        [_reAcquisitionButton setTitle:@"重新获取" forState:UIControlStateNormal];
        [_reAcquisitionButton setBackgroundColor:kReAcquisitionButtonEnableColor];
    }
}

- (IBAction)reAcquisitionClick:(id)sender {
    [self addTimer];
    [PersonalModel getVerificationCodeWith:_phoneNumber handler:^(id object, NSString *msg) {
        if (object) {
        }
    }];
}

- (IBAction)bindingClick:(id)sender {
    if ([_verifyTextField.text length] != 4) {
        [RBNoticeHelper showNoticeAtViewController:self msg:@"输入正确的验证码"];
        return;
    }
    [PersonalModel bindingMobileWith:_phoneNumber code:_verifyTextField.text handler:^(id object, NSString *msg) {
        if (msg) {
            RBBlockAlertView *alert =  [[RBBlockAlertView alloc] initWithTitle:@"提示" message:@"绑定失败了~" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
        } else {
            [RBNoticeHelper showNoticeAtViewController:self msg:@"绑定成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"EditSuccess" object:@YES];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        }
    }];
}
@end
