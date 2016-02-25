//
//  HelpAndFeedbackViewController.m
//  fitplus
//
//  Created by xlp on 15/7/14.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "HelpAndFeedbackViewController.h"
#import "Util.h"
#import "RBNoticeHelper.h"
#import "PersonalModel.h"

@interface HelpAndFeedbackViewController ()<UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *tipLabel;
@property (strong, nonatomic) IBOutlet UITextView *helpTextView;

@end

@implementation HelpAndFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"帮助与反馈";
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleBordered target:self action:@selector(rightButtonItemClick)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    _helpTextView.delegate = self;
    [_helpTextView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextView Delegate
- (void)textViewDidChange:(UITextView *)textView {
    _tipLabel.hidden = YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)rightButtonItemClick {
    if ([Util isEmpty:_helpTextView.text]) {
        [RBNoticeHelper showNoticeAtViewController:self msg:@"先说点什么吧..."];
        return;
    }
    [PersonalModel helpAndFeedbackWith:_helpTextView.text handler:^(id object, NSString *msg) {
        if (msg) {
            [RBNoticeHelper showNoticeAtViewController:self msg:@"发送失败"];
        } else {
            [RBNoticeHelper showNoticeAtViewController:self msg:@"发送成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

@end
