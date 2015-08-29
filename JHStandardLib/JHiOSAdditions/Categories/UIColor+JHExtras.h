//
//  UIColor+JHExtras.h
//  Connoshoer
//
//  Created by Josh Hudnall on 12/13/12.
//  Copyright (c) 2012 Connoshoer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (JHExtras)

/**
 *  Determines whether the passed string is a valid hex color string
 *
 *  @param string The string to test
 *
 *  @return YES if valid, NO if not
 */
+ (BOOL)jh_stringIsHexColor:(NSString *)string;
/**
 *  Returns a UIColor from a hex color string
 *
 *  @param string The string to convert to a color
 *
 *  @return A UIColor as described in the hex string
 */
+ (UIColor *)jh_colorWithHexString:(NSString *)string;
/**
 *  Returns the hex value of a color
 *
 *  @return hex value
 */
- (NSString *)jh_hexValue;

/**
 *  Compare two colors to determine if they are the same
 *
 *  @param otherColor The color to test against the receiver
 *
 *  @return YES if equal, NO if not
 */
- (BOOL)jh_isEqualToColor:(UIColor *)otherColor;

@end
