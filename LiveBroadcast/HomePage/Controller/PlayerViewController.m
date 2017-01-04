//
//  PlayerViewController.m
//  LiveBroadcast
//
//  Created by WCM on 16/12/16.
//  Copyright © 2016年 WCM. All rights reserved.
//

#import "PlayerViewController.h"
#import <IJKMediaFramework/IJKMediaFramework.h>


@interface PlayerViewController ()

@property (atomic, strong) NSURL *url;

@property (atomic, retain) id <IJKMediaPlayback> player;

@property (weak, nonatomic) UIView *PlayerView;



@end

@implementation PlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
  self.navigationController.navigationBar.hidden = YES;
  
  //直播视频
  self.url = [NSURL URLWithString:self.liveUrl];
  _player = [[IJKFFMoviePlayerController alloc] initWithContentURL:self.url withOptions:nil];
  UIView *playerView = [self.player view];
  UIView *displayView = [[UIView alloc] initWithFrame:self.view.bounds];
  self.PlayerView = displayView;
  self.PlayerView.backgroundColor = [UIColor blackColor];
  [self.view addSubview:self.PlayerView];
  playerView.frame = self.PlayerView.bounds;
  playerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  [self.PlayerView insertSubview:playerView atIndex:1];
  [_player setScalingMode:IJKMPMovieScalingModeAspectFill];
  [self installMovieNotificationObservers];
  
  [self changeBackBtn];
}

-(void)viewWillAppear:(BOOL)animated{
  if (![self.player isPlaying]) {
    // 准备播放
    [self.player prepareToPlay];
  }
}

-(void)viewWillDisappear:(BOOL)animated{
  self.navigationController.navigationBar.hidden = NO;
}

#pragma Selector func

- (void)loadStateDidChange:(NSNotification*)notification {
  IJKMPMovieLoadState loadState = _player.loadState;
  
  if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
    NSLog(@"LoadStateDidChange: IJKMovieLoadStatePlayThroughOK: %d\n",(int)loadState);
  }else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
    NSLog(@"loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", (int)loadState);
  } else {
    NSLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
  }
}

- (void)moviePlayBackFinish:(NSNotification*)notification {
  int reason =[[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
  switch (reason) {
    case IJKMPMovieFinishReasonPlaybackEnded:
      NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackEnded: %d\n", reason);
      break;
      
    case IJKMPMovieFinishReasonUserExited:
      NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonUserExited: %d\n", reason);
      break;
      
    case IJKMPMovieFinishReasonPlaybackError:
      NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackError: %d\n", reason);
      break;
      
    default:
      NSLog(@"playbackPlayBackDidFinish: ???: %d\n", reason);
      break;
  }
}

- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification {
  NSLog(@"mediaIsPrepareToPlayDidChange\n");
}


- (void)moviePlayBackStateDidChange:(NSNotification*)notification {
  
  
  switch (_player.playbackState) {
      
    case IJKMPMoviePlaybackStateStopped:
      NSLog(@"IJKMPMoviePlayBackStateDidChange %d: stoped", (int)_player.playbackState);
      break;
      
    case IJKMPMoviePlaybackStatePlaying:
      NSLog(@"IJKMPMoviePlayBackStateDidChange %d: playing", (int)_player.playbackState);
      break;
      
    case IJKMPMoviePlaybackStatePaused:
      NSLog(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)_player.playbackState);
      break;
      
    case IJKMPMoviePlaybackStateInterrupted:
      NSLog(@"IJKMPMoviePlayBackStateDidChange %d: interrupted", (int)_player.playbackState);
      break;
      
    case IJKMPMoviePlaybackStateSeekingForward:
    case IJKMPMoviePlaybackStateSeekingBackward: {
      NSLog(@"IJKMPMoviePlayBackStateDidChange %d: seeking", (int)_player.playbackState);
      break;
    }
      
    default: {
      NSLog(@"IJKMPMoviePlayBackStateDidChange %d: unknown", (int)_player.playbackState);
      break;
    }
  }
}

#pragma Install Notifiacation

- (void)installMovieNotificationObservers {
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(loadStateDidChange:)
                                               name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                             object:_player];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(moviePlayBackFinish:)
                                               name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                             object:_player];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(mediaIsPreparedToPlayDidChange:)
                                               name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                             object:_player];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(moviePlayBackStateDidChange:)
                                               name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                             object:_player];
  
}

- (void)removeMovieNotificationObservers {
  
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                                object:_player];
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                                object:_player];
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                                object:_player];
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                                object:_player];
  
}


// 按钮
- (void)changeBackBtn
{
  // 返回
  UIButton * backBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
  backBtn.frame = CGRectMake(10, 64 / 2 - 8, 33, 33);
  backBtn.backgroundColor = [UIColor redColor];
  [backBtn addTarget:self action:@selector(goBack) forControlEvents:(UIControlEventTouchUpInside)];
  [self.view addSubview:backBtn];
  
}

// 返回
- (void)goBack
{
  // 停播
  [self.player shutdown];
  
  [self.navigationController popViewControllerAnimated:true];
  
}



@end
