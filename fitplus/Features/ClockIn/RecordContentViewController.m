//
//  RecordContentViewController.m
//  fitplus
//
//  Created by 天池邵 on 15/6/30.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "RecordContentViewController.h"
#import "FoodModel.h"
#import "SportModel.h"
#import "RBNoticeHelper.h"
#import <MBProgressHUD.h>
#import "ClockInGoodModel.h"
#import "PhotoEditViewController.h"
#import "CommonsDefines.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <TuSDK/TuSDK.h>

@interface RecordContentViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UITextField *contentTextView;
@property (weak, nonatomic) IBOutlet UILabel *calorieLabel;
@property (weak, nonatomic) IBOutlet UIButton *backgroundButton;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textLeadingConstraint;

@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeightConstraint;

@property (strong, nonatomic) UIImagePickerController *cameraController;
@property (strong, nonatomic) UIButton *chooseAlbumButton;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) NSMutableArray *tagArray;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewTopConstraint;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *imageTapGR;
@end

@implementation RecordContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view sendSubviewToBack:_backgroundButton];
    [self setupViews];
    
    _bottomView.layer.masksToBounds = YES;
    CALayer *borderLayer = [CALayer new];
    borderLayer.frame = CGRectMake(-.5, 0, CGRectGetWidth(_bottomView.frame) + 1, CGRectGetHeight(_bottomView.frame) + .5);
    borderLayer.borderColor = [UIColor colorWithWhite:0.849 alpha:1.000].CGColor;
    borderLayer.borderWidth = 1;
    [_bottomView.layer addSublayer:borderLayer];
    
    _topView.layer.masksToBounds = YES;
    CALayer *topBorderLayer = [CALayer new];
    topBorderLayer.frame = CGRectMake(-.5, -.5, CGRectGetWidth(_topView.frame) + 1, CGRectGetHeight(_topView.frame) + .5);
    topBorderLayer.borderColor = [UIColor colorWithWhite:0.849 alpha:1.000].CGColor;
    topBorderLayer.borderWidth = 1;
    [_topView.layer addSublayer:topBorderLayer];
    
    [self.view bringSubviewToFront:_contentTextView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(takedPhoto:) name:@"_UIImagePickerControllerUserDidCaptureItem" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rejectedPhoto:) name:@"_UIImagePickerControllerUserDidRejectItem" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)viewWillAppear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (IBAction)textValueChanged:(id)sender {
    if ([_contentTextView.text isEqualToString:@""]) {
        _noticeLabel.hidden = NO;
    } else {
        _noticeLabel.hidden = YES;
    }
}

- (IBAction)hideTextKeyboard:(id)sender {
}

- (void)keyboardWillShow:(NSNotification *)notification {
    if (_topViewHeightConstraint.constant == 0) {
        return;
    }
    
    //_textViewTopConstraint.constant = - CGRectGetHeight(_topView.frame) + 64;
    [self.view layoutIfNeeded];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    if (_topViewHeightConstraint.constant == 0) {
        return;
    }
    //_textViewTopConstraint.constant = 0;
    [self.view layoutIfNeeded];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"_UIImagePickerControllerUserDidCaptureItem" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"_UIImagePickerControllerUserDidRejectItem" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (void)takedPhoto:(NSDictionary *)userInfo {
    [_chooseAlbumButton removeFromSuperview];
}

- (void)rejectedPhoto:(NSDictionary *)userInfo {
    [_cameraController.view addSubview:_chooseAlbumButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupViews {
    self.title = _type == ClockInType_Food ? @"饮食打卡" : @"运动打卡";
    _typeLabel.text = _type == ClockInType_Food ? @"饮食摄入" : @"运动消耗";
    
    NSMutableAttributedString *calorieString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@大卡", _calories]];
    [calorieString setAttributes:@{NSForegroundColorAttributeName : kFoodLabelGreenColor}
                           range:[calorieString.string rangeOfString:_calories]];
    _calorieLabel.attributedText = calorieString;
}

- (IBAction)showCamere:(id)sender {
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
        [self openEditWithImage:image];
    }];
}

- (void)openEditWithImage:(UIImage *)image {
    UINavigationController *photoEditNav = [[UIStoryboard storyboardWithName:@"PhotoEdit" bundle:nil] instantiateViewControllerWithIdentifier:@"PhotoEditViewNavgation"];
    PhotoEditViewController *photoEditVC = photoEditNav.viewControllers.firstObject;
    photoEditVC.inputImage = image;
    photoEditVC.handler = ^(UIImage *resultImage,NSArray *tags, UIViewController *editer) {
        [editer dismissModalViewControllerAnimated];
        _thumbImageView.image = resultImage;
        _tagArray = [tags mutableCopy];
        [self hideTopView];
    };
    [self presentViewController:photoEditNav animated:YES completion:nil];
    
}

- (void)hideTopView {
    _topViewHeightConstraint.constant = 0;
    _textLeadingConstraint.constant = CGRectGetMaxX(_thumbImageView.frame) + 5;
    [_thumbImageView addGestureRecognizer:_imageTapGR];
    _thumbImageView.userInteractionEnabled = YES;
    [self.view layoutIfNeeded];
}

- (IBAction)hideKeyBoard:(id)sender {
    [_contentTextView resignFirstResponder];
}

- (IBAction)record:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    Class class = _type == ClockInType_Food ? [FoodModel class] : [SportModel class];
    [class record:_selectedGoods calories:_calories.doubleValue image:_thumbImageView.image tags:_tagArray content:_contentTextView.text handler:^(id object, NSString *msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (msg) {
            [RBNoticeHelper showNoticeAtViewController:self msg:msg];
        } else {
            [RBNoticeHelper showNoticeAtView:[UIApplication sharedApplication].keyWindow y:20 msg:@"打卡成功"];
            //DataChartView will refresh the data;
            [[NSNotificationCenter defaultCenter] postNotificationName:ClockInOverNotificationKey object:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}
@end
