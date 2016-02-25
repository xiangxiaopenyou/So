//
//  CourseTrainingViewController.m
//  fitplus
//
//  Created by xlp on 15/10/8.
//  Copyright © 2015年 realtech. All rights reserved.
//

#import "CourseTrainingViewController.h"
#import "CircleProgressView.h"
#import "VideoModel.h"
#import <AVFoundation/AVFoundation.h>
#import "Util.h"
#import <UIImageView+AFNetworking.h>
#import "TipCloseView.h"
#import "RBBlockAlertView.h"
#import "CourseModel.h"
#import "FinishCourseTipView.h"
#import <MBProgressHUD.h>
#import "InformationModel.h"
#import <ShareSDK/ShareSDK.h>
#import "DownloadVideo.h"

@interface CourseTrainingViewController ()<AVAudioPlayerDelegate>
@property (weak, nonatomic) IBOutlet UIView *viewOfPlayer;
@property (weak, nonatomic) IBOutlet UILabel *actionNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *actionTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *allActionTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *currenProgressView;
@property (weak, nonatomic) IBOutlet CircleProgressView *circleProgressView;
@property (weak, nonatomic) IBOutlet UILabel *actionProgressLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *currentProgressWidthConstraint;
@property (weak, nonatomic) IBOutlet UIView *pauseView;
@property (weak, nonatomic) IBOutlet UIImageView *pauseImage;
@property (weak, nonatomic) IBOutlet UILabel *pauseTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *pauseLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *pauseBodyLabel;
@property (weak, nonatomic) IBOutlet UILabel *pauseKeyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *restImage;
@property (weak, nonatomic) IBOutlet UILabel *restTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *restLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *restBodyLabel;
@property (weak, nonatomic) IBOutlet UILabel *restKeyLabel;
@property (weak, nonatomic) IBOutlet UIView *restView;
@property (weak, nonatomic) IBOutlet UILabel *restBackcountLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *finishViewTopConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rankImageView;
@property (weak, nonatomic) IBOutlet UILabel *energyLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *difficultyLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *actionNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIButton *showButton;
@property (assign, nonatomic) NSInteger nowGroup;
@property (assign, nonatomic) NSInteger currentGroupNum;
@property (assign, nonatomic) NSInteger currentTime;
@property (assign, nonatomic) NSInteger allPregressTime;
@property (assign, nonatomic) NSInteger allActionCurrentTime;
@property (assign, nonatomic) NSInteger counterNumber;
@property (strong, nonatomic) NSMutableArray *actionArray;
@property (assign, nonatomic) NSInteger currentAction;
@property (strong, nonatomic) NSTimer *circleProgressTimer;
@property (strong, nonatomic) NSTimer *counterTimer;
@property (strong, nonatomic) NSTimer *restCounterTimer;
@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerItem *playerItem;
@property (copy, nonatomic) NSString *playerUrl;
@property (assign, nonatomic) NSInteger restCountNumber;
@property (assign, nonatomic) NSInteger selectedDifficulty;
@property (strong, nonatomic) InformationModel *userInformation;

@property (strong, nonatomic) AVAudioPlayer *actionAudioPlayer;
@property (strong, nonatomic) AVAudioPlayer *actionNameAudioPlayer;
@property (strong, nonatomic) AVAudioPlayer *togetherGroupsAudioPlayer;
@property (strong, nonatomic) AVAudioPlayer *timesAudioPlayer;
@property (strong, nonatomic) AVAudioPlayer *firstGroupAudioPlayer;
@property (strong, nonatomic) AVAudioPlayer *backwardsAudioPlayer;
@property (strong, nonatomic) AVAudioPlayer *nextOrLastGroupAudioPlayer;
@property (strong, nonatomic) AVAudioPlayer *countNumberAudioPlayer;
@property (strong, nonatomic) AVAudioPlayer *restAudioPlayer;
@property (strong, nonatomic) AVAudioPlayer *backgroundMusicPlayer;
@property (strong, nonatomic) AVAudioPlayer *finishAudioPlayer;

@end

