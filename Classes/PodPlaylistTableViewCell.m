// PodPlaylistTableViewCell.m
#import "PodPlaylistTableViewCell.h"

@implementation PodPlaylistTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  {
  self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
  if (self) {
// Uncomment to enable the info podcast controller button on each tableview cell.
//    [self setAccessoryType:UITableViewCellAccessoryDetailButton];
    self.textLabel.font = [UIFont boldSystemFontOfSize:20];
    self.textLabel.numberOfLines = 3;
    self.bottomIconView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.bottomIconView];
    [self.bottomIconView setContentMode:UIViewContentModeCenter];
    [self.imageView setContentMode:UIViewContentModeCenter];
  }
  return self;
}

// 4 'quadrants': tl = small thumbnail bl = small 'played/playing' indicator tr = title br = info.
- (void)layoutSubviews {
  [super layoutSubviews];
  CGRect bounds = [self.contentView bounds];
  CGRect leftR, rightR;
  CGRect tl, tr, bl, br;
  CGRectDivide(bounds, &leftR, &rightR, 24+(2*4), CGRectMinXEdge);
  CGRectDivide(leftR, &tl, &bl, 24+(2*4), CGRectMinYEdge);
  UIEdgeInsets margins = UIEdgeInsetsMake(4, 4, 4, 4);
  tl = UIEdgeInsetsInsetRect(tl, margins);
  bl = UIEdgeInsetsInsetRect(bl, margins);
  
  CGRectDivide(rightR, &br, &tr, 16+4, CGRectMaxYEdge);
  tr = UIEdgeInsetsInsetRect(tr, UIEdgeInsetsMake(0, 4, 0, 4));
  br = UIEdgeInsetsInsetRect(br, UIEdgeInsetsMake(0, 4, 4, 4));
  
  self.imageView.frame = tl;
  self.bottomIconView.frame = bl;
  self.textLabel.frame = tr;
  self.detailTextLabel.frame = br;
}

@end
