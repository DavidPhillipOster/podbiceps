//
//  PodPlaylistTableViewController.m
//  podbiceps
//
//  Created by david on 11/15/14.
//
//

#import "PodPlaylistTableViewController.h"

#import "PodcastInfoViewController.h"
#import "PodPlayerViewController.h"
#import "PodSettingsTableViewController.h"
#import "PodUtils.h"

#import "PodPlaylistTableViewCell.h"
#import <MediaPlayer/MediaPlayer.h>

@interface PodPlaylistTableViewController ()
@property(nonatomic) MPMusicPlayerController *player;
@property(nonatomic) MPMediaItem *currentlyPlaying;
@property(nonatomic) NSMutableDictionary *mediaProperties;
// Key is podcast 'album' name.
@property(nonatomic) NSMutableDictionary *albumImageCache;
@end

@implementation PodPlaylistTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _albumImageCache = [NSMutableDictionary dictionary];
    [self setTitle:NSLocalizedString(@"Playlist", 0)];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    MPMediaLibrary *library = [MPMediaLibrary defaultMediaLibrary];
    [nc addObserver:self
           selector:@selector(libraryDidChange)
               name:MPMediaLibraryDidChangeNotification
             object:library];
    [library beginGeneratingLibraryChangeNotifications];
    if ([MPMusicPlayerController respondsToSelector:@selector(systemMusicPlayer)]) {
      [self setPlayer:[MPMusicPlayerController systemMusicPlayer]];
    } else {
      [self setPlayer:[MPMusicPlayerController iPodMusicPlayer]];
    }
    [_player setShuffleMode: MPMusicShuffleModeOff];
    [_player setRepeatMode: MPMusicRepeatModeNone];
    [_player beginGeneratingPlaybackNotifications];
    [nc addObserver:self
           selector:@selector(playingItemDidChange:)
               name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification
             object:_player];
    [nc addObserver:self
           selector:@selector(playbackStateChanged:)
               name:MPMusicPlayerControllerPlaybackStateDidChangeNotification
             object:_player];
  }
  return self;
}

- (void)dealloc {
  NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
  [nc removeObserver:self];
  MPMediaLibrary *library = [MPMediaLibrary defaultMediaLibrary];
  [library endGeneratingLibraryChangeNotifications];
  [_player endGeneratingPlaybackNotifications];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setMediaProperties:[NSMutableDictionary dictionary]];
  [self.tableView registerClass:[PodPlaylistTableViewCell class] forCellReuseIdentifier:@"cast"];
  [self.tableView setRowHeight:84];