@implementation CourseTrainingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishedShare) name:@"FinishShare" object:nil];
    _playerUrl = @"";
    _playerItem = [self getPlayerItem:_playerUrl];
    _player = [AVPlayer playerWithPlayerItem:_playerItem];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    playerLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 180);
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [_viewOfPlayer.layer addSublayer:playerLayer];
    
    
    if (_progressView.layer.cornerRadius != 4.0) {
        _progressView.layer.masksToBounds = YES;
        _progressView.layer.cornerRadius = 4.0;
    }
    if (_currenProgressView.layer.cornerRadius != 4.0) {
        _currenProgressView.layer.masksToBounds = YES;
        _currenProgressView.layer.cornerRadius = 4.0;
    }
    [_restView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(restViewGR)]];
    _restView.userInteractionEnabled = YES;
    
    _actionArray = _actionDictionary[@"resolve_list"];
    _nowGroup = 0;
    _currentAction = 0;
    _allActionCurrentTime = 0;
    _allPregressTime = 0;
    
    [self setupVideoView];
    [self setupPauseView];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    for (VideoModel *tempModel in _videoArray) {
        [self downloadAudioFile:tempModel];
    }
    [self setupCounterTimer];
}
-  (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    _player = nil;
    [self clear];
}
- (void)setupCounterTimer {
    [_backgroundMusicPlayer stop];
    _backgroundMusicPlayer = nil;
    [_counterTimer invalidate];
    _currentGroupNum = 0;
    _counterNumber = 5;
    _actionProgressLabel.font = [UIFont systemFontOfSize:25];
    _actionProgressLabel.text = [NSString stringWithFormat:@"%ld", (long)_counterNumber];
    VideoModel *model = _videoArray[_currentAction];
    NSURL *fileUrl;
    NSInteger delayTime = 7;
    if (_currentAction == 0) {
        //第一个动作
        if (_nowGroup == 0) {
            delayTime = 7;
            fileUrl = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"first_action" ofType:@"mp3"]];
            _actionAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:nil];
            _actionAudioPlayer.delegate = self;
            //[_actionAudioPlayer prepareToPlay];
            [_actionAudioPlayer play];
        } else {
            delayTime = 2;
            if (_nowGroup == model.num - 1) {
                //最后一组
                fileUrl = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"last_group" ofType:@"mp3"]];
            } else {
                //下一组
                fileUrl = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"next_group" ofType:@"mp3"]];
            }
            _nextOrLastGroupAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:nil];
            _nextOrLastGroupAudioPlayer.delegate = self;
            [_nextOrLastGroupAudioPlayer play];
        }
    } else if (_currentAction == _videoArray.count - 1) {
        //最后一个动作
        if (_nowGroup == 0) {
            delayTime = 7;
            fileUrl = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"last_action" ofType:@"mp3"]];
            _actionAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:nil];
            _actionAudioPlayer.delegate = self;
            //[_actionAudioPlayer prepareToPlay];
            [_actionAudioPlayer play];
        } else {
            delayTime = 2;
            if (_nowGroup == model.num - 1) {
                //最后一组
                fileUrl = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"last_group" ofType:@"mp3"]];
            } else {
                //下一组
                fileUrl = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"next_group" ofType:@"mp3"]];
            }
            _nextOrLastGroupAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:nil];
            [_nextOrLastGroupAudioPlayer play];
            
        }
    } else {
        if (_nowGroup == 0) {
            delayTime = 7;
            fileUrl = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"next_action" ofType:@"mp3"]];
            _actionAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:nil];
            _actionAudioPlayer.delegate = self;
            //[_actionAudioPlayer prepareToPlay];
            [_actionAudioPlayer play];
        } else {
            delayTime = 2;
            if (_nowGroup == model.num - 1) {
                //最后一组
                fileUrl = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"last_group" ofType:@"mp3"]];
            } else {
                //下一组
                fileUrl = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"next_group" ofType:@"mp3"]];
            }
            _nextOrLastGroupAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:nil];
            _nextOrLastGroupAudioPlayer.delegate = self;
            [_nextOrLastGroupAudioPlayer play];
        }
    }
    _counterTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countBeforeStart) userInfo:nil repeats:YES];
    [_counterTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:delayTime]];
}
- (void)countBeforeStart {
    if (_counterNumber == 5) {
        NSURL *fileUrl = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"count_backwards_new" ofType:@"mp3"]];
        _backwardsAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:nil];
        _backwardsAudioPlayer.delegate = self;
        [_backwardsAudioPlayer play];
    }
    _actionProgressLabel.text = [NSString stringWithFormat:@"%ld", (long)_counterNumber];
    if (_counterNumber > 0) {
        _counterNumber -= 1;
    } else {
        [_counterTimer invalidate];
        _counterTimer = nil;
        [self setupCurrentGroup];
        [self circleProgress];
    }
}

