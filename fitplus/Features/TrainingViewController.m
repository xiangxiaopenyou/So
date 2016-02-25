//
//  TrainingViewController.m
//  fitplus
//
//  Created by xlp on 15/8/31.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "TrainingViewController.h"
#import "PlayerView.h"
#import "CommonsDefines.h"
#import <MBProgressHUD.h>

#define SELECTCOLOR [UIColor colorWithRed:87 / 255.0 green:172 / 255.0 blue:184 / 255.0 alpha:1]
#define NOSELECTCOLOR [UIColor colorWithRed:184 / 255.0 green:184 / 255.0 blue:184 / 255.0 alpha:1]

@interface TrainingViewController ()<UIScrollViewDelegate, AVAudioPlayerDelegate>
@property (strong, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *videoNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *actionNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentActionLabel;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;
@property (strong, nonatomic) AVAudioPlayer *backwardsPlayer;
@property (strong, nonatomic) AVAudioPlayer *countPlayer;
@property (strong, nonatomic) NSTimer *backwardsTimer;
@property (assign, nonatomic) NSInteger currentIndex;
@property (assign, nonatomic) NSInteger currentActionIndex;
@property (assign, nonatomic) BOOL isStartCount;
@end

@implementation TrainingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _startButton.layer.masksToBounds = YES;
    _startButton.layer.cornerRadius = 36.0;
    _pauseButton.layer.masksToBounds = YES;
    _pauseButton.layer.cornerRadius = 36.0;
    
    _videoNumberLabel.text = [NSString stringWithFormat:@"1/%lu", (unsigned long)_videoArray.count];

    _currentIndex = 0;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.bounces = NO;
    [_contentView addSubview:_scrollView];
    for (int i = 0; i < _videoArray.count; i ++) {
        PlayerView *playerView = [[PlayerView alloc] initWithFrame:CGRectMake(i * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_WIDTH) Url:_videoArray[i][@"video"]];
        [playerView replaceCurrentItemWithUrl:_videoArray[i][@"video"]];
        [_scrollView addSubview:playerView];
    }
    _scrollView.contentSize = CGSizeMake(_videoArray.count * SCREEN_WIDTH, 0);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self returnStart];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)startButtonClick:(id)sender {
    _currentActionLabel.textColor = SELECTCOLOR;
    if (_startButton.selected) {
        [self returnStart];
    } else {
        _startButton.selected = YES;
        NSURL *fileUrl = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"count_backwards" ofType:@"mp3"]];
        _backwardsPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:nil];
        _backwardsPlayer.delegate = self;
        [_backwardsPlayer prepareToPlay];
        [_backwardsPlayer play];
        //[self performSelector:@selector(timeStart) withObject:nil afterDelay:3.0];
    }
}
- (IBAction)pauseButtonClick:(id)sender {
    if (_isStartCount) {
        if (_pauseButton.selected) {
            _pauseButton.selected = NO;
            NSInteger perTime = [_videoArray[_currentIndex][@"preTime"] integerValue];
            _backwardsTimer = [NSTimer scheduledTimerWithTimeInterval:perTime target:self selector:@selector(timeStart) userInfo:nil repeats:YES];
            _currentActionLabel.textColor = SELECTCOLOR;
        } else {
            _pauseButton.selected = YES;
            [_backwardsTimer invalidate];
            _backwardsTimer = nil;
            _currentActionLabel.textColor = NOSELECTCOLOR;
        }
    } else {
        return;
    }
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _currentIndex = floor(scrollView.contentOffset.x) / SCREEN_WIDTH;
    _videoNumberLabel.text = [NSString stringWithFormat:@"%ld/%lu", (long)_currentIndex + 1, (unsigned long)_videoArray.count];
    [self returnStart];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PlayerViewScroll" object:@YES];
}

#pragma mark - AVAudioPlayer Delegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (player == _backwardsPlayer) {
        NSInteger perTime = [_videoArray[_currentIndex][@"preTime"] integerValue];
        _backwardsTimer = [NSTimer scheduledTimerWithTimeInterval:perTime target:self selector:@selector(timeStart) userInfo:nil repeats:YES];
        _isStartCount = YES;
    }
    [player stop];
    player = nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)returnStart {
    [_backwardsPlayer stop];
    _backwardsPlayer = nil;
    _currentActionIndex = 0;
    _currentActionLabel.text = @"0";
    _actionNumberLabel.text = [NSString stringWithFormat:@"/%@", _videoArray[_currentIndex][@"groupSum"]];
    _startButton.selected = NO;
    _pauseButton.selected = NO;
    _isStartCount = NO;
    [_backwardsTimer invalidate];
    _backwardsTimer = nil;
}
- (void)timeStart {
    _currentActionIndex ++;
    _currentActionLabel.text = @(_currentActionIndex).stringValue;
    NSURL *fileUrl = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle]  pathForResource:[NSString stringWithFormat:@"%ld", (long)_currentActionIndex] ofType:@"mp3"]];
    [self setupPlayer:fileUrl];
    if (_currentActionIndex >= [_videoArray[_currentIndex][@"groupSum"] integerValue]) {
        [_backwardsTimer invalidate];
        _backwardsTimer = nil;
        [self performSelector:@selector(endPlayer) withObject:nil afterDelay:1.5];
    }
}
- (void)setupPlayer:(NSURL *)url {
    _countPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    _countPlayer.delegate = self;
    [_countPlayer prepareToPlay];
    [_countPlayer play];
}
- (void)endPlayer {
    [self returnStart];
    NSURL *fileUrl = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle]  pathForResource:@"ding" ofType:@"mp3"]];
    [self setupPlayer:fileUrl];
}

@end
