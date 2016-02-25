//
//  FifthGuideViewController.m
//  fitplus
//
//  Created by xlp on 15/11/12.
//  Copyright © 2015年 realtech. All rights reserved.
//

#import "FifthGuideViewController.h"
#import "CommonsDefines.h"
#import "UserInfoModel.h"
#import "RBBlockAlertView.h"
#import "LimitResultModel.h"
#import "ForthGuideViewController.h"
#define kButtonSelectedColor [UIColor colorWithRed:87/255.0 green:172/255.0 blue:184/255.0 alpha:1.0]

@interface FifthGuideViewController ()<UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *trainingTimeButton1;
@property (weak, nonatomic) IBOutlet UIButton *trainingTimeButton2;
@property (weak, nonatomic) IBOutlet UIButton *trainingTimeButton3;
@property (weak, nonatomic) IBOutlet UIButton *maleButton;
@property (weak, nonatomic) IBOutlet UIButton *femaleButton;
@property (weak, nonatomic) IBOutlet UIButton *bodyButton1;
@property (weak, nonatomic) IBOutlet UIButton *bodyButton2;
@property (weak, nonatomic) IBOutlet UIButton *bodyButton3;
@property (weak, nonatomic) IBOutlet UIButton *bodyButton4;
@property (weak, nonatomic) IBOutlet UIButton *bodyButton5;
@property (weak, nonatomic) IBOutlet UIButton *bodyButton6;
@property (weak, nonatomic) IBOutlet UIButton *bodyButton7;
@property (weak, nonatomic) IBOutlet UIButton *bodyButton8;
@property (weak, nonatomic) IBOutlet UIView *tagView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *heightLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *weightPickerView;

@property (nonatomic, strong) NSMutableArray *tagArray;
@property (nonatomic, assign) NSInteger userHeight;
@property (nonatomic, assign) CGFloat userWeight;
@property (nonatomic, assign) NSInteger userSex;
@property (nonatomic, assign) NSInteger userBody;
@property (nonatomic, strong) NSMutableArray *selectedTagArray;
@property (nonatomic, assign) NSInteger userTrainingTime;
@property (nonatomic, strong) NSMutableArray *courseArray;
@end

