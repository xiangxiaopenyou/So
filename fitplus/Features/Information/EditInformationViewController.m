//
//  EditInformationViewController.m
//  fitplus
//
//  Created by xlp on 15/8/28.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "EditInformationViewController.h"
#import <AFNetworking.h>
#import "ChangeInforModel.h"
#import "Util.h"
#import <UIImageView+AFNetworking.h>
#import "RBBlockActionSheet.h"
#import "RBBlockAlertView.h"
#import "InformationModel.h"
#import <MBProgressHUD.h>
#import "RBNoticeHelper.h"

#define INTRODUCE  @"introduce"
#define PORTRAIT @"portrait"
#define DURATION  @"duration"
#define WEIGHTT  @"weightTT"

@interface EditInformationViewController ()<UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *informationTableView;
@property (copy, nonatomic) NSArray *infoArray;
@property (strong, nonatomic) ChangeInforModel *informationModel;
@property (strong, nonatomic) UIImageView *headImageView;
@property (strong, nonatomic) UITextField *nicknameTextField;
@property (strong, nonatomic) UITextField *signTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *heightPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *weightPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *targetWeightPickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *durationPickerView;
@property (strong, nonatomic) UIImage *headImage;
@property (assign, nonatomic) NSInteger indexRow;
@property (assign, nonatomic) NSInteger indexRow2;

@end

