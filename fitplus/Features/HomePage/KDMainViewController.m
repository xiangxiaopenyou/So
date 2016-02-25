//
//  KDMainViewController.m
//  Koudaitong
//
//  Created by ShaoTianchi on 14-9-2.
//  Copyright (c) 2014年 qima. All rights reserved.
//

#import "KDMainViewController.h"
#import "UIImage+PhotoAddition.h"
#import "UIImage+ImageEffects.h"
#import <Masonry.h>
#import "KDTabbarProtocol.h"
#import "AFNetworking.h"
//#import "fitplus-Swift.h"
#import "CommonsDefines.h"
#import "ClockInViewController.h"
#import "SendPhotoViewController.h"
#import <TuSDK/TuSDK.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface KDMainViewController ()<UITabBarControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (assign, nonatomic) BOOL isDashboardShow;
@property (strong, nonatomic) UIView *dashView;
@property (strong, nonatomic) UIView *geTuiView;
@property (strong, nonatomic) UIWebView *geTuiWebView;
@property (strong, nonatomic) UIView *foodView;
@property (strong, nonatomic) UIView *takePhotoView;
@property (strong, nonatomic) UIView *sportsView;
@property (strong, nonatomic) UIButton *dashboardButton;
@property (strong, nonatomic) UIImageView *backgrundImage;
@property (strong, nonatomic) UIImage *currentViewImage;
@property (strong, nonatomic) UIImagePickerController *cameraController;
@property (strong, nonatomic) UIButton *chooseAlbumButton;

@end

@implementation KDMainViewController