@implementation FifthGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UserHeight] != nil) {
        _userHeight = [[NSUserDefaults standardUserDefaults] integerForKey:UserHeight];
        _heightLabel.text = [NSString stringWithFormat:@"%ld", _userHeight];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UserWeight] != nil) {
        _userWeight = [[NSUserDefaults standardUserDefaults] floatForKey:UserWeight];
        _weightLabel.text = [NSString stringWithFormat:@"%.1f", _userWeight];
    }
    _userSex = [[NSUserDefaults standardUserDefaults] integerForKey:UserSex];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UserBody] == nil) {
        _userBody = 0;
    } else {
        _userBody = [[NSUserDefaults standardUserDefaults] integerForKey:UserBody];
    }
    _trainingTimeButton1.layer.borderColor = kButtonSelectedColor.CGColor;
    _trainingTimeButton2.layer.borderColor = kButtonSelectedColor.CGColor;
    _trainingTimeButton3.layer.borderColor = kButtonSelectedColor.CGColor;
    if (_userSex == 1) {
        _maleButton.selected = YES;
        _femaleButton.selected = NO;
        [self setMaleBody];
    } else {
        _maleButton.selected = NO;
        _femaleButton.selected = YES;
        [self setFemaleBody];
    }
    if (_userBody > 0) {
        switch (_userBody) {
            case 1:
                _bodyButton1.selected = YES;
                break;
            case 2:
                _bodyButton2.selected = YES;
                break;
            case 3:
                _bodyButton3.selected = YES;
                break;
            case 4:
                _bodyButton4.selected = YES;
                break;
            case 5:
                _bodyButton5.selected = YES;
                break;
            case 6:
                _bodyButton6.selected = YES;
                break;
            case 7:
                _bodyButton7.selected = YES;
                break;
            case 8:
                _bodyButton8.selected = YES;
                break;
            default:
                break;
        }
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UserTag] == nil) {
        _selectedTagArray = [[NSMutableArray alloc] init];
    } else {
        NSString *tagString = [[NSUserDefaults standardUserDefaults] stringForKey:UserTag];
        _selectedTagArray = [[tagString componentsSeparatedByString:@";"] mutableCopy];
    }
    [self fetchTagsRequest];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UserTrainingTime] != nil) {
        NSInteger timeInt = [[NSUserDefaults standardUserDefaults] integerForKey:UserTrainingTime];
        switch (timeInt) {
            case 1:{
                _trainingTimeButton1.selected = YES;
                _trainingTimeButton1.backgroundColor = kButtonSelectedColor;
                _userTrainingTime = 1;
            }
                break;
            case 2:{
                _trainingTimeButton2.selected = YES;
                _trainingTimeButton2.backgroundColor = kButtonSelectedColor;
                _userTrainingTime = 2;
            }
                break;
            case 3:{
                _trainingTimeButton3.selected = YES;
                _trainingTimeButton3.backgroundColor = kButtonSelectedColor;
                _userTrainingTime = 3;
            }
                break;
            default:
                break;
        }
    }
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    [_pickerView selectRow:70 inComponent:0 animated:NO];
    
    UILabel *cmLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 + 50, CGRectGetHeight(_pickerView.frame) / 2 - 15, 30, 30)];
    cmLabel.text = @"cm";
    cmLabel.font = [UIFont systemFontOfSize:18];
    [_pickerView addSubview:cmLabel];
    
    _weightPickerView.delegate = self;
    _weightPickerView.dataSource = self;
    [_weightPickerView selectRow:50 inComponent:0 animated:NO];
    
    UILabel *pointLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2, CGRectGetHeight(_weightPickerView.frame) / 2 - 15, 30, 30)];
    pointLabel.text = @".";
    pointLabel.font = [UIFont systemFontOfSize:18];
    [_weightPickerView addSubview:pointLabel];
    
    UILabel *kgLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 70, CGRectGetHeight(_weightPickerView.frame) / 2 - 15, 30, 30)];
    kgLabel.text = @"kg";
    kgLabel.font = [UIFont systemFontOfSize:18];
    [_weightPickerView addSubview:kgLabel];
}
#pragma mark - Request
- (void)fetchTagsRequest {
    [UserInfoModel fetchTags:^(id object, NSString *msg) {
        if (!msg) {
            _tagArray = [object mutableCopy];
            [self setupTagView];
        }
    }];
}
- (void)setMaleBody {
    [_bodyButton1 setBackgroundImage:[UIImage imageNamed:@"guide_malebody_01"] forState:UIControlStateNormal];
    [_bodyButton1 setBackgroundImage:[UIImage imageNamed:@"guide_malebody_selected_01"] forState:UIControlStateSelected];
    [_bodyButton2 setBackgroundImage:[UIImage imageNamed:@"guide_malebody_02"] forState:UIControlStateNormal];
    [_bodyButton2 setBackgroundImage:[UIImage imageNamed:@"guide_malebody_selected_02"] forState:UIControlStateSelected];
    [_bodyButton3 setBackgroundImage:[UIImage imageNamed:@"guide_malebody_03"] forState:UIControlStateNormal];
    [_bodyButton3 setBackgroundImage:[UIImage imageNamed:@"guide_malebody_selected_03"] forState:UIControlStateSelected];
    [_bodyButton4 setBackgroundImage:[UIImage imageNamed:@"guide_malebody_04"] forState:UIControlStateNormal];
    [_bodyButton4 setBackgroundImage:[UIImage imageNamed:@"guide_malebody_selected_04"] forState:UIControlStateSelected];
    [_bodyButton5 setBackgroundImage:[UIImage imageNamed:@"guide_malebody_05"] forState:UIControlStateNormal];
    [_bodyButton5 setBackgroundImage:[UIImage imageNamed:@"guide_malebody_selected_05"] forState:UIControlStateSelected];
    [_bodyButton6 setBackgroundImage:[UIImage imageNamed:@"guide_malebody_06"] forState:UIControlStateNormal];
    [_bodyButton6 setBackgroundImage:[UIImage imageNamed:@"guide_malebody_selected_06"] forState:UIControlStateSelected];
    [_bodyButton7 setBackgroundImage:[UIImage imageNamed:@"guide_malebody_07"] forState:UIControlStateNormal];
    [_bodyButton7 setBackgroundImage:[UIImage imageNamed:@"guide_malebody_selected_07"] forState:UIControlStateSelected];
    [_bodyButton8 setBackgroundImage:[UIImage imageNamed:@"guide_malebody_08"] forState:UIControlStateNormal];
    [_bodyButton8 setBackgroundImage:[UIImage imageNamed:@"guide_malebody_selected_08"] forState:UIControlStateSelected];
}
- (void)setFemaleBody {
    [_bodyButton1 setBackgroundImage:[UIImage imageNamed:@"guide_femalebody_01"] forState:UIControlStateNormal];
    [_bodyButton1 setBackgroundImage:[UIImage imageNamed:@"guide_femalebody_selected_01"] forState:UIControlStateSelected];
    [_bodyButton2 setBackgroundImage:[UIImage imageNamed:@"guide_femalebody_02"] forState:UIControlStateNormal];
    [_bodyButton2 setBackgroundImage:[UIImage imageNamed:@"guide_femalebody_selected_02"] forState:UIControlStateSelected];
    [_bodyButton3 setBackgroundImage:[UIImage imageNamed:@"guide_femalebody_03"] forState:UIControlStateNormal];
    [_bodyButton3 setBackgroundImage:[UIImage imageNamed:@"guide_femalebody_selected_03"] forState:UIControlStateSelected];
    [_bodyButton4 setBackgroundImage:[UIImage imageNamed:@"guide_femalebody_04"] forState:UIControlStateNormal];
    [_bodyButton4 setBackgroundImage:[UIImage imageNamed:@"guide_femalebody_selected_04"] forState:UIControlStateSelected];
    [_bodyButton5 setBackgroundImage:[UIImage imageNamed:@"guide_femalebody_05"] forState:UIControlStateNormal];
    [_bodyButton5 setBackgroundImage:[UIImage imageNamed:@"guide_femalebody_selected_05"] forState:UIControlStateSelected];
    [_bodyButton6 setBackgroundImage:[UIImage imageNamed:@"guide_femalebody_06"] forState:UIControlStateNormal];
    [_bodyButton6 setBackgroundImage:[UIImage imageNamed:@"guide_femalebody_selected_06"] forState:UIControlStateSelected];
    [_bodyButton7 setBackgroundImage:[UIImage imageNamed:@"guide_femalebody_07"] forState:UIControlStateNormal];
    [_bodyButton7 setBackgroundImage:[UIImage imageNamed:@"guide_femalebody_selected_07"] forState:UIControlStateSelected];
    [_bodyButton8 setBackgroundImage:[UIImage imageNamed:@"guide_femalebody_08"] forState:UIControlStateNormal];
    [_bodyButton8 setBackgroundImage:[UIImage imageNamed:@"guide_femalebody_selected_08"] forState:UIControlStateSelected];
}
- (void)setupTagView {
    CGFloat positionY = 54;
    CGFloat positionX = 14;
    for (NSInteger i = 0; i < _tagArray.count; i ++) {
        CGSize tagStringSize = [_tagArray[i][@"name"] sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14], NSFontAttributeName, nil]];
        if (positionX + tagStringSize.width + 38 > SCREEN_WIDTH) {
            positionX = 14;
            positionY += 48;
        }
        UIButton *tagButton = [UIButton buttonWithType:UIButtonTypeCustom];
        tagButton.frame = CGRectMake(positionX, positionY, tagStringSize.width + 24, 34);
        [tagButton setTitle:_tagArray[i][@"name"] forState:UIControlStateNormal];
        [tagButton setTitleColor:kButtonSelectedColor forState:UIControlStateNormal];
        [tagButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        tagButton.titleLabel.font = [UIFont systemFontOfSize:14];
        tagButton.backgroundColor = [UIColor whiteColor];
        tagButton.layer.masksToBounds = YES;
        tagButton.layer.cornerRadius = 2.0;
        tagButton.layer.borderWidth = 0.5;
        tagButton.layer.borderColor = kButtonSelectedColor.CGColor;
        tagButton.tag = [_tagArray[i][@"id"] integerValue];
        if ([_selectedTagArray containsObject:_tagArray[i][@"id"]]) {
            tagButton.selected = YES;
            tagButton.backgroundColor = kButtonSelectedColor;
        }
        [tagButton addTarget:self action:@selector(tagButtonSelecor:) forControlEvents:UIControlEventTouchUpInside];
        [_tagView addSubview:tagButton];
        positionX += tagStringSize.width + 38;
    }
    _tagViewHeightConstraint.constant = positionY + 48;
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
#pragma mark - UIPickerView Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (pickerView == _pickerView) {
        return 1;
    } else {
        return 2;
    }
    
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == _pickerView) {
        return 100;
    } else {
        switch (component) {
            case 0:
                return 130;
                break;
            case 1:
                return 10;
                break;
            default:
                return 0;
                break;
        }
    }
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (pickerView == _pickerView) {
        return CGRectGetWidth(_pickerView.frame);
    } else {
        switch (component) {
            case 0:
                return CGRectGetWidth(_pickerView.frame)/2 - 30;
                break;
            case 1:
                return CGRectGetWidth(_pickerView.frame)/2 - 30;
                break;
            default:
                return 0;
                break;
        }
    }
    
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 34;
}
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView == _pickerView) {
        return [NSString stringWithFormat:@"%ld", (long)row + 100];
    } else {
        switch (component) {
            case 0:
                return [NSString stringWithFormat:@"%ld", (long)row + 20];
                break;
            case 1:
                return [NSString stringWithFormat:@"%ld", (long)row];
                break;
            default:
                return nil;
                break;
        }
    }
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView == _pickerView) {
        NSInteger heightInt = [pickerView selectedRowInComponent:0];
        _userHeight = heightInt + 100;
        _heightLabel.text = [NSString stringWithFormat:@"%ld", _userHeight];
        
    } else {
        NSInteger weightInt1 = [pickerView selectedRowInComponent:0];
        NSInteger weightInt2 = [pickerView selectedRowInComponent:1];
        if (weightInt2 != 0) {
            _weightLabel.text = [NSString stringWithFormat:@"%ld.%ld", weightInt1 + 20, weightInt2];
        } else {
            _weightLabel.text = [NSString stringWithFormat:@"%ld", weightInt1 + 20];
        }
        _userWeight = [_weightLabel.text floatValue];
    }
    

}


