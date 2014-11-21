// PodPlaylistTableViewCell.m
#import "PodPlaylistTableViewCell.h"

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
    self.textLabel.numberOfLines = 3;
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
  self.textLabel.frame = tr;
  self.detailTextLabel.frame = br;
}

@end
