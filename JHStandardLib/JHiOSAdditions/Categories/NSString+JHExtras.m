//
//  NSString+JHExtras.m
//  MyDieline
//
//  Created by Josh Hudnall on 6/6/12.
//  Copyright (c) 2012 Method Apps. All rights reserved.
//

#import "NSString+JHExtras.h"

@implementation NSString (JHExtras)

- (NSComparisonResult)compareString:(NSString *)aString ignoringArticles:(NSArray *)articlesOrNull {
    NSString *selfTrimmed = [self removeArticles:articlesOrNull];
    NSString *aStringTrimmed = [aString removeArticles:articlesOrNull];
    
    return [selfTrimmed compare:aStringTrimmed];
}

- (NSString *)removeArticles:(NSArray *)articlesOrNull {
    NSString *uppercaseSelf = [self uppercaseString];
    NSArray *articles = articlesOrNull ?: @[@"A", @"AN", @"THE"];
    
    __block NSRange range = NSMakeRange(NSNotFound, 0);
    [articles enumerateObjectsUsingBlock:^(NSString *article, NSUInteger idx, BOOL *stop) {
        NSString *comparisonArticle = [[NSString stringWithFormat:@"%@ ", [article stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]] uppercaseString];
        if ([uppercaseSelf hasPrefix:comparisonArticle]) {
            range = [uppercaseSelf rangeOfString:comparisonArticle];
        }
    }];
    
    if (range.location != NSNotFound) {
        return [self substringFromIndex:range.length];
    } else {
        return self;
    }
}

- (NSString *)jh_stripWhitespace {
    NSString *string = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"  " withString:@""];
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    return string;
}

- (NSString *)jh_truncateToLength:(NSUInteger)length {
	return [self jh_truncateToLength:length inMiddle:NO];
}

- (NSString *)jh_truncateToLength:(NSUInteger)length inMiddle:(BOOL)inMiddle {
	NSString *withChar = (inMiddle) ? @" ... " : @" ...";
	
	return [self jh_truncateToLength:length inMiddle:inMiddle replaceWithString:withChar];
}

- (NSString *)jh_truncateToLength:(NSUInteger)length inMiddle:(BOOL)inMiddle replaceWithString:(NSString *)withChar {
	NSString *inStr = self;
	
	// If the string is shorter than the length desired, just return it
	if (length >= [inStr length]) return inStr;
	
	// Subtract the truncate char (...) length from the available length
	NSUInteger actualLength = length - [withChar length];
    
	// If inMiddle is NO, truncate at the end
	if ( ! inMiddle) {
		NSString *subStr = [inStr substringToIndex:actualLength];
		
		return [NSString stringWithFormat:@"%@%@", subStr, withChar];
	} else {
		NSUInteger firstHalfLength = floor(actualLength / 2);
		NSUInteger lastHalfLength = actualLength - firstHalfLength;
		NSString *firstHalf = [inStr substringToIndex:firstHalfLength];
		
		NSRange lastHalfRange = {[inStr length] - lastHalfLength, lastHalfLength};
		NSString *lastHalf = [inStr substringWithRange:lastHalfRange];
		
		return [NSString stringWithFormat:@"%@%@%@", firstHalf, withChar, lastHalf];
	}
}

+ (NSString *)jh_singular:(NSString *)singularFormat orPlural:(NSString *)pluralFormat forCount:(NSInteger)count {
	return [NSString jh_zero:pluralFormat singular:singularFormat orPlural:pluralFormat forCount:count];
}

+ (NSString *)jh_zero:(NSString *)zeroFormat singular:(NSString *)singularFormat orPlural:(NSString *)pluralFormat forCount:(NSInteger)count {
	if (count == 0) {
		return [NSString stringWithFormat:zeroFormat, count];
	} else if (count == 1) {
		return [NSString stringWithFormat:singularFormat, count];
	} else {
		return [NSString stringWithFormat:pluralFormat, count];
	}
}

- (NSString *)jh_stringByStrippingHTML {
    NSRange r;
    NSString *s = [self copy];
    while ( (r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound )
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s;
}

- (NSString *)jh_slug {
    NSMutableString *newStr = [[self lowercaseString] mutableCopy];
    NSString *separator = @"-";
    
    // Strip accents and diacritics
    CFStringTransform((__bridge CFMutableStringRef)(newStr), NULL, kCFStringTransformStripCombiningMarks, NO);
    
    // Convert nonvalid characters to `separator`s
    NSString *validCharacters = @"abcdefghijklmnopqrstuvwxyz1234567890-_";
    NSCharacterSet *invalidCharacters = [[NSCharacterSet characterSetWithCharactersInString:validCharacters] invertedSet];
    newStr = [NSMutableString stringWithString:[[newStr componentsSeparatedByCharactersInSet:invalidCharacters] componentsJoinedByString:separator]];
    
    newStr = [NSMutableString stringWithString:[newStr stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"-"]]];
    
    return [(NSString *)newStr copy];
}

- (BOOL)jh_isEmpty {
    return [self isEqualToString:@""];
}

- (BOOL)jh_isFull {
    return ! [self isEqualToString:@""];
}

@end