@implementation EditInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"个人信息";
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveClick)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    _infoArray = [NSArray arrayWithObjects:@"头像", @"昵称", @"性别", @"身高", @"体重", @"目标体重", @"训练周期", @"个性签名", nil];
    _informationModel = [ChangeInforModel new];
    _informationTableView.tableFooterView = [UIView new];
    if ([self isNetworking]) {
        [ChangeInforModel fetchMyInfomation:^(id object, NSString *msg) {
            if (!msg) {
                _informationModel = [object copy];
                [_informationTableView reloadData];
            }
        }];
    } else {
        _informationModel.duration = [[NSUserDefaults standardUserDefaults] valueForKey:DURATION];
        _informationModel.height = [[NSUserDefaults standardUserDefaults] valueForKey:UserHeight];
        _informationModel.introduce = [[NSUserDefaults standardUserDefaults] valueForKey:INTRODUCE];
        _informationModel.nickname = [[NSUserDefaults standardUserDefaults] valueForKey:UserName];
        _informationModel.portrait = [[NSUserDefaults standardUserDefaults] valueForKey:PORTRAIT];
        _informationModel.sex = [[NSUserDefaults standardUserDefaults] valueForKey:UserSex];
        _informationModel.weight = [[NSUserDefaults standardUserDefaults] valueForKey:UserWeight];
        _informationModel.weightT = [[NSUserDefaults standardUserDefaults] valueForKey:WEIGHTT];
        [_informationTableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)saveClick {
    [_nicknameTextField resignFirstResponder];
    [_signTextField resignFirstResponder];
    [self hidePickerView];
    [[[RBBlockAlertView alloc] initWithTitle:@"" message:@"确定保存吗？" block:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            if ([self isNetworking]) {
                if (_headImage) {
                    [InformationModel chageInformationWithImage:_headImage with:_informationModel handler:^(id object, NSString *msg) {
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        if (msg) {
                            [RBNoticeHelper showNoticeAtView:self.view msg:@"修改失败"];
                        } else {
                            //[RBNoticeHelper showNoticeAtView:self.view msg:@"修改成功"];
                            [self.navigationController popViewControllerAnimated:YES];
                            
                        }
                    }];
                } else {
                    [InformationModel chageInformationWithChageModel:_informationModel handler:^(id object, NSString *msg) {
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        if (msg) {
                            [RBNoticeHelper showNoticeAtViewController:self msg:@"修改失败"];
                        } else {
                            //[RBNoticeHelper showNoticeAtView:self.view msg:@"修改成功"];
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    }];
                }
            }
            [[NSUserDefaults standardUserDefaults] setObject:_informationModel.introduce forKey:INTRODUCE];
            [[NSUserDefaults standardUserDefaults] setObject:_informationModel.height forKey:UserHeight];
            [[NSUserDefaults standardUserDefaults] setObject:_informationModel.portrait forKey:PORTRAIT];
            [[NSUserDefaults standardUserDefaults] setObject:_informationModel.nickname forKey:UserName];
            [[NSUserDefaults standardUserDefaults] setObject:_informationModel.duration forKey:DURATION];
            [[NSUserDefaults standardUserDefaults] setObject:_informationModel.weightT forKey:WEIGHTT];
            [[NSUserDefaults standardUserDefaults] setObject:_informationModel.weight forKey:UserWeight];
            [[NSUserDefaults standardUserDefaults] setObject:_informationModel.sex forKey:UserSex];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    } cancelButtonTitle:@"不了" otherButtonTitles:@"保存", nil] show];
}
#pragma mark - UITextField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self hidePickerView];
    if (textField == _signTextField) {
        [_informationTableView setContentOffset:CGPointMake(0, 150) animated:YES];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        [_informationTableView setContentOffset:CGPointMake(0, -64) animated:YES];
        return NO;
    }
//    if (textField == _nicknameTextField) {
//        _informationModel.nickname = _nicknameTextField.text;
//    } else {
//        _informationModel.introduce = _signTextField.text;
//    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _nicknameTextField) {
        _informationModel.nickname = _nicknameTextField.text;
    } else {
        _informationModel.introduce = _signTextField.text;
    }
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowNum = 0;
    switch (section) {
        case 0:{
            rowNum = 3;
        }
            break;
        case 1:{
            rowNum = 4;
        }
            break;
        case 2:{
            rowNum = 1;
        }
            break;
        default:
            break;
    }
    return rowNum;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 14;
    } else {
        return 20;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowHeight = 0;
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row == 0) {
                rowHeight = 82;
            } else {
                rowHeight = 44;
            }
        }
            break;
        case 1:{
            rowHeight = 44;
        }
            break;
        case 2:{
            rowHeight = 44;
        }
            break;
        default:
            break;
    }
    return rowHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    //if (cell == nil) {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    //}
    switch (indexPath.section) {
        case 0:{
            cell.textLabel.text = _infoArray[indexPath.row];
            cell.textLabel.textColor = [UIColor colorWithRed:81/255.0 green:81/255.0 blue:81/255.0 alpha:1.0];
            if (indexPath.row == 0) {
                if (!_headImageView) {
                    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 78, 9, 64, 64)];
                }
                _headImageView.layer.masksToBounds = YES;
                _headImageView.layer.cornerRadius = 32.0;
                if (_headImage) {
                    _headImageView.image = _headImage;
                } else {
                    [_headImageView setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:_informationModel.portrait]] placeholderImage:[UIImage imageNamed:@"default_headportrait"]];
                }
                [cell addSubview:_headImageView];
                
            } else if (indexPath.row == 1) {
                if (!_nicknameTextField) {
                    _nicknameTextField = [[UITextField alloc] initWithFrame:CGRectMake(60, 0, SCREEN_WIDTH - 74, 44)];
                }
                _nicknameTextField.borderStyle = UITextBorderStyleNone;
                _nicknameTextField.backgroundColor = [UIColor clearColor];
                _nicknameTextField.textAlignment = NSTextAlignmentRight;
                _nicknameTextField.delegate = self;
                _nicknameTextField.returnKeyType = UIReturnKeyDone;
                _nicknameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
                _nicknameTextField.font = [UIFont systemFontOfSize:14];
                _nicknameTextField.textColor = [UIColor colorWithRed:184/255.0 green:184/255.0 blue:184/255.0 alpha:1.0];
                _nicknameTextField.text = _informationModel.nickname;
                [cell addSubview:_nicknameTextField];
            } else {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                UIImageView *sexImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 46, 14, 16, 16)];
                if ([_informationModel.sex integerValue] == 2) {
                    sexImage.image = [UIImage imageNamed:@"info_sex_women"];
                } else {
                    sexImage.image = [UIImage imageNamed:@"info_man_sex"];
                }
                [cell addSubview:sexImage];
            }
        }
            break;
        case 1:{
            cell.textLabel.text = _infoArray[indexPath.row + 3];
            cell.textLabel.textColor = [UIColor colorWithRed:81/255.0 green:81/255.0 blue:81/255.0 alpha:1.0];
            UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 114, 0, 100, 44)];
            tempLabel.font = [UIFont systemFontOfSize:14];
            tempLabel.textAlignment = NSTextAlignmentRight;
            tempLabel.textColor = [UIColor colorWithRed:184/255.0 green:184/255.0 blue:184/255.0 alpha:1.0];
            [cell addSubview:tempLabel];
            NSString *labelText = @"";
            if (indexPath.row == 0) {
                if (![Util isEmpty:_informationModel.height]) {
                    labelText = [NSString stringWithFormat:@"%@cm", _informationModel.height];
                }
            } else if (indexPath.row == 1) {
                if (![Util isEmpty:_informationModel.weight]) {
                    labelText = [NSString stringWithFormat:@"%@kg", _informationModel.weight];
                }
            } else if (indexPath.row == 2) {
                if (![Util isEmpty:_informationModel.weightT]) {
                    labelText = [NSString stringWithFormat:@"%@kg", _informationModel.weightT];
                }
            } else {
                if (![Util isEmpty:_informationModel.duration]) {
                    labelText = [NSString stringWithFormat:@"%@周", _informationModel.duration];
                }
            }
            tempLabel.text = labelText;
        }
            break;
        case 2:{
            cell.textLabel.text = _infoArray[indexPath.row + 7];
            cell.textLabel.textColor = [UIColor colorWithRed:81/255.0 green:81/255.0 blue:81/255.0 alpha:1.0];
            if (!_signTextField) {
                _signTextField = [[UITextField alloc] initWithFrame:CGRectMake(80, 0, SCREEN_WIDTH - 94, 44)];
            }
            _signTextField.borderStyle = UITextBorderStyleNone;
            _signTextField.backgroundColor = [UIColor clearColor];
            _signTextField.textAlignment = NSTextAlignmentRight;
            _signTextField.delegate = self;
            _signTextField.returnKeyType = UIReturnKeyDone;
            _signTextField.font = [UIFont systemFontOfSize:14];
            _signTextField.textColor = [UIColor colorWithRed:184/255.0 green:184/255.0 blue:184/255.0 alpha:1.0];
            _signTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            _signTextField.text = _informationModel.introduce;
            [cell addSubview:_signTextField];
        }
            break;
            
        default:
            break;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row == 0) {
                [self headButtonClick];
                [self hidePickerView];
                [_signTextField resignFirstResponder];
                [_nicknameTextField resignFirstResponder];
            } else if (indexPath.row == 1) {
                [_nicknameTextField becomeFirstResponder];
            } else {
                [self sexImageClick];
                [self hidePickerView];
                [_signTextField resignFirstResponder];
                [_nicknameTextField resignFirstResponder];
            }
        }
            break;
        case 1:{
            [_nicknameTextField resignFirstResponder];
            [_signTextField resignFirstResponder];
            if (indexPath.row == 0) {
                _heightPickerView.hidden = NO;
                _weightPickerView.hidden = YES;
                _targetWeightPickerView.hidden = YES;
                _durationPickerView.hidden = YES;
                [_heightPickerView selectRow:[_informationModel.height integerValue] - 100 inComponent:0 animated:YES];
               
                
                NSArray *numArray = [_informationModel.height componentsSeparatedByString:@"."];
                if (numArray.count == 2) {
                    [_heightPickerView selectRow:[numArray[1] integerValue] inComponent:1 animated:YES];
                }
            } else if (indexPath.row == 1) {
                _heightPickerView.hidden = YES;
                _weightPickerView.hidden = NO;
                _targetWeightPickerView.hidden = YES;
                _durationPickerView.hidden = YES;
                [_weightPickerView selectRow:[_informationModel.weight integerValue] -20 inComponent:0 animated:YES];
                NSArray *numArray = [_informationModel.weight componentsSeparatedByString:@"."];
                if (numArray.count == 2) {
                    [_weightPickerView selectRow:[numArray[1] integerValue] inComponent:1 animated:YES];
                }
            } else if (indexPath.row == 2) {
                _heightPickerView.hidden = YES;
                _weightPickerView.hidden = YES;
                _targetWeightPickerView.hidden = NO;
                _durationPickerView.hidden = YES;
                NSArray *numArray = [_informationModel.weightT componentsSeparatedByString:@"."];
                if (numArray.count == 2) {
                    [_targetWeightPickerView selectRow:[numArray[1] integerValue] inComponent:1 animated:YES];
                }
                if ([_informationModel.weightT integerValue] > 20) {
                    [_targetWeightPickerView selectRow:[_informationModel.weightT integerValue] -20 inComponent:0 animated:YES];
                } else {
                    [_targetWeightPickerView selectRow:60 inComponent:0 animated:YES];
                }
                
            } else {
                _heightPickerView.hidden = YES;
                _weightPickerView.hidden = YES;
                _targetWeightPickerView.hidden = YES;
                _durationPickerView.hidden = NO;
                [_durationPickerView selectRow:[_informationModel.duration integerValue] inComponent:0 animated:YES];
            }

        }
            break;
        case 2:{
            [_signTextField becomeFirstResponder];
            [_informationTableView setContentOffset:CGPointMake(0, 150) animated:YES];
        }
            break;
            
        default:
            break;
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self hidePickerView];
}
- (void)hidePickerView {
    [_heightPickerView setHidden:YES];
    [_weightPickerView setHidden:YES];
    [_targetWeightPickerView setHidden:YES];
    [_durationPickerView setHidden:YES];
}

