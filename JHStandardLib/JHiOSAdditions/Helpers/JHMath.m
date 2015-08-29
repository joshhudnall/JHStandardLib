//
//  JHMath.m
//  GetStarted
//
//  Created by Josh Hudnall on 4/4/14.
//
//

#import "JHMath.h"

/* Make a ValueRange */
JHValueRange JHValueRangeMake(CGFloat first, CGFloat last) {
    JHValueRange range;
    range.first = first;
    range.last = last;
    return range;
}

@implementation JHMath

+ (CGFloat)convertValue:(CGFloat)value fromRange:(JHValueRange)fromRange toRange:(JHValueRange)toRange {
    // x = C + (y - A) * (D - C) / (B - A)  ::  A - B (range 1) normalized to C - D (range 2)
    
    CGFloat newVal = toRange.first + (value - fromRange.first) * (toRange.last - toRange.first) / (fromRange.last - fromRange.first);
    return fmaxf(toRange.first, fminf(toRange.last, newVal));
}

@end


