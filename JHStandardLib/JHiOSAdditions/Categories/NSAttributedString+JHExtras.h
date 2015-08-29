//
//  JHExtras.m
//  Air1
//
//  Created by Josh Hudnall on 2/18/15.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSAttributedString (JHExtras)

+ (NSAttributedString *)jh_attributedStringFromHTML:(NSString *)html;
+ (NSAttributedString *)jh_attributedStringFromHTML:(NSString *)html withFonts:(NSDictionary *)fonts andColor:(UIColor *)color;
@end
