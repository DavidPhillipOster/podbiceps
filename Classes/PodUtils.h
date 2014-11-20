// PodUtils.h

#import <Foundation/Foundation.h>

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