- (void)circleProgress {
    _currentTime = 0;
    [_playerItem seekToTime:kCMTimeZero];
    [_player play];
    [self setBackgroundAudioPlayer];
    _circleProgressTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateCircleAction) userInfo:nil repeats:YES];
}
- (void)updateCircleAction {
    _currentTime += 1;
    _allActionCurrentTime += 1;
    _allPregressTime += 1;
    VideoModel *tempModel = _videoArray[_currentAction];
    NSInteger duration = 1;
    if (tempModel.type == 1) {
        duration = tempModel.duration;
    } else {
        duration = 1;
    }
    CGFloat progressF = (float)(_currentTime + 1) / (float)(tempModel.group_num * duration);
    [_circleProgressView updateProgressCircle:progressF];
    _actionTimeLabel.text = [self changeTimeString:_currentTime];
    _allActionTimeLabel.text = [self changeTimeString:_allPregressTime];
    CGFloat totalTime = [_actionDictionary[@"total_time"] floatValue];
    _currentProgressWidthConstraint.constant = (SCREEN_WIDTH - 28) / totalTime * _allActionCurrentTime;
    [UIView animateWithDuration:1.0 animations:^{
        [self.view layoutIfNeeded];
    }];
    
    if (_currentTime % duration == 0) {
        _currentGroupNum += 1;
        if (_currentGroupNum == tempModel.group_num) {
            [_circleProgressTimer invalidate];
            if (_currentAction != (_actionArray.count - 1)) {
                NSLog(@"不是最后一个动作");
                //_pauseView.hidden = NO;
                [self clear];
                _restCountNumber = [tempModel.intervals integerValue];
                _restView.hidden = NO;
                _restCounterTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(restcounterSelector) userInfo:nil repeats:YES];
                [self setRestAudioPlayer];
                if (_nowGroup == tempModel.num - 1) {
                    //最后一组
                    [self setupRestView];
                    _currentAction += 1;
                    [self endOfOneAction];
                    _nowGroup = 0;
                } else {
                    [self setupRestView];
                    [self endOfOneAction];
                    _nowGroup += 1;
                
                }
            } else {
                NSLog(@"最后一个动作");
                [self clear];
                if (_nowGroup == tempModel.num - 1) {
                    //最后一个动作的最后一组
                    [_player pause];
                    [self setFinishCourseAudioPlayer];
                    [self showFinishCourseTip];
                } else {
                    //最后一个动作，非最后一组
                    [self setRestAudioPlayer];
                    _restCountNumber = [tempModel.intervals integerValue];
                    [self setupRestView];
                    [self endOfOneAction];
                    _restView.hidden = NO;
                    _restCounterTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(restcounterSelector) userInfo:nil repeats:YES];
                    _nowGroup += 1;
                    
                }
            }
            
        } else {
            [self setupCurrentGroup];
        }
        
    }
    
}
- (void)restcounterSelector {
    _restBackcountLabel.text = [NSString stringWithFormat:@"%ld", (long)_restCountNumber];
    if (_restCountNumber == 0) {
        [_restCounterTimer invalidate];
        _restCounterTimer = nil;
        _restView.hidden = YES;
        [self setupCounterTimer];
    } else {
        _restCountNumber --;
    }
}

