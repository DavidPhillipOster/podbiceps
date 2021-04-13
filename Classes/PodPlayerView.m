//  PodPlayerView.m
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

#import "PodPlayerView.h"

@implementation PodPlayerView

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin |
        UIViewAutoresizingFlexibleWidth |
        UIViewAutoresizingFlexibleRightMargin |
        UIViewAutoresizingFlexibleTopMargin |
        UIViewAutoresizingFlexibleHeight |
        UIViewAutoresizingFlexibleBottomMargin];
    _info = [[UILabel alloc] init];
    _info.numberOfLines = 0;
    [self addSubview:_info];
    
    _timeSlider = [[UISlider alloc] init];
    [self addSubview:_timeSlider];

    _timeUsed = [[UILabel alloc] init];
    [_timeUsed setFont:[UIFont systemFontOfSize:[UIFont buttonFontSize]]];
    [self addSubview:_timeUsed];
    _timeToGo = [[UILabel alloc] init];
    [_timeToGo setFont:[UIFont systemFontOfSize:[UIFont buttonFontSize]]];
    [_timeToGo setTextAlignment:NSTextAlignmentRight];
    [self addSubview:_timeToGo];

    _skipForward = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *skipForwardImage = [[UIImage imageNamed:@"skipForward.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_skipForward setImage:skipForwardImage forState:UIControlStateNormal];
    [_skipForward setContentMode:UIViewContentModeCenter];
    [self addSubview:_skipForward];
    _skipBackward = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *skipBackwardImage = [[UIImage imageNamed:@"skipBack.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_skipBackward setImage:skipBackwardImage forState:UIControlStateNormal];
    [_skipBackward setContentMode:UIViewContentModeCenter];
    [self addSubview:_skipBackward];
    _goToStart = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *goToStartImage = [[UIImage imageNamed:@"gotoStart.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_goToStart setImage:goToStartImage forState:UIControlStateNormal];
    [_goToStart setContentMode:UIViewContentModeCenter];
    [self addSubview:_goToStart];
    _goToEnd = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *goToEnd = [[UIImage imageNamed:@"gotoEnd.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_goToEnd setImage:goToEnd forState:UIControlStateNormal];
    [_goToEnd setContentMode:UIViewContentModeCenter];
    [self addSubview:_goToEnd];
    _slowDown = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *slowDownImage = [UIImage imageNamed:@"slowDown.fill" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil];
    if (nil == slowDownImage) {
      slowDownImage = [UIImage imageNamed:@"speedDown"];
    }
    [_slowDown setImage:slowDownImage forState:UIControlStateNormal];
    [_slowDown setContentMode:UIViewContentModeCenter];
    [self addSubview:_slowDown];
    _normalSpeed = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *normalSpeedImage = [UIImage imageNamed:@"normalSpeed.fill" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil];
    if (nil == normalSpeedImage) {
      normalSpeedImage = [UIImage imageNamed:@"speedNormal"];
    }
    [_normalSpeed setImage:normalSpeedImage forState:UIControlStateNormal];
    [_normalSpeed setContentMode:UIViewContentModeCenter];
    [self addSubview:_normalSpeed];
    _speedUp = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *speedUpImage = [UIImage imageNamed:@"speedUp.fill" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil];
    if (nil == speedUpImage) {
      speedUpImage = [UIImage imageNamed:@"speedUp"];
    }
    [_speedUp setImage:speedUpImage forState:UIControlStateNormal];
    [_speedUp setContentMode:UIViewContentModeCenter];
    [self addSubview:_speedUp];

    _playPause = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *play = [[UIImage imageNamed:@"play.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_playPause setImage:play forState:UIControlStateNormal];
    UIImage *pause = [[UIImage imageNamed:@"pause.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_playPause setImage:pause forState:UIControlStateSelected];
    [_playPause setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:_playPause];
    [self setTintColor:[UIColor blackColor]];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  UIEdgeInsets inset = UIEdgeInsetsMake(_delegate.navigationHeight, 0, 10, 0);
  CGRect bounds = UIEdgeInsetsInsetRect([self bounds], inset);
  /* Divide bounds into 5 horizontal bands.  First, imagine it is all assigned
   to the top band, textInfoBand.  Then whittle off slices for the the other
   four bands, starting at the bottom. */
  CGRect speedControlsBand, mainControlsBand, scrubberBand, timesBand, textInfoBand;
  CGRectDivide(bounds, &speedControlsBand, &textInfoBand, 60, CGRectMaxYEdge);
  CGRectDivide(textInfoBand, &mainControlsBand, &textInfoBand, 60, CGRectMaxYEdge);
  CGRectDivide(textInfoBand, &scrubberBand, &textInfoBand, 60, CGRectMaxYEdge);
  CGRectDivide(textInfoBand, &timesBand, &textInfoBand, 40, CGRectMaxYEdge);
  speedControlsBand = UIEdgeInsetsInsetRect(speedControlsBand, UIEdgeInsetsMake(0, 20, 0, 20));
  mainControlsBand = UIEdgeInsetsInsetRect(mainControlsBand, UIEdgeInsetsMake(0, 20, 0, 20));
  scrubberBand = UIEdgeInsetsInsetRect(scrubberBand, UIEdgeInsetsMake(0, 20, 0, 20));
  timesBand = UIEdgeInsetsInsetRect(timesBand, UIEdgeInsetsMake(0, 20, 0, 20));
  textInfoBand = UIEdgeInsetsInsetRect(textInfoBand, UIEdgeInsetsMake(10, 20, 10, 20));

  CGRect left0, left15, right15, right0;
  NSInteger mainControlsCount = 5;
  CGFloat mainControlWidth = (CGFloat) floor(mainControlsBand.size.width / mainControlsCount);
  CGRectDivide(mainControlsBand, &left0, &mainControlsBand, mainControlWidth, CGRectMinXEdge);
  CGRectDivide(mainControlsBand, &right0, &mainControlsBand, mainControlWidth, CGRectMaxXEdge);
  CGRectDivide(mainControlsBand, &left15, &mainControlsBand, mainControlWidth, CGRectMinXEdge);
  CGRectDivide(mainControlsBand, &right15, &mainControlsBand, mainControlWidth, CGRectMaxXEdge);
  left0 = UIEdgeInsetsInsetRect(left0, UIEdgeInsetsMake(0, 10, 0, 0));
  right0 = UIEdgeInsetsInsetRect(right0, UIEdgeInsetsMake(0, 0, 0, 10));
  CGRect leftTimeLabel, rightTimeLabel;
  CGRectDivide(timesBand, &leftTimeLabel, &timesBand, 80, CGRectMinXEdge);
  CGRectDivide(timesBand, &rightTimeLabel, &timesBand, 80, CGRectMaxXEdge);
  [_info setFrame:textInfoBand];
  CGRect slowDownFrame, speedUpFrame ;
  NSInteger speedControlsCount = 3;
  CGFloat speedControlWidth = (CGFloat) floor(speedControlsBand.size.width / speedControlsCount);
  CGRectDivide(speedControlsBand, &slowDownFrame, &speedControlsBand, speedControlWidth, CGRectMinXEdge);
  CGRectDivide(speedControlsBand, &speedUpFrame, &speedControlsBand, speedControlWidth, CGRectMaxXEdge);
  [_slowDown setFrame:slowDownFrame];
  [_normalSpeed setFrame:speedControlsBand];
  [_speedUp setFrame:speedUpFrame];
  [_playPause setFrame:mainControlsBand];
  [_timeSlider setFrame:scrubberBand];
  [_timeUsed setFrame:leftTimeLabel];
  [_timeToGo setFrame:rightTimeLabel];

  [_goToStart setFrame:left0];
  [_skipBackward setFrame:left15];
  [_skipForward setFrame:right15];
  [_goToEnd setFrame:right0];
}

@end
