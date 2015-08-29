//
//  UIImage+JHExtras.h
//
//  Created by Josh Hudnall on 9/1/12.
//  Copyright (c) 2012 Josh Hudnall. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (JHExtras)

/**
 *  Creates a 1x1 pt image of a solid color
 *
 *  @param color The color to make the image
 *
 *  @return An image
 */
+ (UIImage *)jh_imageWithColor:(UIColor *)color;
/**
 *  Creates an image of a solid color
 *
 *  @param color The color to make the image
 *  @param size  The size to make the image
 *
 *  @return An image
 */
+ (UIImage *)jh_imageWithColor:(UIColor *)color ofSize:(CGSize)size;

/**
 *  Slices the specified sprite out of a sprite sheet
 *
 *  @param rect The rect of the sprite to return
 *
 *  @return The sliced sprite
 */
- (UIImage *)jh_spriteInRect:(CGRect)rect;

@end
