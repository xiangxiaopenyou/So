//
//  BindingViewController.m
//  fitplus
//
//  Created by xlp on 15/7/16.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "BindingViewController.h"
#import "MobileBindingViewController.h"

@interface BindingViewController ()
@property (strong, nonatomic) IBOutlet UILabel *mobileLabel;
@property (strong, nonatomic) IBOutlet UIView *clickView;

@end

@implementation BindingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _clickView.userInteractionEnabled = YES;
    [_clickView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeMobileRecognizer:)]];
    NSString *tempString = [_mobileString stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"xxxx"];
    _mobileLabel.text = tempString;
}
- (void)changeMobileRecognizer:(UITapGestureRecognizer *)gesture {
    MobileBindingViewController *mobileBindingViewController = [[UIStoryboard storyboardWithName:@"Personal" bundle:nil] instantiateViewControllerWithIdentifier:@"MobileBindingFirstView"];
    [self.navigationController pushViewController:mobileBindingViewController animated:YES];
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

@end
