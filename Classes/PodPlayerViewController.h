//  PodPlayerViewController.h
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

@class MPMediaItem;

@interface PodPlayerViewController : UIViewController
// list of podCasts
@property(nonatomic) NSArray *casts;

// play this one.
@property(nonatomic) MPMediaItem *cast;

+ (instancetype)sharedInstance;

- (IBAction)togglePlay:(id)sender;
- (IBAction)play:(id)sender;
- (IBAction)pause:(id)sender;

- (IBAction)skipForward:(id)sender;
- (IBAction)skipBack:(id)sender;

- (IBAction)speedUp:(id)sender;
- (IBAction)slowDown:(id)sender;
- (IBAction)normalSpeed:(id)sender;

- (IBAction)gotoStart:(id)sender;
- (IBAction)gotoEnd:(id)sender;
@end

// Object is the MPMediaItem
extern NSString *const kDidFinishPlayingNotification;