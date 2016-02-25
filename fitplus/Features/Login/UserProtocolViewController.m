//
//  UserProtocolViewController.m
//  fitplus
//
//  Created by xlp on 15/7/23.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "UserProtocolViewController.h"

@interface UserProtocolViewController ()
@property (strong, nonatomic) IBOutlet UITextView *protocolTextView;

@end

@implementation UserProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"用户协议";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _protocolTextView.contentOffset = CGPointZero;
    _protocolTextView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _protocolTextView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