- (void)viewDidLoad {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendInformationSuccess) name:ClockInOverNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedMessages:) name:ReceivedMessagesNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:@"LoginSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(takedPhoto:) name:@"_UIImagePickerControllerUserDidCaptureItem" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rejectedPhoto:) name:@"_UIImagePickerControllerUserDidRejectItem" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showGeTuiView) name:@"ShowGeTui" object:nil];
    
    [super viewDidLoad];
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor colorWithWhite:0.250 alpha:1.000]];
//    UIEdgeInsets imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    UIImage *mainImage = [UIImage imageNamed:@"tab_btn_main"];
    UIImage *mainImageSel = [UIImage imageNamed:@"tab_btn_main_selected"];
    mainImage = [mainImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mainImageSel = [mainImageSel imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *dryImage = [UIImage imageNamed:@"tab_btn_square_normal"];
    UIImage *dryImageSel = [UIImage imageNamed:@"tab_btn_square_pressed"];
    dryImage = [dryImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    dryImageSel = [dryImageSel imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *messageImage = [UIImage imageNamed:@"tab_btn_home_normal"];
    UIImage *messageImageSel = [UIImage imageNamed:@"tab_btn_home_pressed"];
    messageImage = [messageImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    messageImageSel = [messageImageSel imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *mineImage = [UIImage imageNamed:@"tab_btn_mine"];
    UIImage *mineImageSel = [UIImage imageNamed:@"tab_btn_mine_selected"];
    mineImage = [mineImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mineImageSel = [mineImageSel imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *item_square = [[UITabBarItem alloc]initWithTitle:@"" image:mainImage selectedImage:mainImageSel];
    item_square.title = @"首页";
    UIViewController *squareViewController = [[UIStoryboard storyboardWithName:@"Square" bundle:nil] instantiateViewControllerWithIdentifier:@"SquareView"];
    squareViewController.tabBarItem = item_square;
    
    UITabBarItem *item_dry = [[UITabBarItem alloc] initWithTitle:@"" image:dryImage selectedImage:dryImageSel];
    item_dry.title = @"健身";
    UIViewController *drysalteryViewController = [[UIStoryboard storyboardWithName:@"Drysaltery" bundle:nil] instantiateViewControllerWithIdentifier:@"DrysalteryList"];
    drysalteryViewController.tabBarItem = item_dry;
    
    
    UITabBarItem *item_add = [[UITabBarItem alloc] initWithTitle:@"" image:[[UIImage imageNamed:@"tab_btn_add"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] tag:1];
    item_add.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    UIViewController *emptyViewController = [UIViewController new];
    emptyViewController.tabBarItem = item_add;
    
    _dashboardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _dashboardButton.tag = 9999;
    [_dashboardButton setImage:[UIImage imageNamed:@"tab_btn_add"] forState:UIControlStateNormal];
    CGFloat buttonWidth = CGRectGetWidth([UIScreen mainScreen].bounds) / 5;
    _dashboardButton.frame = CGRectMake((CGRectGetWidth([UIScreen mainScreen].bounds) - buttonWidth) / 2,
                                       (CGRectGetHeight(self.tabBar.frame) - 45) / 2,
                                       buttonWidth,
                                       45);
    [_dashboardButton addTarget:self action:@selector(dashboardButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBar addSubview:_dashboardButton];
    [self.tabBar bringSubviewToFront:_dashboardButton];
    
//    UITabBarItem *item_group = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"tab_btn_group"] selectedImage:[UIImage imageNamed:@"tab_btn_group_selected"]];
//    item_group.title = @"圈子";
//    UIViewController *groupListViewController = [[UIStoryboard storyboardWithName:@"Group" bundle:nil] instantiateViewControllerWithIdentifier:@"GroupList"];
//    groupListViewController.tabBarItem = item_group;
    
    UITabBarItem *item_message = [[UITabBarItem alloc] initWithTitle:@"" image:messageImage selectedImage:messageImageSel];
    item_message.title = @"消息";
    UIViewController *messageListViewController = [[UIStoryboard storyboardWithName:@"MessageList" bundle:nil] instantiateViewControllerWithIdentifier:@"messageListView"];
    messageListViewController.tabBarItem = item_message;
    
    UITabBarItem *item_homepage = [[UITabBarItem alloc]initWithTitle:@"" image:mineImage selectedImage:mineImageSel];
    item_homepage.title = @"我的";
    UIViewController *homepageViewController = [[UIStoryboard storyboardWithName:@"Information" bundle:nil] instantiateViewControllerWithIdentifier:@"informationView"];
    homepageViewController.tabBarItem = item_homepage;
    
    self.viewControllers = @[squareViewController, drysalteryViewController, emptyViewController, messageListViewController, homepageViewController];
    
    [self setupDashView];
    [self setupGeTuiView];
    
    [self setSelectedIndex:1];
    
}
- (void)setupDashView {
    //UIImage *currentViewImage = [UIImage imageNamed:@""];
    //GPUImageGaussianBlurFilter *blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
    //blurFilter.blurRadiusInPixels = 2.0;
   
    _dashView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49)];
    [_dashView setBackgroundColor:[UIColor clearColor]];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:_dashView];
    _dashView.hidden = YES;
    
    _backgrundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49)];
    //backgrundImage.image = [blurFilter imageByFilteringImage:currentViewImage];
    //_backgrundImage.contentMode = UIViewContentModeTop;
    [_dashView addSubview:_backgrundImage];
    
    _foodView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 40, SCREEN_HEIGHT, 80, 80)];
    _foodView.backgroundColor = [UIColor clearColor];
    [_dashView addSubview:_foodView];
    
    UIButton *foodButton = [UIButton buttonWithType:UIButtonTypeCustom];
    foodButton.frame = CGRectMake(16, 4, 48, 48);
    [foodButton setBackgroundImage:[UIImage imageNamed:@"tool_button_diet"] forState:UIControlStateNormal];
    [foodButton addTarget:self action:@selector(foodClick) forControlEvents:UIControlEventTouchUpInside];
    [_foodView addSubview:foodButton];
    
    UILabel *foodLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 57, 80, 20)];
    foodLabel.text = @"饮食打卡";
    foodLabel.font = [UIFont systemFontOfSize:12];
    foodLabel.textAlignment = NSTextAlignmentCenter;
    foodLabel.textColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1.0];
    [_foodView addSubview:foodLabel];
    
    _takePhotoView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 40, SCREEN_HEIGHT, 80, 80)];
    _takePhotoView.backgroundColor = [UIColor clearColor];
    [_dashView addSubview:_takePhotoView];
    
    UIButton *photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    photoButton.frame = CGRectMake(16, 4, 48, 48);
    [photoButton setBackgroundImage:[UIImage imageNamed:@"tool_button_photograph"] forState:UIControlStateNormal];
    [photoButton addTarget:self action:@selector(photoClick) forControlEvents:UIControlEventTouchUpInside];
    [_takePhotoView addSubview:photoButton];
    
    UILabel *photoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 57, 80, 20)];
    photoLabel.text = @"拍照";
    photoLabel.font = [UIFont systemFontOfSize:12];
    photoLabel.textAlignment = NSTextAlignmentCenter;
    photoLabel.textColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1.0];
    [_takePhotoView addSubview:photoLabel];
    
    _sportsView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 40, SCREEN_HEIGHT, 80, 80)];
    _sportsView.backgroundColor = [UIColor clearColor];
    [_dashView addSubview:_sportsView];
    
    UIButton *sportsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sportsButton.frame = CGRectMake(16, 4, 48, 48);
    [sportsButton setBackgroundImage:[UIImage imageNamed:@"tool_button_sport"] forState:UIControlStateNormal];
    [sportsButton addTarget:self action:@selector(sportsClick) forControlEvents:UIControlEventTouchUpInside];
    [_sportsView addSubview:sportsButton];
    
    UILabel *sportsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 57, 80, 20)];
    sportsLabel.text = @"运动打卡";
    sportsLabel.font = [UIFont systemFontOfSize:12];
    sportsLabel.textAlignment = NSTextAlignmentCenter;
    sportsLabel.textColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1.0];
    [_sportsView addSubview:sportsLabel];
}

