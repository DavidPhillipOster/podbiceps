//
//  PodPlayerView.h
//  podbiceps
//
//  Created by david on 11/15/14.
//
//

#import <UIKit/UIKit.h>

@protocol PodPlayerDelegate;

@interface PodPlayerView : UIView
@property(nonatomic, weak) id<PodPlayerDelegate> delegate;
@property(nonatomic) UILabel *info;
@property(nonatomic) UIButton *playPause;

@property(nonatomic) UILabel *timeUsed;
@property(nonatomic) UILabel *timeToGo;
@property(nonatomic) UISlider *timeSlider;
@property(nonatomic) UIButton *skipForward;
@property(nonatomic) UIButton *skipBackward;
@property(nonatomic) UIButton *goToStart;
@property(nonatomic) UIButton *goToEnd;
@end

@protocol PodPlayerDelegate <NSObject>
- (CGFloat)navigationHeight;
@end