#if 0 // We don't have any settings yet. When we do, turn this back on.
  UIImage *settingsImage = [[UIImage imageNamed:@"settings"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
  UIBarButtonItem *settings = [[UIBarButtonItem alloc] initWithImage:settingsImage
      style:UIBarButtonItemStylePlain target:self action:@selector(showSettings:)];
  [self.navigationItem setLeftBarButtonItem:settings];
#endif
  [self.navigationItem setRightBarButtonItem:self.editButtonItem];
  [self libraryDidChange];
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
  [_albumImageCache removeAllObjects];
}

- (void)undoablyMoveItemAt:(NSIndexPath *)source to:(NSIndexPath *)destination {
  NSUndoManager *undoManager = self.undoManager;
  [[undoManager prepareWithInvocationTarget:self] undoablyMoveItemAt:destination to:source];
  NSUInteger srcRow = [source row];
  NSUInteger destRow = [destination row];
  if (srcRow+1 < destRow) {
    destRow--;
  }
  if ( ! ([undoManager isUndoing] || [undoManager isRedoing])) {
    MPMediaItem *item = [_casts objectAtIndex:srcRow];
    [undoManager setActionName:[NSString stringWithFormat:NSLocalizedString(@"Move “%@”", @""), [item title]]];
  }
  MPMediaItem *item = [_casts objectAtIndex:srcRow];
  [self.tableView moveRowAtIndexPath:source toIndexPath:destination];
  [_casts removeObjectAtIndex:srcRow];
  [_casts insertObject:item atIndex:destRow];
//  [delegate_ setNeedsUpdate];
}

- (void)showSettings:(id)sender {
  PodSettingsTableViewController *settings = [[PodSettingsTableViewController alloc] init];
  [self.navigationController pushViewController:settings animated:YES];
}

- (void)setCurrentlyPlaying:(MPMediaItem *)currentlyPlaying {
  if (_currentlyPlaying != currentlyPlaying) {
    _currentlyPlaying = currentlyPlaying;
    NSArray *indexPaths = [self.tableView indexPathsForVisibleRows];
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
  }
}

- (void)playingItemDidChange:(NSNotification *)notify {
  [self setCurrentlyPlaying:[_player nowPlayingItem]];
}

- (void)playbackStateChanged:(NSNotification *)notify {
  NSArray *indexPaths = [self.tableView indexPathsForVisibleRows];
  [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [_casts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  PodPlaylistTableViewCell *cell = (PodPlaylistTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cast" forIndexPath:indexPath];
  MPMediaItem *cast = [_casts objectAtIndex:indexPath.row];
  // Configure the cell...

  NSString *title = cast.title;
  NSString *dateString = HumanReadableDate(cast.releaseDate);
  NSString *durationString = HumanReadableDuration(cast.playbackDuration);
  NSMutableArray *a = [NSMutableArray array];
  NSString *albumTitle = cast.podcastTitle;
  if (albumTitle) {
    NSRange r = [albumTitle rangeOfString:@"Naked Scientists"];
    if (r.location != NSNotFound) {
      albumTitle = @"Naked Scientists";
      static NSRegularExpression *re = nil;
      if (nil == re) {
        re = [NSRegularExpression regularExpressionWithPattern:@"Naked Scientists.+[0-9]+\\.[0-9]+\\.[0-9]+ .." options:0 error:NULL];
      }
      title = [re stringByReplacingMatchesInString:title options:0 range:NSMakeRange(0, [title length]) withTemplate:@""];
    }
    r = [albumTitle rangeOfString:@"(audio)"];
    if (r.location != NSNotFound) {
      albumTitle = [albumTitle stringByReplacingCharactersInRange:r withString:@""];
    }
    r = [albumTitle rangeOfString:@"NPR: "];
    if (r.location != NSNotFound) {
      albumTitle = [albumTitle stringByReplacingCharactersInRange:r withString:@""];
    }
    r = [albumTitle rangeOfString:@"APM: "];
    if (r.location != NSNotFound) {
      albumTitle = [albumTitle stringByReplacingCharactersInRange:r withString:@""];
    }
    [a addObject:albumTitle];
  }
  if (dateString) {
    [a addObject:dateString];
  }
  if (durationString) {
    [a addObject:durationString];
  }
  cell.textLabel.text = title;
  cell.detailTextLabel.text = [a componentsJoinedByString:@" "];
  UIImage *image = nil;
  if (_currentlyPlaying == cast) {
    if (MPMusicPlaybackStatePlaying == [_player playbackState]) {
      image = [UIImage imageNamed:@"playing"];
    } else {
      image = [UIImage imageNamed:@"paused"];
    }
  } else if (cast.lastPlayedDate) {
    image = [UIImage imageNamed:@"played"];
  } else {
    if (cast.playbackDuration) {
      image = PieGraph(cast.bookmarkTime / cast.playbackDuration, cell.imageSize.width, 2);
    } else {
      image = PieGraphDontKnow(cell.imageSize.width, 2);
    }
  }
  image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
  cell.imageView.image = image;

  MPMediaItemArtwork *artwork = cast.artwork;
  UIImage *artworkImage = [artwork imageWithSize:cell.imageSize];
  if (artworkImage && [albumTitle length]) {
    [_albumImageCache setObject:artworkImage forKey:albumTitle];
  } else if (nil == artworkImage && [albumTitle length]) {
    artworkImage = _albumImageCache[albumTitle];
  }
  cell.bottomIconView.image = artworkImage;
  
  return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
  MPMediaItem *cast = [_casts objectAtIndex:indexPath.row];
  PodcastInfoViewController *infoController = [[PodcastInfoViewController alloc] init];
  [infoController setCast:cast];
  [self.navigationController pushViewController:infoController animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  PodPlayerViewController *player = [PodPlayerViewController sharedInstance];
  [player setPlayer:_player];
  MPMediaItem *cast = [_casts objectAtIndex:indexPath.row];
  [self setCurrentlyPlaying:cast];
  [player setCasts:_casts];
  [player setCast:[_casts objectAtIndex:indexPath.row]];
  [self.navigationController pushViewController:player animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    [_casts removeObjectAtIndex:indexPath.row];
    PodPlayerViewController *player = [PodPlayerViewController sharedInstance];
    [player setCasts:_casts];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
  }
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView
    moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
           toIndexPath:(NSIndexPath *)toIndexPath {
  [self undoablyMoveItemAt:fromIndexPath to:toIndexPath];
}

- (void)libraryDidChange {
  MPMediaQuery *query = [MPMediaQuery podcastsQuery];
  MPMediaPropertyPredicate *predicate = [MPMediaPropertyPredicate
      predicateWithValue:@NO forProperty:MPMediaItemPropertyIsCloudItem];
  [query addFilterPredicate:predicate];
  NSMutableArray *unplayed = [[query items] mutableCopy];
  for (int i = ((int)[unplayed count]) - 1; 0 <= i; --i) {
    MPMediaItem *cast = [unplayed objectAtIndex:i];
    if (cast.lastPlayedDate) {
      [unplayed removeObjectAtIndex:i];
    }
  }
  [unplayed sortUsingComparator:^(id obj1, id obj2) {
    MPMediaItem *a = obj1;
    MPMediaItem *b = obj2;
    NSComparisonResult result = [a.releaseDate compare:b.releaseDate];
    if (NSOrderedSame == result) {
      result = [a.albumTitle caseInsensitiveCompare:b.albumTitle];
      if (NSOrderedSame == result) {
        if (a.persistentID < b.persistentID) {
          result = NSOrderedAscending;
        } else if (b.persistentID < a.persistentID) {
          result = NSOrderedDescending;
        }
      }
    }
    // Reverse the order, so Newest first.
    return -result;
  }];
  [self setCasts:unplayed];
  [self.tableView reloadData];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