- (void)setupGeTuiView {
    _geTuiView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [_geTuiView setBackgroundColor:[UIColor whiteColor]];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:_geTuiView];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    topView.backgroundColor = [UIColor colorWithRed:0.234 green:0.180 blue:0.292 alpha:1.000];
    [_geTuiView addSubview:topView];
    
    UIButton *closeGeTuiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeGeTuiButton.frame = CGRectMake(10, 20, 44, 40);
    [closeGeTuiButton setTitle:@"关闭" forState:UIControlStateNormal];
    closeGeTuiButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [closeGeTuiButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeGeTuiButton addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:closeGeTuiButton];
    
    _geTuiWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    [_geTuiView addSubview:_geTuiWebView];
    NSURLRequest *webRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];
    [_geTuiWebView loadRequest:webRequest];
}
- (void)showGeTuiView {
    [UIView animateWithDuration:0.5 delay:0.3 usingSpringWithDamping:0 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _geTuiView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
    }];
}
- (void)hideGeTuiView {
    _geTuiView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
}

- (void)closeClick {
    [self hideGeTuiView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tabBar bringSubviewToFront:[self.tabBar viewWithTag:9999]];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ClockInOverNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ReceivedMessagesNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LoginSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"_UIImagePickerControllerUserDidCaptureItem" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"_UIImagePickerControllerUserDidRejectItem" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ShowGeTui" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)receivedMessages:(NSNotification *)notification {
    NSInteger messageNum = [notification.object integerValue];
    UIViewController<KDTabbarProtocol> *vc = [self.viewControllers objectAtIndex:3];
    vc.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", (long)messageNum];
}

#pragma mark - Tabbar

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSInteger index = [self.tabBar.items indexOfObject:item];
    UIViewController<KDTabbarProtocol> *vc = [self.viewControllers objectAtIndex:index];
    if (index == 3) {
        vc.tabBarItem.badgeValue = nil;
    }
    if (index != 2) {
        if (vc != self.selectedViewController) {
            UIView *titleView = [vc titleViewForTabbarNav];
            [self.navigationItem setTitleView:titleView];
            if (!titleView) {
                [self.navigationItem setTitle:[vc titleForTabbarNav]];
            }
            [self.navigationItem setRightBarButtonItems:[vc rightButtonsForTabbarNav]];
            [self.navigationItem setLeftBarButtonItems:[vc leftButtonsForTabbarNav]];
        }
    }
    
}

- (void)setNavgationAfterChangeIndex:(NSInteger)index {
    UIViewController<KDTabbarProtocol> *vc = [self.viewControllers objectAtIndex:index];
    UIView *titleView = [vc titleViewForTabbarNav];
    [self.navigationItem setTitleView:titleView];
    if (!titleView) {
        [self.navigationItem setTitle:[vc titleForTabbarNav]];
    }
    [self.navigationItem setRightBarButtonItems:[vc rightButtonsForTabbarNav]];
    [self.navigationItem setLeftBarButtonItems:[vc leftButtonsForTabbarNav]];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    [super setSelectedIndex:selectedIndex];
    [self setNavgationAfterChangeIndex:selectedIndex];
}

- (void)dashboardButtonTouched:(UIButton *)sender {
    _currentViewImage = [[UIImage rb_imageFromView:self.selectedViewController.view] applyExtraLightEffect];
    CGFloat rotation = ((_isDashboardShow ? 0 : 45) / 180.0 * M_PI);
    [UIView animateWithDuration:0.2 delay:0.0 options: UIViewAnimationOptionCurveLinear animations:^{
        CGAffineTransform transform = CGAffineTransformMakeRotation(rotation);
        sender.transform = transform;
    } completion:nil];
    if (_isDashboardShow) {
        [self hideDashboard];
    } else {
        _currentViewImage = [[UIImage rb_imageFromView:self.selectedViewController.view] applyExtraLightEffect];
        _backgrundImage.image = _currentViewImage;
        [self showDashboard];
    }
    //_isDashboardShow ? [self hideDashboard] : [self showDashboard];
}


