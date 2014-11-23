//  PodPlayerView.h
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

#import <UIKit/UIKit.h>

@protocol PodPlayerDelegate;

@interface PodPlayerView : UIView
@property(nonatomic, weak) id<PodPlayerDelegate> delegate;
@property(nonatomic) UILabel *info;
@property(nonatomic) UIButton *playPause;

@property(nonatomic) UILabel *timeUsed;
@property(nonatomic) UILabel *timeToGo;
@property(nonatomic) UISlider *timeSlider;
@property(nonatomic) UIButton *skipForward;
@property(nonatomic) UIButton *skipBackward;
@property(nonatomic) UIButton *goToStart;
@property(nonatomic) UIButton *goToEnd;
@end

@protocol PodPlayerDelegate <NSObject>
- (CGFloat)navigationHeight;
@end