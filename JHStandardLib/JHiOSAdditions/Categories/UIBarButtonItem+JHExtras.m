//
//  UIBarButtonItem+JHExtras.m
//  WAY-FMMobile
//
//  Created by Josh Hudnall on 9/4/12.
//  Copyright (c) 2012 Josh Hudnall. All rights reserved.
//

#import "UIBarButtonItem+JHExtras.h"

@implementation UIBarButtonItem (JHExtras)

+ (UIBarButtonItem *)jh_barButtonItemForTitle:(NSString *)title target:(id)target andSelector:(SEL)selector {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTitle:title forState:UIControlStateNormal];
    [backButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [backButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [backButton sizeToFit];
    
    CGRect frame = backButton.frame;
    frame.size.height = 34;
    frame = CGRectInset(frame, -10, 0);
    backButton.frame = frame;
    
    return [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

+ (UIBarButtonItem *)jh_barButtonItemForImage:(UIImage *)image target:(id)target andSelector:(SEL)selector {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[backButton setBackgroundImage:nil forState:UIControlStateNormal];
	[backButton setBackgroundImage:nil forState:UIControlStateHighlighted];
	[backButton setBackgroundImage:nil forState:UIControlStateSelected];
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [backButton setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    
    return [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

@end
