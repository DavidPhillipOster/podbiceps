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

UIColor *InkColor() {
  if (@available(iOS 13.0, *)) {
    return [UIColor labelColor];
  } else {
    return [UIColor blackColor];
  }
}


// Common code. draw the outer circle.
static CGContextRef PieFrame(CGFloat dimension, CGFloat strokeWidth) {
  CGRect r = CGRectMake(0, 0, dimension, dimension);
  CGFloat scale = [[UIScreen mainScreen] scale];
  UIGraphicsBeginImageContextWithOptions(r.size, NO, scale);
  [[UIColor clearColor] set];
  UIRectFill(r);
  [InkColor() set];
  CGContextRef c = UIGraphicsGetCurrentContext();
  if (strokeWidth) {
    r = CGRectInset(r, strokeWidth, strokeWidth);
    CGContextSetLineWidth(c, strokeWidth);
    CGContextStrokeEllipseInRect(c, r);
  }
  return c;
}

UIImage *PieGraph(CGFloat amount, CGFloat dimension, CGFloat strokeWidth) {
  CGContextRef c = PieFrame(dimension, strokeWidth);
  CGRect r = CGRectMake(0, 0, dimension, dimension);
  r = CGRectInset(r, strokeWidth, strokeWidth);
  if (amount <= 0.0) {
    // done.
  } else if (1.0 <= amount) {
    CGContextFillEllipseInRect(c, r);
  } else {
    CGPoint center = r.origin;
    CGFloat radius = r.size.width/2;;
    center.x += radius;
    center.y += radius;
    CGFloat startAngle = (CGFloat)(-90.0 * 2*M_PI/360.0);
    CGFloat endAngle = startAngle + (CGFloat)(amount * 2*M_PI);
    CGContextBeginPath(c);
    CGContextMoveToPoint(c, center.x, center.y);
    CGContextAddArc(c, center.x, center.y, radius, startAngle, endAngle, NO);
    CGContextAddLineToPoint(c, center.x, center.y);
    CGContextClosePath(c);
    CGContextFillPath(c);
  }
  UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return result;
}

UIImage *PieGraphDontKnow(CGFloat dimension, CGFloat strokeWidth) {
  CGContextRef c = PieFrame(dimension, strokeWidth);
  CGRect r = CGRectMake(0, 0, dimension, dimension);
  r = CGRectInset(r, strokeWidth, strokeWidth);
  CGContextBeginPath(c);
  CGContextMoveToPoint(c, r.origin.x, r.origin.y + r.size.height/2);
  CGContextAddLineToPoint(c, r.origin.x + r.size.width, r.origin.y + r.size.height/2);
  CGContextStrokePath(c);
  UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return result;
}

void PodLog(const char *s) {
  if (s) {
    static NSTimeInterval lastTime = 0;
    if (0 == lastTime) {
      lastTime = [NSDate timeIntervalSinceReferenceDate];
    }
    NSTimeInterval  now = [NSDate timeIntervalSinceReferenceDate];
    NSString *docFolderPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path = [docFolderPath stringByAppendingPathComponent:@"log.txt"];
    FILE *file = fopen([path fileSystemRepresentation], "a");
    if (file) {
      fprintf(file, "%5.3f %s\n", now - lastTime, s);
      fclose(file);
    }
    lastTime = now;
  }
}



