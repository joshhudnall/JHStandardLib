//
//  NSDate+JHExtras.m
//  MyDieline
//
//  Created by Josh Hudnall on 6/3/12.
//  Copyright (c) 2012 Method Apps. All rights reserved.
//

#import "NSDate+JHExtras.h"

@implementation NSDate (JHExtras)

- (NSString *)jh_relativeTimeFromNow {
    NSDate *origDate = self;
    NSDate *todayDate = [NSDate date];
    double ti = [origDate timeIntervalSinceDate:todayDate];
    ti = ti * -1;
    if(ti < 1) { // Use "now" if less than a second
        return @"now";
    } else if (ti < 60) { // Use "now" if less than a minute
        return @"now";
    } else if (ti < 60 * 60) { // Use minutes if under an hour
        int diff = round(ti / 60);
        return [NSString stringWithFormat:@"%dm", diff];
    } else if (ti < 60 * 60 * 24) { // Use hours if under a day
        int diff = round(ti / 60 / 60);
        return[NSString stringWithFormat:@"%dh", diff];
    } else if (ti < 60 * 60 * 24 * 7) { // Use days if under a week
        int diff = round(ti / 60 / 60 / 24);
        return[NSString stringWithFormat:@"%dd", diff];
    } else if (ti < 60 * 60 * 24 * 7 * 52 * 2) { // Use weeks if under two years
        int diff = round(ti / 60 / 60 / 24 / 7);
        return[NSString stringWithFormat:@"%dw", diff];
    } else { // Use years for everything else
        int diff = round(ti / 60 / 60 / 24 / 7);
        return[NSString stringWithFormat:@"%dy", diff];
    }
}

+ (NSDate *)jh_dateFromMySqlString:(NSString *)dateString {
    NSDateFormatter *dateFormatter;
    if (dateString.length == 10) {
        static NSDateFormatter *mysqlDateFormatter = nil;
        if (mysqlDateFormatter == nil) {
            mysqlDateFormatter = [[NSDateFormatter alloc] init];
            mysqlDateFormatter.dateFormat = @"yyyy-MM-dd";
        }
        dateFormatter = mysqlDateFormatter;
    } else if (dateString.length == 8) {
        static NSDateFormatter *mysqlTimeFormatter = nil;
        if (mysqlTimeFormatter == nil) {
            mysqlTimeFormatter = [[NSDateFormatter alloc] init];
            mysqlTimeFormatter.dateFormat = @"HH:mm:ss";
        }
        dateFormatter = mysqlTimeFormatter;
    } else {
        static NSDateFormatter *mysqlDateTimeFormatter = nil;
        if (mysqlDateTimeFormatter == nil) {
            mysqlDateTimeFormatter = [[NSDateFormatter alloc] init];
            mysqlDateTimeFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        }
        dateFormatter = mysqlDateTimeFormatter;
    }
    
    return [dateFormatter dateFromString:dateString];
}

+ (NSDate *)jh_dateFromTwitter:(NSString *)dateString {
    static NSDateFormatter *twitterDateFormatter = nil;
    if (twitterDateFormatter == nil) {
        twitterDateFormatter = [[NSDateFormatter alloc] init];

        // http://stackoverflow.com/a/11603484/350467
        // here we set the DateFormat - note the quotes around +0000
        [twitterDateFormatter setDateFormat:@"EEE MMM dd HH:mm:ss '+0000' yyyy"];
        // We need to set the locale to english - since the day- and month-names are in english
        [twitterDateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en-US"]];
    }
    
    return [twitterDateFormatter dateFromString:dateString];
}

- (NSString *)jh_dateFormatted:(NSString *)dateFormat {
    // Keep a static date formatter around
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    
    // Only update the format string if it's changed
    static NSString *savedDateFormat = nil;
    if (savedDateFormat == nil || ! [savedDateFormat isEqualToString:dateFormat]) {
        dateFormatter.dateFormat = dateFormat;
        savedDateFormat = [dateFormat copy];
    }
    
    return [dateFormatter stringFromDate:self];
}

@end




