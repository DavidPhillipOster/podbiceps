// PodUtils.h

#import "PodUtils.h"

NSAttributedString *Attr(NSString *s) {
  return [[NSAttributedString alloc] initWithString:s attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18]}];
}


NSAttributedString *AttrBold(NSString *s) {
  return [[NSAttributedString alloc] initWithString:s attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:22]}];
}

NSString *HumanReadableDate(NSDate *date) {
  NSString *result = nil;
  if (date) {
    static NSDateFormatter *formatter = nil;
    if (nil == formatter) {
      formatter = [[NSDateFormatter alloc] init];
      [formatter setTimeStyle:NSDateFormatterNoStyle];
      [formatter setDateStyle:NSDateFormatterShortStyle];
    }
    result = [formatter stringFromDate:date];
  }
  return result;
}


NSString *HumanReadableDuration(NSTimeInterval duration) {
  NSString *result = nil;
  if (duration <= 0) {
    //
  } else if (duration < 60) {
    result = [NSString stringWithFormat:@"%dsec", (int)round(duration)];
  } else if (duration < 60 * 60) {
    int sec = (int)round(fmod(duration, 60));
    if (sec) {
    result = [NSString stringWithFormat:@"%dmin %dsec", (int)round(duration/60), sec];
    } else {
    result = [NSString stringWithFormat:@"%dmin", (int)round(duration/60)];
    }
  } else {
    int minutes = (int)round(duration/60);
    if (minutes % 60) {
      result = [NSString stringWithFormat:@"%dhr %dmin", minutes/60, minutes % 60];
    } else {
      result = [NSString stringWithFormat:@"%dhr", minutes/60];
    }
  }
  return result;
}

NSString *NumericDurationString(NSTimeInterval duration) {
  BOOL wasNegative = duration < 0;
  if (wasNegative) {
    duration = - duration;
  }
  int d = (int)round(duration);
  NSString *result = @"";
  if (d < 60) {
    result = [NSString stringWithFormat:@":%02d", d];
  } else if (d < 60*60) {
    result = [NSString stringWithFormat:@"%d:%02d", d/60, d % 60];
  } else  {
    result = [NSString stringWithFormat:@"%d:%02d:%02d", d/(60*60), (d % (60*60))/60, d % 60];
  }
  if (wasNegative) {
    result = [@"-" stringByAppendingString:result];
  }
  return result;
}

