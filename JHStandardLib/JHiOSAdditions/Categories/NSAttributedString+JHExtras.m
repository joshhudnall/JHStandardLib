//
//  JHExtras.m
//  Air1
//
//  Created by Josh Hudnall on 2/18/15.
//
//

#import "NSAttributedString+JHExtras.h"
#import "UIColor+JHExtras.h"
#import <UIKit/UIKit.h>

@implementation NSAttributedString (JHExtras)

+ (NSAttributedString *)jh_attributedStringFromHTML:(NSString *)html {
    return [self jh_attributedStringFromHTML:html
                                   withFonts:@{
                                               @"*": [UIFont systemFontOfSize:14.f],
                                               @"b": [UIFont boldSystemFontOfSize:14.f],
                                               @"strong": [UIFont boldSystemFontOfSize:14.f],
                                               @"i": [UIFont italicSystemFontOfSize:14.f],
                                               @"em": [UIFont italicSystemFontOfSize:14.f],
                                               }
                                    andColor:[UIColor whiteColor]];
}

+ (NSAttributedString *)jh_attributedStringFromHTML:(NSString *)html withFonts:(NSDictionary *)fonts andColor:(UIColor *)color {
#ifdef __IPHONE_7_0
    NSMutableString *rules = [NSMutableString stringWithString:@"<style>"];
    [fonts enumerateKeysAndObjectsUsingBlock:^(NSString *element, UIFont *font, BOOL *stop) {
        [rules appendFormat:@"%@ { font-family: '%@'; font-size: %fpx; color: #%@ }", element, font.fontName, font.pointSize, color.jh_hexValue];
    }];
    [rules appendFormat:@"a { text-decoration:none; }</style>"];
    
    if (fonts.count) {
        html = [html stringByAppendingString:rules];
    }
    
    // Unlink anchor tags
    NSString *regexStr = @"<a ([^>]+)>([^>]+)</a>";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:NULL];
    html = [regex stringByReplacingMatchesInString:html options:0 range:NSMakeRange(0, [html length]) withTemplate:@"$2"];
    
    NSData *htmlData = [html dataUsingEncoding:NSUnicodeStringEncoding];
    return [[NSAttributedString alloc] initWithData:htmlData
                                            options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType}
                                 documentAttributes:nil
                                              error:nil];
#else
    return [[NSAttributedString alloc] initWithString:html];
#endif
}

@end
