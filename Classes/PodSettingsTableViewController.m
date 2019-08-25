//  PodSettingsTableViewController.m
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

#import "PodSettingsTableViewController.h"

#import "PodAppDelegate.h"
#import "PodPeripheral.h"
#import "PodPlaylistTableViewController.h"

@interface PodSettingsTableViewController ()
- (void)myoSetup;
@end

@interface SettingsMyoTableViewCell : UITableViewCell
@property(nonatomic, weak) PodSettingsTableViewController *owner;
@end

@implementation SettingsMyoTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  {
  self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
  if (self) {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = self.contentView.bounds;
    [button setAutoresizingMask:0x3F];
    [button setTitle:NSLocalizedString(@"Hardware setup", 0) forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(myoSetup) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:button];
  }
  return self;
}

- (void)myoSetup {
  [_owner myoSetup];
}
@end



@implementation PodSettingsTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setTitle:NSLocalizedString(@"Settings", 0)];
  UIImage *settingsImage0 = [[UIImage imageNamed:@"settings"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
  UIBarButtonItem *settingBarItem = [[UIBarButtonItem alloc] initWithImage:settingsImage0 style:UIBarButtonItemStylePlain target:nil action:NULL];
  [self.navigationItem setBackBarButtonItem:settingBarItem];
  NSString *playList = [NSString stringWithFormat:@"%@ >", NSLocalizedString(@"Playlist", 0)];
  UIBarButtonItem *tableItem = [[UIBarButtonItem alloc] initWithTitle:playList style:UIBarButtonItemStylePlain target:self action:@selector(pushPlaylist:)];
  [self.navigationItem setRightBarButtonItem:tableItem];

  // will be resized
  UILabel *footer = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
  [footer setTextAlignment:NSTextAlignmentCenter];
  [footer setNumberOfLines:0];
  [footer setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin];
  [self.tableView setTableFooterView:footer];
  NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
  NSString *versionString = [infoDict objectForKey:@"CFBundleShortVersionString"];
  NSString *buildString = [infoDict objectForKey:@"CFBundleVersion"];
  NSString *version = [NSString stringWithFormat:@"Version %@ (%@):\n by David Phillip Oster 11/2014",
      versionString, buildString];
  [footer setText:version];
  [self.tableView registerClass:[SettingsMyoTableViewCell class] forCellReuseIdentifier:@"0"];
  
  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;
  
  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)myoSetup {
  [[PodPeripheral sharedInstance] setupPushingOn:self.navigationController];
}

- (void)pushPlaylist:(id)sender {
  PodAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
  [self.navigationController pushViewController:appDelegate.playlistController animated:YES];
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = nil;
  NSString *key = [NSString stringWithFormat:@"%d", (int)indexPath.row];
  if (0 == indexPath.row) {
    SettingsMyoTableViewCell *myoCell =  (SettingsMyoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:key forIndexPath:indexPath];
    myoCell.owner = self;
    cell = myoCell;
  }
  return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
