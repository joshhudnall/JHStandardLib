//
//  NSDate+JHExtras.h
//  MyDieline
//
//  Created by Josh Hudnall on 6/3/12.
//  Copyright (c) 2012 Method Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (JHExtras)

/**
 *  Returns the date as a relative time (5m, 2h, ...) from now
 *
 *  @return Relative time as a string
 */
- (NSString *)jh_relativeTimeFromNow;

/**
 *  Converts a MYSQL date, datetime or time into an NSDate object
 *
 *  @param dateString A MYSQL date string. Can be in the format 'yyyy-mm-dd', 'yyyy-mm-dd hh:mm:ss' or 'hh:mm:ss'.
 *
 *  @return The date as an NSDate
 */
+ (NSDate *)jh_dateFromMySqlString:(NSString *)dateString;

/**
 *  Converts a Twitter API date into an NSDate object
 *
 *  @param dateString A date string from the Twitter API
 *
 *  @return The date and an NSDate
 */
+ (NSDate *)jh_dateFromTwitter:(NSString *)dateString;

/**
 *  Convenience function to return the date as a formatted string using the speficied format
 *
 *  @param dateFormat NSDateFormatter format string
 *
 *  @return Formatted date string
 */
- (NSString *)jh_dateFormatted:(NSString *)dateFormat;

@end
