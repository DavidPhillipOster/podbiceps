//  PodPersistentOrder.m
//  Created by David Phillip Oster, DavidPhillipOster+podbiceps@gmail.com on 11/22/14.
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

#import "PodPersistent.h"

#import <MediaPlayer/MediaPlayer.h>

static NSString *const kIDKey = @"id";
static NSString *const kBookmarkKey = @"mk";

static PodPersistent *sPodPersistent = nil;

@interface PodPersistent()
@property(nonatomic) NSMutableDictionary *deletedDetails;
@property(nonatomic) NSMutableArray *podItems;
@property(nonatomic) BOOL isDeletedDetailsSynchronized;
@property(nonatomic) BOOL isOrderSynchronized;
@end

@implementation PodPersistent

+ (instancetype)sharedInstance {
  if (nil == sPodPersistent) {
    sPodPersistent = [[PodPersistent alloc] init];
  }
  return sPodPersistent;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UIApplication *app = [UIApplication sharedApplication];
    [nc addObserver:self selector:@selector(synchronize) name:UIApplicationDidEnterBackgroundNotification object:app];

    NSMutableArray *order = [NSMutableArray arrayWithContentsOfURL:[self orderURL]];
    _isOrderSynchronized = YES;
    if (order) {
      _podItems = order;
    } else {
      _podItems = [NSMutableArray array];
    }
  
    _deletedDetails = [NSMutableDictionary dictionaryWithContentsOfURL:[self deletedDetailsURL]];
    if (nil == _deletedDetails) {
      _deletedDetails = [NSMutableDictionary dictionary];
    }
    _isDeletedDetailsSynchronized = YES;
  }
  return self;
}

- (void)dealloc {
  NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
  [nc removeObserver:self];
}


- (void)rememberMediaItems:(NSArray *)mediaItems {
  NSMutableArray *newOrder = [NSMutableArray array];
  for (MPMediaItem *item in mediaItems) {
    NSMutableDictionary *dict = [self itemAsDict:item];
    NSTimeInterval furthest = MAX([self bookmarkTimeOfMediaItem:item], item.bookmarkTime);
    if (furthest) {
      dict[kBookmarkKey] = [NSNumber numberWithDouble:furthest];
    }
    [newOrder addObject:dict];
  }
  if (![newOrder isEqual:_podItems]) {
    _podItems = newOrder;
    _isOrderSynchronized = NO;
  }
}

- (NSMutableDictionary *)itemAsDict:(MPMediaItem *)item {
  MPMediaEntityPersistentID persistentID = [item persistentID];
  NSNumber *n = [NSNumber numberWithLongLong:persistentID];
  NSMutableDictionary *dict = [NSMutableDictionary dictionary];
  dict[kIDKey] = n;
  NSTimeInterval bookmark = [item bookmarkTime];
  if (bookmark) {
    dict[kBookmarkKey] = [NSNumber numberWithDouble:bookmark];
  }
  return dict;
}

- (NSUInteger)indexOrderOfMediaItem:(MPMediaItem *)mediaItem {
  NSUInteger result = NSNotFound;
  MPMediaEntityPersistentID persistentID = [mediaItem persistentID];
  NSNumber *n = [NSNumber numberWithLongLong:persistentID];
  int count = (int)[_podItems count];
  for (int i = 0; i < count; ++i) {
    NSDictionary *item = _podItems[i];
    if ([n isEqual:item[kIDKey]]) {
      result = i;
      break;
    }
  }
  return result;
}

- (NSTimeInterval)bookmarkTimeOfMediaItem:(MPMediaItem *)mediaItem {
  NSTimeInterval result = 0;
  NSUInteger index = [self indexOrderOfMediaItem:mediaItem];
  if (NSNotFound != index) {
    NSDictionary *item = _podItems[index];
    result = [item[kBookmarkKey] doubleValue];
  }
  return result;
}

- (BOOL)hasBookmarkTimeOfMediaItem:(MPMediaItem *)mediaItem {
  BOOL result = NO;
  NSUInteger index = [self indexOrderOfMediaItem:mediaItem];
  if (NSNotFound != index) {
    NSDictionary *item = _podItems[index];
    result = (nil != item[kBookmarkKey]);
  }
  return result;
}

- (void)setBookmarkTime:(NSTimeInterval)time ofMediaItem:(MPMediaItem *)mediaItem {
  NSUInteger index = [self indexOrderOfMediaItem:mediaItem];
  NSMutableDictionary *newDict = [self itemAsDict:mediaItem];
  newDict[kBookmarkKey] = [NSNumber numberWithDouble:time];
  if (NSNotFound == index) {
    [_podItems addObject:newDict];
    _isOrderSynchronized = NO;
  } else {
    NSDictionary *oldDict = [_podItems objectAtIndex:index];
    if (![newDict isEqual:oldDict]) {
      [_podItems replaceObjectAtIndex:index withObject:newDict];
      _isOrderSynchronized = NO;
    }
  }
}


- (void)synchronize {
  if (!_isOrderSynchronized) {
    [_podItems writeToURL:[self orderURL] atomically:YES];
    _isOrderSynchronized = YES;
  }
  if (!_isDeletedDetailsSynchronized) {
    [_deletedDetails writeToURL:[self deletedDetailsURL] atomically:YES];
    _isDeletedDetailsSynchronized = YES;
  }
}

- (NSString *)dataFolderPath {
  NSString *rootFolderPath = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) firstObject];
  NSString *folderPath = [rootFolderPath stringByAppendingPathComponent:@"podbicepsorder"];
  NSFileManager *fm = [NSFileManager defaultManager];
  [fm createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:NULL];
  return folderPath;
}

- (NSURL *)urlOfFile:(NSString *)file {
  NSURL *result = nil;
  NSString *folderPath = [self dataFolderPath];
  NSString *loadPath = [folderPath stringByAppendingPathComponent:file];
  if ([loadPath length]) {
    result = [NSURL fileURLWithPath:loadPath];
  }
  return result;
}

- (NSURL *)orderURL {
  return [self urlOfFile:@"order.plist"];
}

- (NSURL *)deletedDetailsURL {
  return [self urlOfFile:@"deletedDetails.plist"];
}

- (BOOL)isDeletedItem:(MPMediaItem *)item {
  MPMediaEntityPersistentID persistentID = [item persistentID];
  NSNumber *n = [NSNumber numberWithLongLong:persistentID];
  NSString *s = nil;
  if (n) {
    s = [NSString stringWithFormat:@"%@", n];
  }
  return nil != [_deletedDetails objectForKey:s];
}

- (void)deleteItem:(MPMediaItem *)item {
  MPMediaEntityPersistentID persistentID = [item persistentID];
  NSNumber *n = [NSNumber numberWithLongLong:persistentID];
  NSString *key = nil;
  if (n) {
    key = [NSString stringWithFormat:@"%@", n];
  }
  if (n && nil == [_deletedDetails objectForKey:key]) {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *title = [item title];
    if ([title length]) {
      [dict setObject:title forKey:@"title"];
    }
    NSDate *date = [item lastPlayedDate];
    if (date) {
      [dict setObject:date forKey:@"played"];
    }
    NSString *podcastTitle = [item podcastTitle];
    if ([podcastTitle length]) {
      [dict setObject:podcastTitle forKey:@"podcast"];
    }
    [_deletedDetails setObject:dict forKey:key];
    _isDeletedDetailsSynchronized = NO;
  }
}


@end
