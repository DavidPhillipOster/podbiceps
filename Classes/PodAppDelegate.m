//  PodAppDelegate.m
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


#import "PodAppDelegate.h"

#import "PodPeripheral.h"
#import "PodPersistent.h"
#import "PodSettingsTableViewController.h"
#import "PodPlaylistTableViewController.h"
#import "PodPlayerViewController.h"
#import "PodUtils.h"

#import <AVFoundation/AVFoundation.h>

@implementation PodAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  DLOG(@"didFinishLaunching");
  [PodPeripheral sharedInstance]; // Create instance so it can begin connecting early in our run.
  [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
  if (&AVAudioSessionModeSpokenAudio) {
    NSError *error = nil;
    if (![[AVAudioSession sharedInstance] setMode:AVAudioSessionModeSpokenAudio error:&error]) {
      NSLog(@"%@", error);
    }
  }
  CGRect bounds = [[UIScreen mainScreen] bounds];
  [self setWindow:[[UIWindow alloc] initWithFrame:bounds]];
  [self setPlaylistController:[[PodPlaylistTableViewController alloc] init]];
  PodSettingsTableViewController *settingsController = [[PodSettingsTableViewController alloc] init];
  UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:settingsController];
  [nav pushViewController:_playlistController animated:NO];
  [_window setRootViewController:nav];
  [_window makeKeyAndVisible];
  return YES;
}


/* Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
 Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
 */
- (void)applicationWillResignActive:(UIApplication *)application {
  DLOG(@"willResignActive");
}


/* Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
 If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
 */
- (void)applicationDidEnterBackground:(UIApplication *)application {
  DLOG(@"enterBackground");
 }


/* Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
 */
- (void)applicationWillEnterForeground:(UIApplication *)application {
  DLOG(@"enterForeground");
}


/* Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
 */
- (void)applicationDidBecomeActive:(UIApplication *)application {
  DLOG(@"didBecomeActive");
}


/* Called when the application is about to terminate.
 See also applicationDidEnterBackground:.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
  DLOG(@"willTerminate");
}


#pragma mark - Memory management

/* Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
 */
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
  DLOG(@"MemoryWarning");
}




@end
