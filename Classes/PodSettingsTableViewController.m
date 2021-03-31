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
@property(nonatomic) UILabel *footer;
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
    [button setTitle:NSLocalizedString(@"Myo setup", 0) forState:UIControlStateNormal];
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
  UILabel *footer = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 320, 44)];
  self.footer = footer;
  [footer setNumberOfLines:0];
  [self.tableView setTableFooterView:footer];
  NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
  NSString *versionString = [infoDict objectForKey:@"CFBundleShortVersionString"];
  NSString *buildString = [infoDict objectForKey:@"CFBundleVersion"];
  NSString *version = [NSString stringWithFormat:@"Version %@ (%@):\n by David Phillip Oster 2014-2021",
      versionString, buildString];
  [footer setText:version];
  [self.tableView registerClass:[SettingsMyoTableViewCell class] forCellReuseIdentifier:@"0"];
  
  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;
  
  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  CGRect bounds = self.tableView.bounds;
  bounds.size.height = ceil([self.footer sizeThatFits:bounds.size].height);
  self.footer.bounds = bounds;
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


@end