- (void)showDashboard {
//    UIImage *currentViewImage = [[UIImage rb_imageFromView:self.selectedViewController.view] applyExtraLightEffect];
//    DashBoardViewController *dashboardViewController = [[UIStoryboard storyboardWithName:@"DashBoard" bundle:nil] instantiateViewControllerWithIdentifier:@"DashView"];
//    [dashboardViewController.view setFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), SCREEN_HEIGHT - CGRectGetHeight(self.tabBar.frame) - 0.2 )];
//    dashboardViewController.view.tag = 998877;
//    dashboardViewController.view.clipsToBounds = YES;
//    dashboardViewController.backgroundBlurImage = currentViewImage;
//    [[UIApplication sharedApplication].keyWindow addSubview:dashboardViewController.view];
    
    _dashView.hidden = NO;
    [self animationShow];
    _isDashboardShow = YES;
}
- (void)animationShow {
    [UIView animateWithDuration:0.55 delay:0.2 usingSpringWithDamping:0.6 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _foodView.frame = CGRectMake(SCREEN_WIDTH / 4 - 40, SCREEN_HEIGHT - 160, 80, 80);
    } completion:nil];
    [UIView animateWithDuration:0.55 delay:0.3 usingSpringWithDamping:0.6 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _takePhotoView.frame = CGRectMake(SCREEN_WIDTH / 2 - 40, SCREEN_HEIGHT - 220, 80, 80);
    } completion:nil];
    [UIView animateWithDuration:0.55 delay:0.25 usingSpringWithDamping:0.6 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _sportsView.frame = CGRectMake(3 * SCREEN_WIDTH / 4 - 40, SCREEN_HEIGHT - 160, 80, 80);
    } completion:nil];
}
- (void)animationHidden {
    [UIView animateWithDuration:0.35 delay:0.1 usingSpringWithDamping:0.6 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _foodView.frame = CGRectMake(SCREEN_WIDTH/2 - 40, SCREEN_HEIGHT, 80, 80);
    } completion:nil];
    [UIView animateWithDuration:0.35 delay:0.2 usingSpringWithDamping:0.6 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _takePhotoView.frame = CGRectMake(SCREEN_WIDTH/2 - 40, SCREEN_HEIGHT, 80, 80);
    } completion:nil];
    [UIView animateWithDuration:0.35 delay:0.15 usingSpringWithDamping:0.6 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _sportsView.frame = CGRectMake(SCREEN_WIDTH/2 - 40, SCREEN_HEIGHT, 80, 80);
    } completion:nil];
}

- (void)hideDashboard {
    //[[[UIApplication sharedApplication].keyWindow viewWithTag:998877] removeFromSuperview];
    [self animationHidden];
    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.4];
}

