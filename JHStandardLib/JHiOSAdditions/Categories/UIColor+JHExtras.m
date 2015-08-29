//
//  UIColor+JHExtras.m
//  Connoshoer
//
//  Created by Josh Hudnall on 12/13/12.
//  Copyright (c) 2012 Connoshoer. All rights reserved.
//

#import "UIColor+JHExtras.h"

@implementation UIColor (JHExtras)

+ (BOOL)jh_stringIsHexColor:(NSString *)string {
    if ([[string substringToIndex:1] isEqualToString:@"#"]) {
        string = [string substringWithRange:NSMakeRange(1, [string length] - 1)];
    }
    NSScanner* scanner = [NSScanner scannerWithString:string];
    unsigned hex;
    
    return ([scanner scanHexInt:&hex]);
}

+ (UIColor *)jh_colorWithHexString:(NSString *)string {
    if ([[string substringToIndex:1] isEqualToString:@"#"]) {
        string = [string substringWithRange:NSMakeRange(1, [string length] - 1)];
    }
    NSScanner *scanner = [NSScanner scannerWithString:string];
    unsigned hex;
    
    if (![scanner scanHexInt:&hex]) return nil;
    
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}
- (NSString *)jh_hexValue {
    
    if (self == [UIColor whiteColor]) {
        // Special case, as white doesn't fall into the RGB color space
        return @"ffffff";
    }
    
    CGFloat red;
    CGFloat blue;
    CGFloat green;
    CGFloat alpha;
    
    [self getRed:&red green:&green blue:&blue alpha:&alpha];
    
    int redDec = (int)(red * 255);
    int greenDec = (int)(green * 255);
    int blueDec = (int)(blue * 255);
    
    NSString *returnString = [NSString stringWithFormat:@"%02x%02x%02x", (unsigned int)redDec, (unsigned int)greenDec, (unsigned int)blueDec];
    
    return returnString;
    
}

- (BOOL)jh_isEqualToColor:(UIColor *)otherColor {
    CGColorSpaceRef colorSpaceRGB = CGColorSpaceCreateDeviceRGB();
    
    UIColor *(^convertColorToRGBSpace)(UIColor*) = ^(UIColor *color) {
        if(CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) == kCGColorSpaceModelMonochrome) {
            const CGFloat *oldComponents = CGColorGetComponents(color.CGColor);
            CGFloat components[4] = {oldComponents[0], oldComponents[0], oldComponents[0], oldComponents[1]};
            return [UIColor colorWithCGColor:CGColorCreate(colorSpaceRGB, components)];
        } else
            return color;
    };
    
    UIColor *selfColor = convertColorToRGBSpace(self);
    otherColor = convertColorToRGBSpace(otherColor);
    CGColorSpaceRelease(colorSpaceRGB);
    
    return [selfColor isEqual:otherColor];
}

@end
