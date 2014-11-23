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
    [_timeUsed setFont:[UIFont systemFontOfSize:[UIFont smallSystemFontSize]]];
    [self addSubview:_timeUsed];
    _timeToGo = [[UILabel alloc] init];
    [_timeToGo setFont:[UIFont systemFontOfSize:[UIFont smallSystemFontSize]]];
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
  CGRect top, bottom;
  CGRectDivide(bounds, &bottom, &top, 130, CGRectMaxYEdge);
  top = UIEdgeInsetsInsetRect(top, UIEdgeInsetsMake(0, 20, 10, 20));
  CGRect timeBand, sliderFrame;
  CGRectDivide(bottom, &bottom, &sliderFrame, 70, CGRectMaxYEdge);
  bottom = UIEdgeInsetsInsetRect(bottom, UIEdgeInsetsMake(0, 0, 30, 0));

  CGRect left0, left15, right15, right0;
  CGFloat bottomWidth = (CGFloat) floor(bottom.size.width / 5);
  CGRectDivide(bottom, &left0, &bottom, bottomWidth, CGRectMinXEdge);
  CGRectDivide(bottom, &right0, &bottom, bottomWidth, CGRectMaxXEdge);
  CGRectDivide(bottom, &left15, &bottom, bottomWidth, CGRectMinXEdge);
  CGRectDivide(bottom, &right15, &bottom, bottomWidth, CGRectMaxXEdge);
  left0 = UIEdgeInsetsInsetRect(left0, UIEdgeInsetsMake(0, 10, 0, 0));
  right0 = UIEdgeInsetsInsetRect(right0, UIEdgeInsetsMake(0, 0, 0, 10));
  sliderFrame = UIEdgeInsetsInsetRect(sliderFrame, UIEdgeInsetsMake(0, 10, 0, 10));
  CGRectDivide(sliderFrame, &timeBand,  &sliderFrame, 20, CGRectMinYEdge);
  CGRect leftTimeLabel, rightTimeLabel;
  CGRectDivide(timeBand, &leftTimeLabel, &timeBand, 80, CGRectMinXEdge);
  CGRectDivide(timeBand, &rightTimeLabel, &timeBand, 80, CGRectMaxXEdge);
  [_info setFrame:top];
  [_playPause setFrame:bottom];
  [_timeSlider setFrame:sliderFrame];
  [_timeUsed setFrame:leftTimeLabel];
  [_timeToGo setFrame:rightTimeLabel];

  [_goToStart setFrame:left0];
  [_skipBackward setFrame:left15];
  [_skipForward setFrame:right15];
  [_goToEnd setFrame:right0];
}

@end