- (void)setupCurrentGroup {
    VideoModel *model = _videoArray[_currentAction];
    if (model.type == 1) {
        NSURL *fileUrl;
        if (_currentGroupNum == 3) {
            fileUrl = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"keep_abdo" ofType:@"mp3"]];
        } else if (_currentGroupNum == 7) {
            fileUrl = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"attention_breathing" ofType:@"mp3"]];
        } else if (_currentGroupNum == model.group_num - 2) {
            fileUrl = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"remaining_two_times" ofType:@"mp3"]];
        } else if (_currentGroupNum == model.group_num - 1) {
            fileUrl = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"last_times" ofType:@"mp3"]];
        } else {
            fileUrl = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%ld", (long)_currentGroupNum + 1] ofType:@"mp3"]];
        }
        _countNumberAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:nil];
        _countNumberAudioPlayer.delegate = self;
        [_countNumberAudioPlayer prepareToPlay];
        [_countNumberAudioPlayer play];
    } else {
        NSURL *fileUrl;
        if ((_currentGroupNum + 1) % 5 == 0) {
            fileUrl = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"second%ld", (long)_currentGroupNum + 1] ofType:@"mp3"]];
            _countNumberAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:nil];
            _countNumberAudioPlayer.delegate = self;
            [_countNumberAudioPlayer prepareToPlay];
            [_countNumberAudioPlayer play];
        }
    }
    
    _actionProgressLabel.font = [UIFont systemFontOfSize:18];
    NSString *string = [NSString stringWithFormat:@"%ld", (long)_currentGroupNum + 1];
    NSString *groupString = [NSString stringWithFormat:@"%@/%ld", string, (long)model.group_num];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:groupString];
    [attributedString addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:25], NSFontAttributeName, [UIColor colorWithRed:87/255.0 green:172/255.0 blue:184/255.0 alpha:1.0], NSForegroundColorAttributeName, nil] range:NSMakeRange(0, [string length])];
    _actionProgressLabel.attributedText = attributedString;
}
- (void)setupVideoView {
    NSString *cachePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private/Documents/Cache"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    VideoModel *tempModel = _videoArray[_currentAction];
    _actionNameLabel.text = [NSString stringWithFormat:@"%ld %@", (long)_currentAction + 1, tempModel.video_name];
    if (![fileManager fileExistsAtPath:[cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4", tempModel.id]]]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadVideoSuccess:) name:@"DownloadSuccess" object:nil];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[DownloadVideo new] downloadFileURL:tempModel.path fileName:[NSString stringWithFormat:@"%@.mp4", tempModel.id] tag:[tempModel.id integerValue]];
    } else {
        [self replaceCurrentItemWithUrl:[cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4", tempModel.id]]];
        [_player play];
    }
}
- (void)downloadVideoSuccess:(NSNotification *)notification {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSString *cachePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private/Documents/Cache"];
    VideoModel *tempModel = _videoArray[_currentAction];
    [self replaceCurrentItemWithUrl:[cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4", tempModel.id]]];
    [_player play];
}

- (AVPlayerItem *)getPlayerItem:(NSString *)urlString {
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:urlString]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:item];
    return item;
}
- (void)playFinished:(NSNotification *)notification {
    NSLog(@"播放完成");
    AVPlayerItem *item = [notification object];
    [item seekToTime:kCMTimeZero];
    [_player play];
}
//替换播放地址
- (void)replaceCurrentItemWithUrl:(NSString*)urlString{
    if (urlString) {
        [_player replaceCurrentItemWithPlayerItem:[self getPlayerItem:urlString]];
    }
}
- (void)setupPauseView {
    VideoModel *tempModel = _videoArray[_currentAction];
    [_pauseImage setImageWithURL:[NSURL URLWithString:[Util urlPhoto:tempModel.picurl]] placeholderImage:[UIImage imageNamed:@"default_image"]];
    _pauseTitleLabel.text = tempModel.video_name;
    switch (_courseModel.courseModel) {
        case 1:{
            _pauseLevelLabel.text = @"初级";
        }
            break;
        case 2:{
            _pauseLevelLabel.text = @"中级";
        }
            break;
        case 3:{
            _pauseLevelLabel.text = @"高级";
        }
            break;
            
        default:
            break;
    }
    _pauseBodyLabel.text = [NSString stringWithFormat:@"%@", _courseModel.courseBody];
    _pauseKeyLabel.text = tempModel.content;
}
- (void)setupRestView {
    VideoModel *tempModel = _videoArray[_currentAction];
    VideoModel *nextModel;
    if (_nowGroup == tempModel.num - 1) {
        nextModel = _videoArray[_currentAction + 1];
    } else {
        nextModel = _videoArray[_currentAction];
    }
    [_restImage setImageWithURL:[NSURL URLWithString:[Util urlPhoto:nextModel.picurl]] placeholderImage:[UIImage imageNamed:@"default_image"]];
    _restTitleLabel.text = nextModel.video_name;
    switch (_courseModel.courseModel) {
        case 1:{
            _pauseLevelLabel.text = @"初级";
        }
            break;
        case 2:{
            _pauseLevelLabel.text = @"中级";
        }
            break;
        case 3:{
            _pauseLevelLabel.text = @"高级";
        }
            break;
            
        default:
            break;
    }
    _restBodyLabel.text = [NSString stringWithFormat:@"%@", _courseModel.courseBody];
    _restKeyLabel.text = nextModel.content;
    _restBackcountLabel.text = [NSString stringWithFormat:@"%ld", (long)_restCountNumber];
}
- (NSString *)changeTimeString:(NSInteger)time {
    NSInteger second = time % 60;
    NSInteger minute = time / 60;
    if (time < 60) {
        return [NSString stringWithFormat:@"00:%02ld", (long)time];
    } else {
        return [NSString stringWithFormat:@"%02ld:%02ld", (long)minute, (long)second];
    }
}

/*
 训练结束展示
 */
- (void)showFinishCourseTip {
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [backView setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.5]];
    [self.view addSubview:backView];
    FinishCourseTipView *tipView = [[FinishCourseTipView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 135, SCREEN_HEIGHT / 2 - 110, 270, 206) clickBlock:^(NSInteger index) {
        //_currentAction = 0;
        _selectedDifficulty = index;
        [self setupFinishView];
        [backView removeFromSuperview];
    }];
    [backView addSubview:tipView];
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
#pragma mark - AVAudioPlayer Delegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (player == _actionAudioPlayer) {
        VideoModel *tempModel = _videoArray[_currentAction];
        NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSURL *fileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@.mp3", docDirPath, tempModel.id]];
        _actionNameAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:nil];
        _actionNameAudioPlayer.delegate = self;
        [_actionNameAudioPlayer prepareToPlay];
        [_actionNameAudioPlayer play];
        
    }
    if (player == _actionNameAudioPlayer) {
        VideoModel *tempModel = _videoArray[_currentAction];
        NSString *groupNumString = nil;
        if (tempModel.num == 1) {
            groupNumString = @"altogether_one_group";
        } else if (tempModel.num == 2) {
            groupNumString = @"altogether_two_group";
        } else {
            groupNumString = @"altogether_three_group";
        }
        NSURL *fileUrl = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:groupNumString ofType:@"mp3"]];
        _togetherGroupsAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:nil];
        _togetherGroupsAudioPlayer.delegate = self;
        [_togetherGroupsAudioPlayer prepareToPlay];
        [_togetherGroupsAudioPlayer play];
    }
    if (player == _togetherGroupsAudioPlayer) {
        VideoModel *tempModel = _videoArray[_currentAction];
        NSString *timesString = nil;
        if (tempModel.type == 1) {
            if (tempModel.group_num == 10) {
                timesString = @"10times_per_group";
            } else if(tempModel.group_num == 12) {
                timesString = @"12times_per_group";
            } else {
                timesString = @"15times_per_group";
            }
        } else {
            if (tempModel.group_num == 30) {
                timesString = @"30second_per_group";
            } else if(tempModel.group_num == 45) {
                timesString = @"45second_per_group";
            } else {
                timesString = @"60second_per_group";
            }
        }
        NSURL *fileUrl = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:timesString ofType:@"mp3"]];
        _timesAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:nil];
        _timesAudioPlayer.delegate = self;
        [_timesAudioPlayer prepareToPlay];
        [_timesAudioPlayer play];
    }
    if (player == _timesAudioPlayer) {
        NSURL *fileUrl = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"first_group" ofType:@"mp3"]];
        _firstGroupAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:nil];
        _firstGroupAudioPlayer.delegate = self;
        [_firstGroupAudioPlayer prepareToPlay];
        [_firstGroupAudioPlayer play];
    }
    if (player == _backgroundMusicPlayer) {
        [self setBackgroundAudioPlayer];
    }
    [player stop];
    player = nil;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"finishedShare" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DownloadSuccess" object:nil];
}
- (void)endOfOneAction {
    _actionTimeLabel.text = @"00:00";
    [_circleProgressView updateProgressCircle:0];
    [_circleProgressTimer invalidate];
    [self setupVideoView];
    [self setupPauseView];
}

