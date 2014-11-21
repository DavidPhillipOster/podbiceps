//
//  PodPlayerViewController.m
//
//  Created by David Phillip Oster, DavidPhillipOster+podbiceps@gmail.com on 11/19/14.
//  Copyright (c) 2014 David Phillip Oster.
//  Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.


#import "PodPlayerViewController.h"

#import "PodPlayerView.h"
#import "PodUtils.h"

#import <MediaPlayer/MediaPlayer.h>

NSString *const kDidFinishPlayingNotification = @"DidFinishPlayingNotification";

static PodPlayerViewController *sPodPlayerViewController = nil;

@interface PodPlayerViewController () <PodPlayerDelegate>
@property(nonatomic) MPMusicPlayerController *player;
@property(nonatomic) MPNowPlayingInfoCenter *nowPlayingInfo;
@property(nonatomic) NSTimer *updateTimeSliderTimer;
@property(nonatomic, getter=isPlaying) BOOL playing;
@property(nonatomic, readonly) NSTimeInterval duration;
@property(nonatomic) NSTimeInterval readHead;
@property(nonatomic) CGFloat rate;
@end

@implementation PodPlayerViewController
@synthesize playing = _playing;

+ (instancetype)sharedInstance {
  if (nil == sPodPlayerViewController) {
    sPodPlayerViewController = [[PodPlayerViewController alloc] init];
  }
  return sPodPlayerViewController;
}


// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    [self setTitle:NSLocalizedString(@"now playing", 0)];
    _rate = 1;
  }
  return self;
}

- (void)dealloc {
  [_player endGeneratingPlaybackNotifications];
  NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
  [nc removeObserver:self];
  [self setUpdateTimeSliderTimer:nil];
}

- (void)loadView {
  CGRect bounds = [[UIScreen mainScreen] bounds];
  PodPlayerView *view = [[PodPlayerView alloc] initWithFrame:bounds];
  [view setDelegate:self];
  [view setBackgroundColor:[UIColor colorWithHue:0.6 saturation:0.3 brightness:1 alpha:1]];
  [view.playPause addTarget:self action:@selector(togglePlay:) forControlEvents:UIControlEventTouchUpInside];
  [view.timeSlider addTarget:self action:@selector(timeSliderChanged:) forControlEvents:UIControlEventValueChanged];

  [view.skipForward addTarget:self action:@selector(skipForward:) forControlEvents:UIControlEventTouchUpInside];
  [view.skipBackward addTarget:self action:@selector(skipBack:) forControlEvents:UIControlEventTouchUpInside];

  [view.goToStart addTarget:self action:@selector(gotoStart:) forControlEvents:UIControlEventTouchUpInside];
  [view.goToEnd addTarget:self action:@selector(gotoEnd:) forControlEvents:UIControlEventTouchUpInside];
  
  [self setView:view];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillDisappear:animated];
  if (self.isPlaying) {
    [self startUpdateTimer];
  }
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [self setUpdateTimeSliderTimer:nil];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
  return YES; // iOS 5
}

- (BOOL)shouldAutorotate {
  return YES; // iOS 6 up
}

- (PodPlayerView *)playerView {
  return (PodPlayerView *)self.view;
}

- (void)setCast:(MPMediaItem *)cast {
  if (_cast != cast) {
    _cast = cast;
    if (_cast) {
      if (nil == _player) {
        if ([MPMusicPlayerController respondsToSelector:@selector(systemMusicPlayer)]) {
          [self setPlayer:[MPMusicPlayerController systemMusicPlayer]];
        } else {
          [self setPlayer:[MPMusicPlayerController iPodMusicPlayer]];
        }
        [_player setShuffleMode: MPMusicShuffleModeOff];
        [_player setRepeatMode: MPMusicRepeatModeNone];
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(playingItemDidChange:) name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:_player];
        [nc addObserver:self selector:@selector(playbackStateChanged::) name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:_player];
        [_player beginGeneratingPlaybackNotifications];
      }
      if (nil == _nowPlayingInfo) {
        [self setNowPlayingInfo:[MPNowPlayingInfoCenter defaultCenter]];
      }
    }
    if (_cast) {
      NSMutableAttributedString *s = [[NSMutableAttributedString alloc] init];
      [s appendAttributedString:AttrBold(_cast.title)];
      NSMutableArray *body = [NSMutableArray array];
      [body addObject:@""];
      if (_cast.albumTitle) { [body addObject:_cast.albumTitle]; }
      if (_cast.releaseDate) { [body addObject:HumanReadableDate(_cast.releaseDate)]; }
      if (_cast.playbackDuration) {[body addObject:HumanReadableDuration(_cast.playbackDuration)];}
      [s appendAttributedString:Attr([body componentsJoinedByString:@" - "])];

      PodPlayerView *playerView = self.playerView;
      playerView.info.attributedText = s;
      MPMediaItemCollection *collection = [MPMediaItemCollection collectionWithItems:_casts];
      [_player setQueueWithItemCollection:collection];
      [_player setNowPlayingItem:_cast];
      [_player play];
      playerView.timeSlider.maximumValue = _cast.playbackDuration;
      playerView.timeSlider.value = _cast.bookmarkTime;
      [self play:nil];
      [self updateTimeSlider:nil];
    }
  }
}


