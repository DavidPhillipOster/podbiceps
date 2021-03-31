// PodPlaylistTableViewCell.m
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
#import "PodPlaylistTableViewCell.h"
#import "PodUtils.h"

enum {
  kImageDimen = 24,
  kMarginX = 4,
  kMarginY = 4,
};

@implementation PodPlaylistTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  {
  self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
  if (self) {
// Uncomment to enable the info podcast controller button on each tableview cell.
//    [self setAccessoryType:UITableViewCellAccessoryDetailButton];
    self.textLabel.font = [UIFont boldSystemFontOfSize:20];
    self.textLabel.textColor = InkColor();
    self.textLabel.numberOfLines = 2;
    self.bottomIconView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.bottomIconView];
    [self.bottomIconView setContentMode:UIViewContentModeScaleAspectFill];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
  }
  return self;
}

- (CGSize)imageSize {
  return CGSizeMake(kImageDimen, kImageDimen);
}

// 4 'quadrants': tl = small thumbnail bl = small 'played/playing' indicator tr = title br = info.
- (void)layoutSubviews {
  [super layoutSubviews];
  CGRect bounds = [self.contentView bounds];
  CGRect leftR, rightR;
  CGRect tl, tr, bl, br;
  CGRectDivide(bounds, &leftR, &rightR, kImageDimen+(2*kMarginX), CGRectMinXEdge);
  CGRectDivide(leftR, &tl, &bl, kImageDimen+(2*kMarginY), CGRectMinYEdge);
  UIEdgeInsets margins = UIEdgeInsetsMake(kMarginY, kMarginY, kMarginY, kMarginY);
  tl = UIEdgeInsetsInsetRect(tl, margins);
  bl = UIEdgeInsetsInsetRect(bl, margins);
  bl.size.height = br.size.width = kImageDimen;
  
  CGRectDivide(rightR, &br, &tr, 16+4, CGRectMaxYEdge);
  tr = UIEdgeInsetsInsetRect(tr, UIEdgeInsetsMake(0, kMarginY, 0, kMarginY));
  br = UIEdgeInsetsInsetRect(br, UIEdgeInsetsMake(0, kMarginY, 4, kMarginY));
  
  self.imageView.frame = tl;
  self.bottomIconView.frame = bl;
  // Disable vertical centering of the title.
  tr.size.height = [self.textLabel sizeThatFits:tr.size].height;
  self.textLabel.frame = tr;
  self.detailTextLabel.frame = br;
}

- (void)prepareForReuse {
  [super prepareForReuse];
  self.editing = NO;
}


@end
