//
//  VideoPreviewViewController.m
//  fitplus
//
//  Created by xlp on 15/9/30.
//  Copyright © 2015年 realtech. All rights reserved.
//

#import "VideoPreviewViewController.h"
#import "VideoModel.h"
#import <AVFoundation/AVFoundation.h>
#import "Util.h"
#import "DownloadVideo.h"
#import <MBProgressHUD.h>

@interface VideoPreviewViewController ()
@property (weak, nonatomic) IBOutlet UILabel *videoNumberLabel;
@property (weak, nonatomic) IBOutlet UIView *videoContentView;
@property (weak, nonatomic) IBOutlet UILabel *actionNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *actionDifficultyLabel;
@property (weak, nonatomic) IBOutlet UILabel *actionBodyLabel;
@property (weak, nonatomic) IBOutlet UILabel *actionKeyLabel;
@property (weak, nonatomic) IBOutlet UIButton *lastButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) NSMutableArray *videoArray;
@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerItem *playerItem;
@property (copy, nonatomic) NSString *playerUrl;

@end

@implementation VideoPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadVideoSuccess:) name:@"DownloadSuccess" object:nil];
    NSString *cachePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private/Documents/Cache"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:cachePath]) {
        [fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    switch (_model.courseDifficulty) {
        case 1:
            _actionDifficultyLabel.text = @"初级";
            break;
        case 2:
            _actionDifficultyLabel.text = @"中级";
            break;
        case 3:
            _actionDifficultyLabel.text = @"高级";
            break;
            
        default:
            break;
    }
    _actionBodyLabel.text = _model.courseBody;
    [self setupButton];
    
    _playerUrl = @"";
    _playerItem = [self getPlayerItem:_playerUrl];
    _player = [AVPlayer playerWithPlayerItem:_playerItem];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    playerLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 9 * SCREEN_WIDTH / 16);
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [_videoContentView.layer addSublayer:playerLayer];
    
    [self fetchVideoList];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}


- (void)fetchVideoList {
    [VideoModel fetchVideoListOfDay:_dayId handler:^(id object, NSString *msg) {
        _videoArray = [object mutableCopy];
        [self setupVideoContent];
    }];
}
- (void)setupVideoContent {
    _videoNumberLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)_previewIndex, (long)_actionArray.count];
    VideoModel *tempModel = _videoArray[_previewIndex - 1];
    NSString *cachePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private/Documents/Cache"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4", tempModel.id]]]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[DownloadVideo new] downloadFileURL:tempModel.path fileName:[NSString stringWithFormat:@"%@.mp4", tempModel.id] tag:[tempModel.id integerValue]];
    } else {
        [self replaceCurrentItemWithUrl:[cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4", tempModel.id]]];
        [_player play];
    }
    _actionNameLabel.text = tempModel.video_name;
    _actionKeyLabel.text = tempModel.content;
}
- (void)setupButton {
    if (_actionArray.count == 1) {
        _lastButton.hidden = YES;
        _nextButton.hidden = YES;
    } else {
        if (_previewIndex == 1) {
            _lastButton.hidden = YES;
            _nextButton.hidden = NO;
        } else if (_previewIndex == _actionArray.count) {
            _lastButton.hidden = NO;
            _nextButton.hidden = YES;
        } else {
            _lastButton.hidden = NO;
            _nextButton.hidden = NO;
        }
    }
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DownloadSuccess" object:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)downloadVideoSuccess:(NSNotification *)notification {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSString *cachePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Private/Documents/Cache"];
    VideoModel *tempModel = _videoArray[_previewIndex - 1];
    [self replaceCurrentItemWithUrl:[cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4", tempModel.id]]];
    [_player play];
}
- (IBAction)nextButtonClick:(id)sender {
    _previewIndex += 1;
    [self setupVideoContent];
    [self setupButton];
}
- (IBAction)lastButtonClick:(id)sender {
    _previewIndex -= 1;
    [self setupVideoContent];
    [self setupButton];
}
- (IBAction)closeButtonclick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
