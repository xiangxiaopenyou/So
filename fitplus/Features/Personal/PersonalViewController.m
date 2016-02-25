//
//  PersonalViewController.m
//  fitplus
//
//  Created by xlp on 15/7/2.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "PersonalViewController.h"
#import "PersonalInfoCell.h"
#import "PersonalCommons.h"
#import "CommonsDefines.h"
#import "MobileBindingViewController.h"
#import "InformationModel.h"
#import "Util.h"
#import <UIImageView+AFNetworking.h>
#import "UIImage+ImageEffects.h"
#import "HelpAndFeedbackViewController.h"
#import "AboutViewController.h"
#import "RBBlockAlertView.h"
#import "RBNoticeHelper.h"
#import "BindingViewController.h"
#import "ChooseHobbyViewController.h"

@interface PersonalViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *personalTableView;
@property (copy, nonatomic) NSArray *infoArray;
@property (copy, nonatomic) NSArray *iconArray;
@property (copy, nonatomic) NSMutableDictionary *informationDictionary;
@property (assign, nonatomic)BOOL isNottify;

@end

@implementation PersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"设置";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView) name:@"EditSuccess" object:nil];
    
    _infoArray = [[NSArray alloc] initWithObjects:@"健身兴趣", @"账号绑定", @"缓存管理", @"帮助与反馈", @"关于", nil];
    _iconArray = [[NSArray alloc] initWithObjects:@"leftbar_hobby", @"leftbar_link", @"leftbar_cache", @"leftbar_help", @"leftbar_about", nil];
    _personalTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self fetchInformation];
    
}
- (void)addImage {
//    CIContext *context = [CIContext contextWithOptions:nil];
//    CIImage *inputImage = [[CIImage alloc] initWithImage:[UIImage imageNamed:@"recommendation_test"]];
//    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
//    [filter setValue:inputImage forKey:kCIInputImageKey];
//    [filter setValue:[NSNumber numberWithFloat:30.0] forKey:@"inputRadius"];
//    CIImage *result = [filter valueForKey:kCIOutputImageKey];
//    CGImageRef cgImage = [context createCGImage:result fromRect:_personalBackgroundImage.frame];
//    UIImage *image = [UIImage imageWithCGImage:cgImage];
//    CGImageRelease(cgImage);
//    _personalBackgroundImage.image = image;
//    [_personalHeadImage ]
//    [_personalHeadImage setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:_informationDictionary[@"portrait"]]] placeholderImage:nil];
//    __weak PersonalViewController *weakSelf = self;
//    [_personalHeadImage setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[Util urlPhoto:_informationDictionary[@"portrait"]]]] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
//        __strong PersonalViewController *strongSelf = weakSelf;
//        UIImage *effectImage = [image applyLightEffect];
//        [strongSelf.personalBackgroundImage setImage:effectImage];
//        [strongSelf.personalHeadImage setImage:image];
//    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
//        
//    }];
}
- (void)refreshView {
    [self fetchInformation];
}
- (void)fetchInformation {
    [InformationModel fetchMyInfomation:^(id object, NSString *msg) {
        if (msg) {
        } else {
            _informationDictionary = [object mutableCopy];
            [self addImage];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UITableView Delegate DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 2;
            break;
        case 3:
            return 1;
            break;
        default:
            return 0;
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 46;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, SCREEN_WIDTH, 46);
        [button setTitle:@"退出登录" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(logoutButoonClick) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [cell addSubview:button];
        //cell.accessoryType = UITableViewCellSeparatorStyleNone;
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        line.backgroundColor = kHeadPortraitBorderColor;
        [cell addSubview:line];
        UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, 1)];
        line1.backgroundColor = kHeadPortraitBorderColor;
        [cell addSubview:line1];
        return cell;
    } else {
        static NSString *InformationCellIdentifier = @"PersonalInfoCell";
        PersonalInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:InformationCellIdentifier forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[PersonalInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:InformationCellIdentifier];
        }
        NSString *iconString = nil;
        NSString *infoNameString = nil;
        if (indexPath.section == 0) {
            iconString = _iconArray[0];
            infoNameString = _infoArray[0];
            //        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
            //        line.backgroundColor = kHeadPortraitBorderColor;
            //        [cell addSubview:line];
            UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, 1)];
            line1.backgroundColor = kHeadPortraitBorderColor;
            [cell addSubview:line1];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else if (indexPath.section == 1) {
            iconString = _iconArray[indexPath.row + 1];
            infoNameString = _infoArray[indexPath.row + 1];
            if (indexPath.row == 0) {
                UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(50, 45, SCREEN_WIDTH, 1)];
                line.backgroundColor = kHeadPortraitBorderColor;
                [cell addSubview:line];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            } else {
                UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, 1)];
                line.backgroundColor = kHeadPortraitBorderColor;
                [cell addSubview:line];
            }
        } else {
            iconString = _iconArray[indexPath.row + 3];
            infoNameString = _infoArray[indexPath.row + 3];
            if (indexPath.row == 0) {
                UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(50, 45, SCREEN_WIDTH, 1)];
                line.backgroundColor = kHeadPortraitBorderColor;
                [cell addSubview:line];
            } else {
                UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, 1)];
                line.backgroundColor = kHeadPortraitBorderColor;
                [cell addSubview:line];
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        [cell setupInformation:iconString withInfoName:infoNameString];
        if (indexPath.row == 0) {
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
            line.backgroundColor = kHeadPortraitBorderColor;
            [cell addSubview:line];
        }
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _isNottify = YES;
    switch (indexPath.section) {
        case 0:{
            ChooseHobbyViewController *chooseHobbyView = [[UIStoryboard storyboardWithName:@"Personal" bundle:nil] instantiateViewControllerWithIdentifier:@"HobbyView"];
            [self.navigationController pushViewController:chooseHobbyView animated:YES];
        }
            break;
        case 1:{
            if (indexPath.row == 0) {
                if ([Util isEmpty:_informationDictionary[@"tel"]]) {
                    MobileBindingViewController *mobileViewController = [[UIStoryboard storyboardWithName:@"Personal" bundle:nil] instantiateViewControllerWithIdentifier:@"MobileBindingFirstView"];
                    [self.navigationController pushViewController:mobileViewController animated:YES];
                } else {
                    BindingViewController *bindingViewController = [[UIStoryboard storyboardWithName:@"Personal" bundle:nil] instantiateViewControllerWithIdentifier:@"BindingView"];
                    bindingViewController.mobileString = _informationDictionary[@"tel"];
                    [self.navigationController pushViewController:bindingViewController animated:YES];
                }
            } else {
                [[[RBBlockAlertView alloc] initWithTitle:@"提示" message:@"确定要清除缓存吗?" block:^(NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                        [self clearCache];
                    }
                } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
            }
            
        }
            break;
        case 2:{
            if (indexPath.row == 0) {
                HelpAndFeedbackViewController *helpViewController = [[UIStoryboard storyboardWithName:@"Personal" bundle:nil] instantiateViewControllerWithIdentifier:@"HelpView"];
                helpViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:helpViewController animated:YES];
            } else {
                AboutViewController *aboutViewController = [[UIStoryboard storyboardWithName:@"Personal" bundle:nil] instantiateViewControllerWithIdentifier:@"AboutView"];
                aboutViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:aboutViewController animated:YES];
            }
            
        }
            break;
            
        default:
            break;
    }
}
- (void)clearCache {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *cachPath = [NSString stringWithFormat:@"%@/Library/Caches/",  NSHomeDirectory()];
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
        for (NSString *p in files) {
            NSError *error;
            NSString *path = [cachPath stringByAppendingPathComponent:p];
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
            }
        }
        [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];
    });
}
- (void)clearCacheSuccess {
    [RBNoticeHelper showNoticeAtViewController:self msg:@"清除成功"];
}
- (void)logoutButoonClick {
    [[[RBBlockAlertView alloc] initWithTitle:@"" message:@"确认退出吗？" block:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserTokenKey];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserIdKey];
            UIViewController *loginViewController = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginView"];
            [self.navigationController pushViewController:loginViewController animated:YES];
        }
    } cancelButtonTitle:@"算了" otherButtonTitles:@"退了", nil] show];
}

- (void)viewWillAppear:(BOOL)animated{
    //self.navigationController.navigationBarHidden = YES;
    if (_isNottify) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SENDVIEW" object:self];
        _isNottify = NO;
    }
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
