//  PodApp.m
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

#import "PodApp.h"
#import "PodUtils.h"

@implementation PodApp

- (instancetype)init {
  self = [super init];
  if (self) {
    [self beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
  }
  return self;
}

- (void)sendEvent:(UIEvent *)event {
  if (event.type == UIEventTypeRemoteControl) {
    // 11/30/2014 experiments show we never get here.
    DLOG(@"sendEvent:%d", (int)event.subtype);
  }
  [super sendEvent:event];
}


// This should never be called. Just for debugging.
// 11/30/2014 experiments show it's never called.
- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
  if (event.type == UIEventTypeRemoteControl) {
    switch (event.subtype) {
    case UIEventSubtypeRemoteControlPlay:
      DLOG(@"App Play");
      break;
    case UIEventSubtypeRemoteControlPause:
      DLOG(@"App Pause");
      break;
    case UIEventSubtypeRemoteControlNextTrack:
      DLOG(@"App NextTrack");
      break;
    case UIEventSubtypeRemoteControlPreviousTrack:
      DLOG(@"App PreviousTrack");
      break;
    case UIEventSubtypeRemoteControlBeginSeekingBackward:
      DLOG(@"App BeginSeekingBack");
      break;
    case UIEventSubtypeRemoteControlEndSeekingBackward:
      DLOG(@"App EndSeekingBack");
    case UIEventSubtypeRemoteControlBeginSeekingForward:
      DLOG(@"App BeginSeekingForward");
     break;
    case UIEventSubtypeRemoteControlEndSeekingForward:
      DLOG(@"App EndSeekingForward");
      break;
    case UIEventSubtypeRemoteControlTogglePlayPause:
      DLOG(@"App TogglePlayPause");
      break;
    default:
      DLOG(@"App other %d", (int)event.subtype);
      break;
    }
  }
}
@end
