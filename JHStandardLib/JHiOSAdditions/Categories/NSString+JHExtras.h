//
//  NSString+JHExtras.h
//
//  Created by Josh Hudnall on 6/6/12.
//  Copyright (c) 2012 Method Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JHExtras)

/**
 *  Use to sort strings ignoring leading articles like "A", "An" and "The"
 *
 *  @param aString string to compare
 *  @param articlesOrNull array of articles you want compared, null to for a, an, the
 *
 *  @return NSComparisonResult
 */
- (NSComparisonResult)compareString:(NSString *)aString ignoringArticles:(NSArray *)articlesOrNull;

/**
 *  Returns a string with leading articles (like "A", "An" and "The") removed
 *
 *  @param articlesOrNull array of articles you want compared, null to for a, an, the
 *
 *  @return String
 */
- (NSString *)removeArticles:(NSArray *)articlesOrNull;

/**
 *  Strips the whitespace character set from a string
 *
 *  @return A string with all whitespace removed
 */
- (NSString *)jh_stripWhitespace;

/**
 *  Truncates a string to the length specified by removing characters at the end and replacing with an elipses
 *
 *  @param length How long to leave the string
 *
 *  @return Truncated string
 */
- (NSString *)jh_truncateToLength:(NSUInteger)length;
/**
 *  Truncates a string to the length specified. If the inMiddle flag is set, the beginning and end of the string are maintained.
 *  An elipses replaces the truncated characters
 *
 *  @param length   How long to leave the string
 *  @param inMiddle If true, truncate the string in the middle
 *
 *  @return Truncated string
 */
- (NSString *)jh_truncateToLength:(NSUInteger)length inMiddle:(BOOL)inMiddle;
/**
 *  Truncates a string to the specified length
 *
 *  @param length   How long to leave the string
 *  @param inMiddle If true, truncate the string in the middle
 *  @param replacementString The characters to replace the truncated characters with
 *
 *  @return Truncated string
 */
- (NSString *)jh_truncateToLength:(NSUInteger)length inMiddle:(BOOL)inMiddle replaceWithString:(NSString *)replacementString;

/**
 *  Returns a a plural or singular string for the number passed
 *
 *  @param singular A singular string format descriptor, e.g. @"%d piece"
 *  @param plural   A plural string format descriptor, e.g. @"%d pieces"
 *  @param count    The number to format
 *
 *  @return A string containing the number passed and it's unit formatted as specified
 */
+ (NSString *)jh_singular:(NSString *)singularFormat orPlural:(NSString *)pluralFormat forCount:(NSInteger)count;
/**
 *  Returns a a plural or singular string for the number passed. Differentiates between 0 and other non-singular numbers
 *
 *  @param zero     A zero-count string format descriptor, e.g. @"No pieces"
 *  @param singular A singular string format descriptor, e.g. @"%d piece"
 *  @param plural   A plural string format descriptor, e.g. @"%d pieces"
 *  @param count    The number to format
 *
 *  @return A string containing the number passed and it's unit formatted as specified
 */
+ (NSString *)jh_zero:(NSString *)zeroFormat singular:(NSString *)singularFormat orPlural:(NSString *)pluralFormat forCount:(NSInteger)count;

/**
 *  Strips HTML from a string
 *
 *  @return HTML-stripped string
 */
- (NSString *)jh_stringByStrippingHTML;

/**
 *  Strips all non alphanumeric characters, removes diacritics and replaces whitespace with a dash (-)
 *
 *  @return Slug version of the string
 */
- (NSString *)jh_slug;

/**
 *  Returns whether the receiver is empty or not, convenience method for isEqualToString:\@""
 *
 *  Use of jh_isFull is preferred to this method as it returns an accurate result for nil objects.
 *
 *  @return YES if the string is empty, NO otherwise
 */
- (BOOL)jh_isEmpty;

/**
 *  Returns whether the receiver is empty or not, convenience method for nil || !isEqualToString:\@"".
 *  The reason for this method is it allows for a one-step check for an empty string or nil object.
 *
 *  @return NO if the string is empty or nil, YES otherwise
 */
- (BOOL)jh_isFull;

@end
