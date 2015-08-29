//
//  JHMath.h
//  GetStarted
//
//  Created by Josh Hudnall on 4/4/14.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  A value range made up of first and last, inclusive
 */
struct JHValueRange {
    CGFloat first;
    CGFloat last;
};
typedef struct JHValueRange JHValueRange;

/**
 *  Create a JHValueRange
 *
 *  @param first The first number in the range, inclusive
 *  @param last  The last number in the range, inclusive
 *
 *  @return A JHValueRange with the first and last values added
 */
extern JHValueRange JHValueRangeMake(CGFloat first, CGFloat last);

@interface JHMath : NSObject

/**
*  Takes a value within the range fromRange and converts it to a corresponding value within toRange
*
*  @param value     The value to convert
*  @param fromRange The range the value was originally in
*  @param toRange   The range the value should conform to
*
*  @return Returns the converted value
*
*  @since 1.0
*/
+ (CGFloat)convertValue:(CGFloat)value fromRange:(JHValueRange)fromRange toRange:(JHValueRange)toRange;

@end