- (void)playingItemDidChange:(NSNotification *)note {
// TODO: write playingItemDidChange
}

- (void)playbackStateChanged:(NSNotification *)note {
// TODO: write playbackStateChanged
}


- (BOOL)isPlaying {
  if (_player) {
  }
  return _playing;
}

- (void)setPlaying:(BOOL)isPlaying {
  if ([self isPlaying] != isPlaying) {
    _playing = isPlaying;
    [self.playerView.playPause setSelected:_playing];
    if (_playing) {
      [_player play];
      [self startUpdateTimer];
    } else {
      [_player pause];
      [self setUpdateTimeSliderTimer:nil];
    }
  }
}

- (void)startUpdateTimer {
  [self setUpdateTimeSliderTimer:[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimeSlider:) userInfo:nil repeats:YES]];
}

- (void)setUpdateTimeSliderTimer:(NSTimer *)timer {
  if (_updateTimeSliderTimer != timer) {
    [_updateTimeSliderTimer invalidate];
    _updateTimeSliderTimer = timer;
    [timer setTolerance:timer.timeInterval/5];
  }
}

- (void)updateTimeSlider:(NSTimer *)timer {
  PodPlayerView *playerView = self.playerView;
  float readHead = self.readHead;
  playerView.timeUsed.text = NumericDurationString(readHead);
  playerView.timeToGo.text = NumericDurationString(readHead - self.duration);
  playerView.timeSlider.value = readHead;
}

- (void)setRate:(CGFloat)rate {
  if (_rate != rate) {
    _rate = rate;
// TODO
  }
}

- (NSTimeInterval)readHead {
  return [_player currentPlaybackTime];
}

- (void)setReadHead:(NSTimeInterval)readHead {
  readHead = MAX(0.0, MIN(readHead, [self duration]));
  if ([self readHead] != readHead) {
    [_player setCurrentPlaybackTime:readHead];
  }
}

- (NSTimeInterval)duration {
  return [_player.nowPlayingItem playbackDuration];
}

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

- (CGFloat)navigationHeight {
  return self.navigationController.navigationBar.bounds.size.height;
}

- (void)timeSliderChanged:(UISlider *)timeSlider {
  [self setReadHead:[timeSlider value]];
  PodPlayerView *playerView = self.playerView;
  float readHead = self.readHead;
  playerView.timeUsed.text = NumericDurationString(readHead);
  playerView.timeToGo.text = NumericDurationString(readHead - self.duration);
}

#pragma mark -

- (IBAction)togglePlay:(id)sender {
  [self setPlaying:![self isPlaying]];
}

- (IBAction)play:(id)sender {
  [self setPlaying:YES];
}

- (IBAction)pause:(id)sender {
  [self setPlaying:NO];
}

- (IBAction)skipForward:(id)sender {
  [self setReadHead:[self readHead] + 15];
}

- (IBAction)skipBack:(id)sender {
  [self setReadHead:[self readHead] - 15];
}

- (IBAction)speedUp:(id)sender {
  CGFloat rate = MIN(3.0, [self rate] + 0.25);
  [self setRate:rate];
}

- (IBAction)slowDown:(id)sender {
  CGFloat rate = MAX(0.5, [self rate] - 0.25);
  [self setRate:rate];
}

- (IBAction)normalSpeed:(id)sender {
  [self setRate:1];
}

- (IBAction)gotoStart:(id)sender {
  [self setReadHead:0];
}

- (IBAction)gotoEnd:(id)sender {
  [self setReadHead:self.duration];
}


@end