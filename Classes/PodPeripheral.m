//
//  PodPeripheral.m
//  podbiceps
//
//  Created by david on 12/6/14.
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

#import "PodPeripheral.h"
#import "PodUtils.h"

#import <CoreMotion/CoreMotion.h>
#import <GLKit/GLKit.h>

static NSString *const kMyoIdentifierKey = @"myoID";
static PodPeripheral *sPodPeripheral = nil;

@interface PodPeripheral()
@property(nonatomic) CMMotionManager *coreMotionManager;
@property(nonatomic) NSOperationQueue *coreMotionQueue;
@end
@implementation PodPeripheral

+ (instancetype)sharedInstance {
  if (nil == sPodPeripheral) {
    sPodPeripheral = [[self alloc] init];
  }
  return sPodPeripheral;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _coreMotionQueue = [[NSOperationQueue alloc] init];
    _coreMotionQueue.name = @"coreMotionQueue";
    _coreMotionManager = [[CMMotionManager alloc] init];
    _coreMotionManager.deviceMotionUpdateInterval = 1/50.;
    [_coreMotionManager startDeviceMotionUpdatesToQueue:_coreMotionQueue
                                            withHandler:^(CMDeviceMotion *motion, NSError *error){
        if (motion) {
          [self coreMotionEvent:motion];
        }
        if (error) {
          [self coreMotionError:error];
        }
     }];
  }
  return self;
}

- (void)dealloc {
  [_coreMotionManager stopDeviceMotionUpdates];
  NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
  [nc removeObserver:self];
}

- (void)setupPushingOn:(UINavigationController *)controller {
}

// coreMotion callbacks
#pragma mark -

// note that these all have timeStamps.
- (void)coreMotionEvent:(CMDeviceMotion *)motion {
// motion.attitude
// motion.rotationRate
// motion.userAcceleration
// maybe:
// motion.gravity
}

- (void)coreMotionError:(NSError *)error {
}

@end
