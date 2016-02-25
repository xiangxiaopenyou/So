//
//  PlayerView.m
//  fitplus
//
//  Created by xlp on 15/8/6.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "PlayerView.h"
#import "Util.h"
#import "CommonsDefines.h"

@implementation PlayerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        [self setupUI];
    }
    return self;
}
//view init
- (instancetype)initWithFrame:(CGRect)frame Url:(NSString*)urlString{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewScrollSelector) name:@"PlayerViewScroll" object:nil];
        self.backgroundColor = [UIColor blackColor];
        playerUrl = [Util urlPhoto:urlString];
        [self setupUI];
        
        _isPlay = NO;
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _playButton.frame = CGRectMake(SCREEN_WIDTH/2 - 41, SCREEN_WIDTH/2 - 41, 82, 82);
        [_playButton setBackgroundImage:[UIImage imageNamed:@"button_start"] forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(playButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_playButton];
        
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGR:)]];
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
}

//添加avplayer的container
- (void)setupUI{
    AVPlayerLayer *playerLayer=[AVPlayerLayer playerLayerWithPlayer:self.player];
    playerLayer.frame= self.bounds;
    playerLayer.videoGravity=AVLayerVideoGravityResizeAspect;//视频填充模式
    [self.layer addSublayer:playerLayer];
}

//初始化player
- (AVPlayer*)player{
    if (!_player) {
        if (playerUrl == nil) {
            return _player;
        }
        self.playerItem=[self getPlayItem:playerUrl];
        _player=[AVPlayer playerWithPlayerItem:self.playerItem];
    }
    return _player;
}
- (void)playbackFinished:(NSNotification *)notification{
    NSLog(@"视频播放完成.");
    AVPlayerItem *item = [notification object];
//    [self replaceCurrentItemWithUrl:playerUrl];
//    _isPlay = NO;
//    [self pause];
//    _playButton.alpha = 1;
//    [_playButton setBackgroundImage:[UIImage imageNamed:@"button_start"] forState:UIControlStateNormal];
//    if (playerUrl != nil) {
//        [self replaceCurrentItemWithUrl:playerUrl];
//        [self play];
//    }
    [item seekToTime:kCMTimeZero];
    [self play];
}

//加载AVPlayerItem
- (AVPlayerItem *)getPlayItem:(NSString*)urlString{
    NSString *urlStr = urlString;
    urlStr =[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url=[NSURL URLWithString:urlStr];
    AVPlayerItem *playerItem=[AVPlayerItem playerItemWithURL:url];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
    return playerItem;
}

//播放
- (void)play{
    if (_player){
        [self.player play];
    }
}

//暂停
- (void)pause{
    if (_player) {
        [_player pause];
    }
}

//替换播放地址
- (void)replaceCurrentItemWithUrl:(NSString*)urlString{
    if (urlString) {
        playerUrl = [Util urlForVideo:urlString];
        [_player replaceCurrentItemWithPlayerItem:[self getPlayItem:playerUrl]];
    }
}
- (void)playButtonClick {
    if (_isPlay) {
        _isPlay = NO;
        [self pause];
        _playButton.alpha = 1;
        [_playButton setBackgroundImage:[UIImage imageNamed:@"button_start"] forState:UIControlStateNormal];
    } else {
        _isPlay = YES;
        [self play];
        [_playButton setBackgroundImage:[UIImage imageNamed:@"button_pause"] forState:UIControlStateNormal];
        [UIView animateWithDuration:1 animations:^{
            _playButton.alpha = 0;
        }];
    }
}
- (void)tapGR:(UITapGestureRecognizer *)gesture {
    _isPlay = NO;
    [self pause];
    _playButton.alpha = 1;
    [_playButton setBackgroundImage:[UIImage imageNamed:@"button_start"] forState:UIControlStateNormal];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PlayerViewScroll" object:nil];
}
- (void)viewScrollSelector {
    [self tapGR:nil];
}
@end