- (void)tagButtonSelecor:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (button.selected) {
        button.selected = NO;
        button.backgroundColor = [UIColor whiteColor];
        [_selectedTagArray removeObject:@(button.tag)];
    } else {
        button.selected = YES;
        button.backgroundColor = kButtonSelectedColor;
        [_selectedTagArray addObject:@(button.tag)];
    }
}
- (IBAction)heightButtonClick:(id)sender {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetHeight(_pickerView.frame));
    [backButton addTarget:self action:@selector(backgroundButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    _pickerView.hidden = NO;
}
- (IBAction)weightButtonClick:(id)sender {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetHeight(_pickerView.frame));
    [backButton addTarget:self action:@selector(backgroundButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    _weightPickerView.hidden = NO;
}
- (void)backgroundButtonClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    [button removeFromSuperview];
    _pickerView.hidden = YES;
    _weightPickerView.hidden = YES;
}
- (IBAction)maleButtonClick:(id)sender {
    if (!_maleButton.selected) {
        _userSex = 1;
        _maleButton.selected = YES;
        _femaleButton.selected = NO;
        [self setMaleBody];
    }
}
- (IBAction)femaleButtonClick:(id)sender {
    if (!_femaleButton.selected) {
        _userSex = 2;
        _femaleButton.selected = YES;
        _maleButton.selected = NO;
        [self setFemaleBody];
    }
}
- (IBAction)bodyButton1Click:(id)sender {
    if (!_bodyButton1.selected) {
        _userBody = 1;
        _bodyButton1.selected = YES;
        _bodyButton2.selected = NO;
        _bodyButton3.selected = NO;
        _bodyButton4.selected = NO;
        _bodyButton5.selected = NO;
        _bodyButton6.selected = NO;
        _bodyButton7.selected = NO;
        _bodyButton8.selected = NO;
        
    }
}
- (IBAction)bodyButton2Click:(id)sender {
    if (!_bodyButton2.selected) {
        _userBody = 2;
        _bodyButton1.selected = NO;
        _bodyButton2.selected = YES;
        _bodyButton3.selected = NO;
        _bodyButton4.selected = NO;
        _bodyButton5.selected = NO;
        _bodyButton6.selected = NO;
        _bodyButton7.selected = NO;
        _bodyButton8.selected = NO;
    }
}
- (IBAction)bodyButton3Click:(id)sender {
    if (!_bodyButton3.selected) {
        _userBody = 3;
        _bodyButton1.selected = NO;
        _bodyButton2.selected = NO;
        _bodyButton3.selected = YES;
        _bodyButton4.selected = NO;
        _bodyButton5.selected = NO;
        _bodyButton6.selected = NO;
        _bodyButton7.selected = NO;
        _bodyButton8.selected = NO;
    }
}
- (IBAction)bodyButton4Click:(id)sender {
    if (!_bodyButton4.selected) {
        _userBody = 4;
        _bodyButton1.selected = NO;
        _bodyButton2.selected = NO;
        _bodyButton3.selected = NO;
        _bodyButton4.selected = YES;
        _bodyButton5.selected = NO;
        _bodyButton6.selected = NO;
        _bodyButton7.selected = NO;
        _bodyButton8.selected = NO;
    }
}
- (IBAction)bodyButton5Click:(id)sender {
    if (!_bodyButton5.selected) {
        _userBody = 5;
        _bodyButton1.selected = NO;
        _bodyButton2.selected = NO;
        _bodyButton3.selected = NO;
        _bodyButton4.selected = NO;
        _bodyButton5.selected = YES;
        _bodyButton6.selected = NO;
        _bodyButton7.selected = NO;
        _bodyButton8.selected = NO;
    }
}
- (IBAction)bodyButton6Click:(id)sender {
    if (!_bodyButton6.selected) {
        _userBody = 6;
        _bodyButton1.selected = NO;
        _bodyButton2.selected = NO;
        _bodyButton3.selected = NO;
        _bodyButton4.selected = NO;
        _bodyButton5.selected = NO;
        _bodyButton6.selected = YES;
        _bodyButton7.selected = NO;
        _bodyButton8.selected = NO;
    }
}
- (IBAction)bodyButton7Click:(id)sender {
    if (!_bodyButton7.selected) {
        _userBody = 7;
        _bodyButton1.selected = NO;
        _bodyButton2.selected = NO;
        _bodyButton3.selected = NO;
        _bodyButton4.selected = NO;
        _bodyButton5.selected = NO;
        _bodyButton6.selected = NO;
        _bodyButton7.selected = YES;
        _bodyButton8.selected = NO;
    }
}
- (IBAction)bodyButton8Click:(id)sender {
    if (!_bodyButton8.selected) {
        _userBody = 8;
        _bodyButton1.selected = NO;
        _bodyButton2.selected = NO;
        _bodyButton3.selected = NO;
        _bodyButton4.selected = NO;
        _bodyButton5.selected = NO;
        _bodyButton6.selected = NO;
        _bodyButton7.selected = NO;
        _bodyButton8.selected = YES;
    }
}
- (IBAction)trainingButton1Click:(id)sender {
    _userTrainingTime = 1;
    _trainingTimeButton1.selected = YES;
    _trainingTimeButton2.selected = NO;
    _trainingTimeButton3.selected = NO;
    _trainingTimeButton1.backgroundColor = kButtonSelectedColor;
    _trainingTimeButton2.backgroundColor = [UIColor whiteColor];
    _trainingTimeButton3.backgroundColor = [UIColor whiteColor];
}
- (IBAction)trainingButton2Click:(id)sender {
    _userTrainingTime = 2;
    _trainingTimeButton1.selected = NO;
    _trainingTimeButton2.selected = YES;
    _trainingTimeButton3.selected = NO;
    _trainingTimeButton1.backgroundColor = [UIColor whiteColor];
    _trainingTimeButton2.backgroundColor = kButtonSelectedColor;
    _trainingTimeButton3.backgroundColor = [UIColor whiteColor];
}
- (IBAction)trainingButton3Click:(id)sender {
    _userTrainingTime = 3;
    _trainingTimeButton1.selected = NO;
    _trainingTimeButton2.selected = NO;
    _trainingTimeButton3.selected = YES;
    _trainingTimeButton1.backgroundColor = [UIColor whiteColor];
    _trainingTimeButton2.backgroundColor = [UIColor whiteColor];
    _trainingTimeButton3.backgroundColor = kButtonSelectedColor;
}
- (IBAction)submitButtonClick:(id)sender {
    if (_userHeight == 0 || _userWeight == 0) {
        [[[RBBlockAlertView alloc] initWithTitle:@"警告" message:@"记得选择身高体重哦~" block:^(NSInteger buttonIndex) {
        } cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return;
    }
    if (_userBody == 0) {
        [[[RBBlockAlertView alloc] initWithTitle:@"警告" message:@"记得选择体型哦~" block:^(NSInteger buttonIndex) {
        } cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return;
    }
    if (_selectedTagArray.count == 0) {
        [[[RBBlockAlertView alloc] initWithTitle:@"警告" message:@"至少选择一个标签哦~" block:^(NSInteger buttonIndex) {
        } cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return;
    }
    if (_userTrainingTime == 0) {
        [[[RBBlockAlertView alloc] initWithTitle:@"警告" message:@"记得选择你的运动量哦~" block:^(NSInteger buttonIndex) {
        } cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return;
    }
    
    NSMutableDictionary *tempParam = [@{@"sex" : @(_userSex),
                                        @"height" : @(_userHeight),
                                        @"weight" : @(_userWeight),
                                        @"body" : @(_userBody),
                                        @"sporttime" : @(_userTrainingTime)} mutableCopy];
    NSMutableString *mutableTagString = [NSMutableString string];
    for (NSString *tagString in _selectedTagArray) {
        [mutableTagString appendString:[NSString stringWithFormat:@"%@;", tagString]];
    }
    [mutableTagString deleteCharactersInRange:NSMakeRange(mutableTagString.length - 1, 1)];
    [tempParam setObject:mutableTagString forKey:@"tag"];
    [[NSUserDefaults standardUserDefaults] setObject:@(_userSex) forKey:UserSex];
    [[NSUserDefaults standardUserDefaults] setObject:@(_userHeight) forKey:UserHeight];
    [[NSUserDefaults standardUserDefaults] setObject:@(_userWeight) forKey:UserWeight];
    [[NSUserDefaults standardUserDefaults] setObject:@(_userBody) forKey:UserBody];
    [[NSUserDefaults standardUserDefaults] setObject:@(_userTrainingTime) forKey:UserTrainingTime];
    [[NSUserDefaults standardUserDefaults] setObject:mutableTagString forKey:UserTag];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [UserInfoModel submitInformationWith:tempParam handler:^(id object, NSString *msg) {
        if (!msg) {
            LimitResultModel *model = [LimitResultModel new];
            model = object;
            _courseArray = [model.result mutableCopy];
            ForthGuideViewController *forthGuideView = [[UIStoryboard storyboardWithName:@"Guide" bundle:nil] instantiateViewControllerWithIdentifier:@"ForthGuideView"];
            forthGuideView.recommendedCourseArray = _courseArray;
            [self.navigationController pushViewController:forthGuideView animated:YES];
        }
    }];
}

@end
