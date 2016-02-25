//
//  SendPhotoViewController.m
//  fitplus
//
//  Created by xlp on 15/8/21.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "SendPhotoViewController.h"
#import "CommonsDefines.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <TuSDK/TuSDK.h>
#import "PhotoEditViewController.h"
#import "RBBlockAlertView.h"
#import "TakePhotoModel.h"
#import <MBProgressHUD.h>
#import "RBNoticeHelper.h"

@interface SendPhotoViewController ()<UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UITextField *contentTExtView;
@property (strong, nonatomic) UIImagePickerController *cameraController;
@property (strong, nonatomic) UIButton *chooseAlbumButton;
@property (strong, nonatomic) NSMutableArray *tagArray;
//@property (assign, nonatomic) BOOL isImage;

@end

@implementation SendPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self showPhotoView:nil];
    self.navigationItem.title = @"拍照";
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendClick)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    //_isImage = NO;
    [self openEditWithImage:_image];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(takedPhoto:) name:@"_UIImagePickerControllerUserDidCaptureItem" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rejectedPhoto:) name:@"_UIImagePickerControllerUserDidRejectItem" object:nil];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"_UIImagePickerControllerUserDidCaptureItem" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"_UIImagePickerControllerUserDidRejectItem" object:nil];
}
- (IBAction)showPhotoView:(id)sender {
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
- (void)takedPhoto:(NSDictionary *)userInfo {
    [_chooseAlbumButton removeFromSuperview];
}

- (void)rejectedPhoto:(NSDictionary *)userInfo {
    [_cameraController.view addSubview:_chooseAlbumButton];
}

- (void)openEditWithImage:(UIImage *)image {
    UINavigationController *photoEditNav = [[UIStoryboard storyboardWithName:@"PhotoEdit" bundle:nil] instantiateViewControllerWithIdentifier:@"PhotoEditViewNavgation"];
    PhotoEditViewController *photoEditVC = photoEditNav.viewControllers.firstObject;
    photoEditVC.inputImage = image;
    photoEditVC.handler = ^(UIImage *resultImage,NSArray *tags, UIViewController *editer) {
        [editer dismissModalViewControllerAnimated];
        _imageView.image = resultImage;
        _tagArray = [tags mutableCopy];
//        _isImage = YES;
    };
    [self presentViewController:photoEditNav animated:YES completion:nil];
    
}
- (void)sendClick {
//    if (!_isImage) {
//        [RBBlockAlertView showMsg:@"没发图片哦~" cancelTitle:@"取消"];
//        return;
//    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [TakePhotoModel record:nil calories:0 image:_imageView.image tags:_tagArray content:_contentTExtView.text handler:^(id object, NSString *msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (msg) {
            [RBNoticeHelper showNoticeAtViewController:self msg:@"发送失败"];
        } else {
            [RBNoticeHelper showNoticeAtView:[UIApplication sharedApplication].keyWindow y:20 msg:@"发送成功"];
            //DataChartView will refresh the data;
            [[NSNotificationCenter defaultCenter] postNotificationName:ClockInOverNotificationKey object:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }

    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextView Delegate
- (IBAction)hideKeyboard:(id)sender {
    [_contentTExtView resignFirstResponder];
}
- (IBAction)textChanged:(id)sender {
    if ([_contentTExtView.text isEqualToString:@""]) {
        _tipLabel.hidden = NO;
    } else {
        _tipLabel.hidden = YES;
    }
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [_contentTExtView resignFirstResponder];
        return NO;
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

@end
