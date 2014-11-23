// PodUtils.h
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

#import <UIKit/UIKit.h>

// Make an attributed string with my default color, font and font size.
NSAttributedString *Attr(NSString *s);

// Make an attributed string with my default color, bold font and font size.
NSAttributedString *AttrBold(NSString *s);

// Date -> example: @"3/29/2014"
NSString *HumanReadableDate(NSDate *date);

// doubleOfSeconds -> example: @"1hr 29 sec"
NSString *HumanReadableDuration(NSTimeInterval duration);

// doubleOfSeconds -> example: @"1:00:29"
NSString *NumericDurationString(NSTimeInterval duration);

// Given an amount between 0 and 1, returns a Dimension x Dimension UIImage.
// black on transparent
UIImage *PieGraph(CGFloat amount, CGFloat dimension, CGFloat strokeWidth);

// Similar to above, but return a different symbol for when we don't know the amount.
UIImage *PieGraphDontKnow(CGFloat dimension, CGFloat strokeWidth);

#if 1
void PodLog(const char *s);
#define DLOG(...) PodLog([[NSString stringWithFormat: __VA_ARGS__] UTF8String])
//#define DLOG(...) NSLog(__VA_ARGS__)
#else
#define DLOG(...) do{}while(0)
#endif