/*
 完成训练View
 */
- (void)setupFinishView {
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = 18.0;
    _difficultyLabel.layer.masksToBounds = YES;
    _difficultyLabel.layer.cornerRadius = 9.0;
    switch (_selectedDifficulty) {
        case 1:
            _difficultyLabel.text = @"轻松";
            break;
        case 2:
            _difficultyLabel.text = @"一般";
            break;
        case 3:
            _difficultyLabel.text = @"较难";
            break;
        case 4:
            _difficultyLabel.text = @"困难";
            break;
        default:
            break;
    }
    _showButton.layer.masksToBounds = YES;
    _showButton.layer.cornerRadius = 9.0;
    _courseNameLabel.text = [NSString stringWithFormat:@"%@", _courseModel.courseName];
    _courseDayLabel.text = [NSString stringWithFormat:@"第%@天", _actionDictionary[@"day_name"]];
    _energyLabel.text = [NSString stringWithFormat:@"%@", _actionDictionary[@"calories"]];
    _scoreLabel.text = [NSString stringWithFormat:@"%@", _actionDictionary[@"calories"]];
    NSInteger timeInt = _allPregressTime / 60 + 1;
    NSString *timeString = [NSString stringWithFormat:@"%ld", (long)timeInt];
    NSString *string = [NSString stringWithFormat:@"%@分钟", timeString];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:string];
    [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, [timeString length])];
    _timeLabel.attributedText = attString;
    NSArray *tempArray = [_actionDictionary[@"resolve_list"] copy];
    NSInteger actionInt = tempArray.count;
    NSString *actionString = [NSString stringWithFormat:@"%ld", (long)actionInt];
    NSString *string_action = [NSString stringWithFormat:@"%@个", actionString];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string_action];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, [actionString length])];
    _actionNumberLabel.attributedText = attrString;
    
    //NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:UserIdKey];
    [InformationModel getInfoMassggeWithFrendid:nil handler:^(id object, NSString *msg) {
        if (!msg) {
            _userInformation = object;
            [_headImageView setImageWithURL:[NSURL URLWithString:[Util urlZoomPhoto:_userInformation.portrait]] placeholderImage:[UIImage imageNamed:@"default_headportrait"]];
        }
    }];
    _finishViewTopConstraint.constant = - SCREEN_HEIGHT + 35;
    [UIView animateWithDuration:0.3 delay:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
    [self finishDayCourseRequest];
}

