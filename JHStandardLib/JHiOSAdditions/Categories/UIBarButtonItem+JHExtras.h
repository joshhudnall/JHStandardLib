//
//  UIBarButtonItem+JHExtras.h
//  WAY-FMMobile
//
//  Created by Josh Hudnall on 9/4/12.
//  Copyright (c) 2012 Josh Hudnall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (JHExtras)

/**
 *  Creates a UIBarButtonItem with a UIButton as the custom view with a target and selector for the TouchUpInside event
 *
 *  @param title    The title of the UIButton
 *  @param target   The target for the UIButton
 *  @param selector The selector for the UIButton
 *
 *  @return A UIBarButtonItem
 */
+ (UIBarButtonItem *)jh_barButtonItemForTitle:(NSString *)title target:(id)target andSelector:(SEL)selector;
/**
 *  Creates a UIBarButtonItem with a UIButton as the custom view with a target and selector for the TouchUpInside event
 *
 *  @param image    The image to use for the UIButton
 *  @param target   The target for the UIButton
 *  @param selector The selector for the UIButton
 *
 *  @return A UIBarButtonItem
 */
+ (UIBarButtonItem *)jh_barButtonItemForImage:(UIImage *)image target:(id)target andSelector:(SEL)selector;

@end
