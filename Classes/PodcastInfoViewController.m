//  PodcastInfoViewController.m
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


#import "PodcastInfoViewController.h"

#import <MediaPlayer/MediaPlayer.h>

@implementation PodcastInfoViewController



// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    [self setTitle:NSLocalizedString(@"Info", 0)];
  }
  return self;
}

- (void)loadView {
  CGRect bounds = [[UIScreen mainScreen] bounds];
  UIView *view = [[UIView alloc] initWithFrame:bounds];
  [view setBackgroundColor:[UIColor colorWithHue:0.6 saturation:0.3 brightness:1 alpha:1]];
  [self setView:view];
}

- (BOOL)shouldAutorotate {
  return YES; // iOS 6 up
}

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

- (IBAction)showResponder:(id)sender {
  [sender becomeFirstResponder];
  for(UIResponder *responder = sender;responder != nil;responder = [responder nextResponder]) {
    NSLog(@"%@%@", [responder isFirstResponder] ? @"first: " : @"",responder);
  }
}



@end