- (void)delayMethod {
    _dashView.hidden = YES;
    _isDashboardShow = NO;
}
- (void)foodClick {
    [self hideDashboard];
    ClockInViewController *clockInView = [[UIStoryboard storyboardWithName:@"ClockIn" bundle:nil] instantiateViewControllerWithIdentifier:@"ClockInView"];
    clockInView.type = ClockInType_Food;
    [self.navigationController pushViewController:clockInView animated:YES];
    
    [UIView animateWithDuration:0.2 delay:0.0 options: UIViewAnimationOptionCurveLinear animations:^{
        CGAffineTransform transform = CGAffineTransformMakeRotation(0);
        _dashboardButton.transform = transform;
    } completion:nil];
}
- (void)photoClick {
    [self hideDashboard];
    [self showPhotoView];
//    SendPhotoViewController *photoViewController = [[UIStoryboard storyboardWithName:@"ClockIn" bundle:nil] instantiateViewControllerWithIdentifier:@"PhotoView"];
//    [self.navigationController pushViewController:photoViewController animated:YES];
    [UIView animateWithDuration:0.2 delay:0.0 options: UIViewAnimationOptionCurveLinear animations:^{
        CGAffineTransform transform = CGAffineTransformMakeRotation(0);
        _dashboardButton.transform = transform;
    } completion:nil];
}
- (void)sportsClick{
    [self hideDashboard];
    ClockInViewController *clockInView = [[UIStoryboard storyboardWithName:@"ClockIn" bundle:nil] instantiateViewControllerWithIdentifier:@"ClockInView"];
    clockInView.type = ClockInType_Sport;
    [self.navigationController pushViewController:clockInView animated:YES];
    
    [UIView animateWithDuration:0.2 delay:0.0 options: UIViewAnimationOptionCurveLinear animations:^{
        CGAffineTransform transform = CGAffineTransformMakeRotation(0);
        _dashboardButton.transform = transform;
    } completion:nil];
}
- (void)sendInformationSuccess {
    self.selectedIndex = 4;
}
- (void)loginSuccess {
    self.selectedIndex = 1;
}
- (void)showPhotoView {
    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 100, SCREEN_WIDTH, 100)];
    toolView.backgroundColor = [UIColor blackColor];
    UIButton *takePhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    takePhotoButton.frame = CGRectMake((SCREEN_WIDTH - 80) / 2, SCREEN_HEIGHT - 80, 80, 80);
    takePhotoButton.backgroundColor = [UIColor whiteColor];
    [toolView addSubview:takePhotoButton];
    
    if (!_cameraController) {
        _cameraController = [[UIImagePickerController alloc] init];
        _cameraController.delegate = self;
        _cameraController.allowsEditing = YES;
        _cameraController.sourceType = UIImagePickerControllerSourceTypeCamera;
        _chooseAlbumButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chooseAlbumButton addTarget:self action:@selector(showAlbum) forControlEvents:UIControlEventTouchUpInside];
    }
    [self presentViewController:_cameraController animated:YES completion:^{
        
        CGPoint origin = CGPointZero;
        CGFloat width = 0;
        for (UIView *subview in _cameraController.view.subviews) {
            if([NSStringFromClass([subview class]) isEqualToString:@"UINavigationTransitionView"]) {
                UIView *theView = (UIView *)subview;
                for (UIView *subview in theView.subviews) {
                    if([NSStringFromClass([subview class]) isEqualToString:@"UIViewControllerWrapperView"]) {
                        UIView *theView = (UIView *)subview;
                        for (UIView *subview in theView.subviews) {
                            if([NSStringFromClass([subview class]) isEqualToString:@"PLImagePickerCameraView"] || [NSStringFromClass([subview class]) isEqualToString:@"PLCameraView"]) {
                                UIView *theView = (UIView *)subview;
                                for (UIView *subview in theView.subviews) {
                                    if([NSStringFromClass([subview class]) isEqualToString:@"CMKBottomBar"]) {
                                        UIView *theView = (UIView *)subview;
                                        for (UIView *view in theView.subviews) {
                                            if ([view isKindOfClass:NSClassFromString(@"CMKShutterButton")]) {
                                                origin = view.frame.origin;
                                                origin.y += CGRectGetMinY(view.superview.frame);
                                                width = CGRectGetWidth(view.frame);
                                                break;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        _chooseAlbumButton.frame = CGRectMake(SCREEN_WIDTH - width - 20, origin.y, width, width);
        [_cameraController.view addSubview:_chooseAlbumButton];
        
        [[ALAssetsLibrary defaultLibrary] enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            if (group) {
                [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                    if (result) {
                        [_chooseAlbumButton setBackgroundImage:[UIImage imageWithCGImage:[[result defaultRepresentation] fullResolutionImage]] forState:UIControlStateNormal];
                        *stop = YES;
                    }
                }];
                *stop = YES;
            }
        } failureBlock:^(NSError *error) {
            NSLog(@"get album photo failed %@", error.description);
        }];
        
    }];
}
- (void)showAlbum {
    [self dismissViewControllerAnimated:NO completion:^{
        UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerVC.delegate = self;
        [self presentViewController:imagePickerVC animated:YES completion:nil];
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        //[self openEditWithImage:image];
        SendPhotoViewController *photoViewController = [[UIStoryboard storyboardWithName:@"ClockIn" bundle:nil] instantiateViewControllerWithIdentifier:@"PhotoView"];
        photoViewController.image = image;
        [self.navigationController pushViewController:photoViewController animated:YES];
        
    }];
}
- (void)takedPhoto:(NSDictionary *)userInfo {
    [_chooseAlbumButton removeFromSuperview];
}

- (void)rejectedPhoto:(NSDictionary *)userInfo {
    [_cameraController.view addSubview:_chooseAlbumButton];
}

//- (void)openEditWithImage:(UIImage *)image {
//    UINavigationController *photoEditNav = [[UIStoryboard storyboardWithName:@"PhotoEdit" bundle:nil] instantiateViewControllerWithIdentifier:@"PhotoEditViewNavgation"];
//    PhotoEditViewController *photoEditVC = photoEditNav.viewControllers.firstObject;
//    photoEditVC.inputImage = image;
//    photoEditVC.handler = ^(UIImage *resultImage,NSArray *tags, UIViewController *editer) {
//        [editer dismissModalViewControllerAnimated];
//        _imageView.image = resultImage;
//        _tagArray = [tags mutableCopy];
//        _isImage = YES;
//    };
//    [self presentViewController:photoEditNav animated:YES completion:nil];
//    
//}

@end