#pragma mark - UIPickerView Delegate Datasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (pickerView == _weightPickerView || pickerView == _targetWeightPickerView) {
        return 2;
    } else {
        return 1;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return 100;
    }else {
        return 10;
    }
    
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        if (pickerView == _heightPickerView) {
            return [NSString stringWithFormat:@"%ld",(long)row + 100];
        }
        if (pickerView == _weightPickerView) {
            return [NSString stringWithFormat:@"%ld",(long)row +20];
        }
        if (pickerView == _targetWeightPickerView) {
            return [NSString stringWithFormat:@"%ld",(long)row +20];
        }else {
            return [NSString stringWithFormat:@"%ld",(long)row];
        }
        
    }else {
        return [NSString stringWithFormat:@".%ld",(long)row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (pickerView == _durationPickerView || pickerView == _heightPickerView) {
        _indexRow2 = row;
    } else {
        if (component == 0) {
            [pickerView reloadComponent:1];
            [pickerView selectRow:0 inComponent:1 animated:YES];
            _indexRow2 = row;
            _indexRow = 0;
        } else {
            _indexRow = row;
        }
    }
    if (pickerView == _heightPickerView) {
        if (!_indexRow2) {
            _indexRow2 = [_informationModel.height integerValue] - 100;
        }
        _informationModel.height = [NSString stringWithFormat:@"%ld",(long)_indexRow2 + 100];
    }
    if (pickerView == _weightPickerView) {
        if (!_indexRow2) {
            _indexRow2 = [_informationModel.weight integerValue] - 20;
        }
        _informationModel.weight = [NSString stringWithFormat:@"%ld.%ld",(long)_indexRow2 +20, (long)_indexRow];
    }
    if (pickerView == _targetWeightPickerView) {
        if (!_indexRow2) {
            _indexRow2 = [_informationModel.weightT integerValue] - 20;
        }
        _informationModel.weightT = [NSString stringWithFormat:@"%ld.%ld",(long)_indexRow2 +20, (long)_indexRow];
    }
    if (pickerView == _durationPickerView) {
        _informationModel.duration = [NSString stringWithFormat:@"%ld",(long)_indexRow2];
    }
    [_informationTableView reloadData];
}
- (BOOL)isNetworking {
    __block BOOL isNetWorking = YES;
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == 0) {
            isNetWorking = NO;
        } else {
            isNetWorking = YES;
        }
    }];
    return isNetWorking;
}
- (void)headButtonClick {
    [[[RBBlockActionSheet alloc] initWithTitle:nil clickBlock:^(NSInteger buttonIndex) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            if (buttonIndex == 0) {
                UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                imagePickerController.delegate = self;
                imagePickerController.allowsEditing = YES;
                imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:imagePickerController animated:YES completion:nil];
            }
            if (buttonIndex == 2) {
                UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                imagePickerController.delegate = self;
                imagePickerController.allowsEditing = YES;
                imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:imagePickerController animated:YES completion:nil];
            }
        }
    } cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册中选择",nil] showInView:self.view];
}
#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
    _headImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [_informationTableView reloadData];
}

- (void)sexImageClick {
    [[[RBBlockActionSheet alloc] initWithTitle:nil clickBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            _informationModel.sex = @"1";
        }
        if (buttonIndex == 2) {
            _informationModel.sex = @"2";
        }
        [_informationTableView reloadData];
    } cancelButtonTitle:@"取消" destructiveButtonTitle:@"男" otherButtonTitles:@"女", nil] showInView:self.view];
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