/*
 完成训练接口
 */
- (void)finishDayCourseRequest {
    NSMutableDictionary *param = [@{@"courseId" : _courseModel.courseId,
                                    @"courseDayId" : _actionDictionary[@"day_id"],
                                    @"courseDay" : _actionDictionary[@"day_name"],
                                    @"calorie" : _actionDictionary[@"calories"],
                                    @"courseName" : _courseModel.courseName,
                                    @"difficulty" : @(_selectedDifficulty),
                                    @"period" : @(_allPregressTime)} mutableCopy];
    [CourseModel finishDayCourse:param handler:^(id object, NSString *msg) {
        if (msg) {
            NSLog(@"完成课程失败");
        } else {
            NSLog(@"完成课程");
        }
    }];
}

/*
 退出训练按钮
 */
- (IBAction)closeButtonClick:(id)sender {
    [_circleProgressTimer invalidate];
    [_player pause];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [backView setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.5]];
    [self.view addSubview:backView];
    
    NSString *titleString = @"训练还没结束，结果将不会保存，确定要退出吗？";
    TipCloseView *tipView = [[TipCloseView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 135, SCREEN_HEIGHT / 2 - 90, 270, 165) clickBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            _circleProgressTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateCircleAction) userInfo:nil repeats:YES];
            [_player play];
            [backView removeFromSuperview];
        }
    } title:titleString closeButtonTitle:@"退出训练" continueButtonTitle:@"再练一会儿"];
    [backView addSubview:tipView];
    
}
- (IBAction)nextButtonClick:(id)sender {
    if (_currentAction != _actionArray.count - 1) {
        [self clear];
        VideoModel *tempModel = _videoArray[_currentAction];
        NSInteger duration = 1;
        if (tempModel.type == 1) {
            duration = tempModel.duration;
        } else {
            duration = 1;
        }
        _allActionCurrentTime += duration * tempModel.group_num * (tempModel.num - _nowGroup) - _currentTime;
        CGFloat totalTime = [_actionDictionary[@"total_time"] floatValue];
        _currentProgressWidthConstraint.constant = (SCREEN_WIDTH - 28) / totalTime * _allActionCurrentTime;
        _currenProgressView.layer.masksToBounds = YES;
        _currenProgressView.layer.cornerRadius = 4.0;
        [UIView animateWithDuration:1.0 animations:^{
            [self.view layoutIfNeeded];
        }];
        [self setupRestView];
        _currentAction += 1;
        _currentTime = 0;
        _nowGroup = 0;
        [self endOfOneAction];
        [self setupCounterTimer];
    }
}
- (IBAction)lastButtonClick:(id)sender {
    if (_currentAction != 0) {
        [self clear];
        VideoModel *tempModel = _videoArray[_currentAction];
        NSInteger duration = 1;
        if (tempModel.type == 1) {
            duration = tempModel.duration;
        } else {
            duration = 1;
        }
        _currentAction -= 1;
        VideoModel *temp = _videoArray[_currentAction];
        NSInteger duration1 = 1;
        if (temp.type == 1) {
            duration1 = temp.duration;
        } else {
            duration1 = 1;
        }
        _allActionCurrentTime -= duration1 * temp.group_num * temp.num + _currentTime + duration * tempModel.group_num * _nowGroup;
        CGFloat totalTime = [_actionDictionary[@"total_time"] floatValue];
        _currentProgressWidthConstraint.constant = (SCREEN_WIDTH - 28) / totalTime * _allActionCurrentTime;
        _currenProgressView.layer.masksToBounds = YES;
        _currenProgressView.layer.cornerRadius = 4.0;
        [UIView animateWithDuration:1.0 animations:^{
            [self.view layoutIfNeeded];
        }];
        _currentTime = 0;
        _nowGroup = 0;
        [self setupRestView];
        [self endOfOneAction];
        [self setupCounterTimer];
        
    }
}
- (IBAction)pauseButtonClick:(id)sender {
    [_player pause];
    _pauseView.hidden = NO;
    if (_currentTime > 0) {
        [_circleProgressTimer invalidate];
        _circleProgressTimer = nil;
    } else {
        [self clear];
        
    }
    
}
- (IBAction)startButtonClick:(id)sender {
    [_player play];
    _pauseView.hidden = YES;
    if (_currentTime > 0) {
        _circleProgressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateCircleAction) userInfo:nil repeats:YES];
    } else {
        if (_counterNumber == 5) {
            [self setupCounterTimer];
        } else {
            _counterNumber = 5;
            _counterTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countBeforeStart) userInfo:nil repeats:YES];
        }
    }
    
}
- (IBAction)showButtonClick:(id)sender {
    UIImage *shareImage = _headImageView.image;
    if ([Util isEmpty:_userInformation.portrait]) {
        shareImage = [UIImage imageNamed:@"share_default"];
    } else {
        shareImage = _headImageView.image;
    }
    NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:UserIdKey];
    NSString *difficultyString = @"";
    switch (_selectedDifficulty) {
        case 1:
            difficultyString = @"简单";
            break;
        case 2:
            difficultyString = @"一般";
            break;
        case 3:
            difficultyString = @"较难";
            break;
        case 4:
            difficultyString = @"困难";
            break;
        default:
            break;
    }
    NSString *shareUrl = [NSString stringWithFormat:@"%@/subject_id/%@/userid/%@/day_id/%@/difficulty/%@/resolve_name/%@", CourseShareUrl, _courseModel.courseId, userid, _actionDictionary[@"day_id"], difficultyString, _actionDictionary[@"resolve_name"]];
    NSString *shareContent = [NSString stringWithFormat:@"%@刚完成了%@第%@天挑战，太棒了！你也一起加入吧！", _userInformation.nickname, _courseModel.courseName, _actionDictionary[@"day_name"]];
    id<ISSContent> publishContent = [ShareSDK content:@"健身坊，让健身更简单~"
                                       defaultContent:@"一起健身吧"
                                                image:[ShareSDK pngImageWithImage:shareImage]
                                                title:shareContent
                                                  url:shareUrl
                                          description:shareContent
                                            mediaType:SSPublishContentMediaTypeNews];
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    //    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    
    NSArray *shareList = [ShareSDK getShareListWithType: /*ShareTypeSinaWeibo, ShareTypeQQSpace, ShareTypeQQ,*/ ShareTypeWeixiSession, ShareTypeWeixiTimeline,nil];
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess) {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                    [self closeFinishViewButtonClick:nil];
                                } else if (state == SSResponseStateFail) {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                }
                            }];
}
- (IBAction)closeFinishViewButtonClick:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FinishShare" object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)restViewGR {
    [_restCounterTimer invalidate];
    _restCounterTimer = nil;
    _restView.hidden = YES;
    [self setupCounterTimer];
}
- (void)downloadAudioFile:(VideoModel *)model {
    NSString *urlString = [NSString stringWithFormat:@"%@", model.voice];
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *audioData = [NSData dataWithContentsOfURL:url];
    
    NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.mp3", docDirPath, model.id];
    [audioData writeToFile:filePath atomically:YES];
}
- (void)setRestAudioPlayer {
    NSURL *restUrl = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"rest" ofType:@"mp3"]];
    _restAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:restUrl error:nil];
    _restAudioPlayer.delegate = self;
    [_restAudioPlayer prepareToPlay];
    [_restAudioPlayer play];
}
- (void)setBackgroundAudioPlayer {
    NSURL *backUrl = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"backvideo" ofType:@"mp3"]];
    _backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backUrl error:nil];
    _backgroundMusicPlayer.delegate = self;
    [_backgroundMusicPlayer prepareToPlay];
    [_backgroundMusicPlayer play];
}
- (void)setFinishCourseAudioPlayer {
    NSURL *backUrl = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"finish_course" ofType:@"mp3"]];
    _finishAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backUrl error:nil];
    _finishAudioPlayer.delegate = self;
    [_finishAudioPlayer prepareToPlay];
    [_finishAudioPlayer play];
}
- (void)clear {
    [_actionAudioPlayer stop];
    [_actionNameAudioPlayer stop];
    [_togetherGroupsAudioPlayer stop];
    [_timesAudioPlayer stop];
    [_firstGroupAudioPlayer stop];
    [_backwardsAudioPlayer stop];
    [_nextOrLastGroupAudioPlayer stop];
    [_countNumberAudioPlayer stop];
    [_restAudioPlayer stop];
    [_backgroundMusicPlayer stop];
    _backgroundMusicPlayer = nil;
    _actionAudioPlayer = nil;
    _actionNameAudioPlayer = nil;
    _togetherGroupsAudioPlayer = nil;
    _firstGroupAudioPlayer = nil;
    _timesAudioPlayer = nil;
    _backwardsAudioPlayer = nil;
    _nextOrLastGroupAudioPlayer = nil;
    _countNumberAudioPlayer = nil;
    _restAudioPlayer = nil;
    [_circleProgressTimer invalidate];
    _circleProgressTimer = nil;
    [_counterTimer invalidate];
    _counterTimer = nil;
    [_restCounterTimer invalidate];
    _restCounterTimer = nil;
}
- (void)finishedShare {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
