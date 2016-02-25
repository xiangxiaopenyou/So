//
//  LoginViewController.m
//  fitplus
//
//  Created by xlp on 15/6/26.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "LoginViewController.h"
#import "WXApi.h"
#import "CommonsDefines.h"
#import "UserInfoModel.h"
#import "UserProtocolViewController.h"
#import "RBNoticeHelper.h"

@interface LoginViewController ()<UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIButton *userLoginButton;
@property (strong, nonatomic) IBOutlet UIButton *wechatLoginButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStateChange) name:LoginStateChange object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFail) name:LoginFail object:nil];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces = NO;
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, 0);
    
    if ([WXApi isWXAppInstalled]) {
        _userLoginButton.hidden = NO;
        _wechatLoginButton.hidden = NO;
    } else {
        _userLoginButton.hidden = NO;
        _wechatLoginButton.hidden = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    for (NSInteger i = 0; i < 3; i ++) {
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(i * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        if (SCREEN_HEIGHT > 480) {
            image.image = [UIImage imageNamed:[NSString stringWithFormat:@"guide_background_big_%ld", i + 1]];
        } else {
            image.image = [UIImage imageNamed:[NSString stringWithFormat:@"guide_background_small_%ld", i + 1]];
        }
        [_scrollView addSubview:image];
    }
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 30, SCREEN_HEIGHT - 150, 60, 30)];
    _pageControl.numberOfPages = 3;
    [self.view addSubview:_pageControl];
}


- (void)loginStateChange {
    //if ([[[NSUserDefaults standardUserDefaults] valueForKey:IsNewUserKey] integerValue] == 0) {
        //[self showGuide];
    //}
    //else {
    [self.navigationController popToRootViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSuccess" object:@YES];
        //[self showGuide];
    //}
}

- (void)loginFail {
    [RBNoticeHelper showNoticeAtViewController:self msg:@"登录失败，请重试"];
}

- (void)showGuide {
    UIViewController *guideVC = [[UIStoryboard storyboardWithName:@"Guide" bundle:nil] instantiateViewControllerWithIdentifier:@"FifthGuideView"];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:guideVC animated:NO];
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = CGRectGetWidth(scrollView.frame);
    //_pageControl.currentPage = floor(scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame));
    NSInteger page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _pageControl.currentPage = page;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)weChatLoginButtonClick:(id)sender {
    SendAuthReq *wxRequest = [[SendAuthReq alloc] init];
    wxRequest.scope = @"snsapi_userinfo";
    wxRequest.state = @"none";
    [WXApi sendReq:wxRequest];
}

@end
